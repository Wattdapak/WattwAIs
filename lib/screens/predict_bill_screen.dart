import 'package:flutter/material.dart';

import '../models/bill_entry.dart';
import '../services/bill_service.dart';
import '../services/prediction_service.dart';
import '../widgets/bill_card.dart';

/// Screen for predicting electricity bills.
/// Allows the user to select a prediction target (current or next month),
/// enter 6 months of bill data, and set a monthly budget.
/// Saves bills, budget, and prediction history to Firestore.
class PredictBillScreen extends StatefulWidget {
  const PredictBillScreen({super.key});

  @override
  State<PredictBillScreen> createState() => _PredictBillScreenState();
}

class _PredictBillScreenState extends State<PredictBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController();
  final _baseRateController = TextEditingController();

  List<BillEntry> _bills = [];
  String _predictionTarget = 'current_month';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// Initializes the screen:
  /// - Generates required months
  /// - Loads bills from Firestore
  /// - Loads budget from Firestore
  Future<void> _initialize() async {
    _bills = BillService.generateRequiredMonths(_predictionTarget);
    await BillService.loadBills(_bills);

    final budget = await BillService.loadBudget();
    if (budget != null) {
      _budgetController.text = budget;
    }

    final baseRate = await BillService.loadBaseRate();
    if (baseRate != null) {
      _baseRateController.text = baseRate;
    }

    setState(() {});
  }

  /// Validates the form, saves bills and budget,
  /// then saves prediction history to Firestore.
  Future<void> _predictBill() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final bills = await BillService.saveBills(_bills);

      await BillService.saveBudget(double.parse(_budgetController.text));
      await BillService.saveBaseRate(double.parse(_baseRateController.text));

      await PredictionService.savePrediction(
        predictionTarget: _predictionTarget,
        budget: double.parse(_budgetController.text),
        // baseRate: double.parse(_baseRateController.text),
        bills: bills,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prediction saved successfully')),
      );
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  void dispose() {
    _budgetController.dispose();
    for (final bill in _bills) {
      bill.dispose();
    }
    _baseRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predict Bill')),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Prediction target selection
              const Text(
                'Prediction Target',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              RadioListTile<String>(
                value: 'current_month',
                groupValue: _predictionTarget,
                title: const Text('Current Month'),
                onChanged: (value) async {
                  _predictionTarget = value!;
                  await _initialize();
                },
              ),

              RadioListTile<String>(
                value: 'next_month',
                groupValue: _predictionTarget,
                title: const Text('Next Month'),
                onChanged: (value) async {
                  _predictionTarget = value!;
                  await _initialize();
                },
              ),

              const SizedBox(height: 24),

              // Bill cards (6 months)
              for (final bill in _bills) ...[
                BillCard(entry: bill),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 24),

              // Budget input
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Budget Amount',
                  prefixText: '₱ ',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              //input field for entering the base rate (₱/kWh).
              TextFormField(
                controller: _baseRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Base Rate (₱/kWh)', 
                  hintText: '12.5',               
                  prefixText: '₱ ',               
                  suffixText: '/kWh',            
                  border: OutlineInputBorder(),   
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter base rate'; 
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Predict button
              ElevatedButton(
                onPressed: _predictBill,
                child: const Text('Predict Bill'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
