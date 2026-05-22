import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wattwais/core/theme/app_theme.dart';
import 'package:wattwais/services/bill_service.dart';
import 'package:wattwais/widgets/budget_input.dart';
import 'package:wattwais/widgets/rate_input.dart';
import 'package:wattwais/widgets/bottom_nav.dart';

class AdjustValuesScreen extends StatefulWidget {
  const AdjustValuesScreen({super.key});

  @override
  State<AdjustValuesScreen> createState() => _AdjustValuesScreenState();
}

class _AdjustValuesScreenState extends State<AdjustValuesScreen> {
  final _budgetController = TextEditingController();
  final _rateController = TextEditingController();

  double _budgetSliderValue = 100.0;
  final double _maxBudgetLimit = 20000.0;

  @override
  void initState() {
    super.initState();
    _loadSavedValues();
  }

  Future<void> _loadSavedValues() async {
    final savedBudget = await BillService.loadBudget();
    final savedRate = await BillService.loadBaseRate();

    if (!mounted) return;
    setState(() {
      _budgetSliderValue = double.tryParse(savedBudget ?? '100') ?? 100.0;
      _budgetController.text = _budgetSliderValue.toStringAsFixed(0);
      _rateController.text = (double.tryParse(savedRate ?? '0') ?? 0.0).toString();
    });
  }

  Future<void> _saveConfigurations() async {
    final finalBudget = double.tryParse(_budgetController.text) ?? _budgetSliderValue;
    final finalBaseRate = double.tryParse(_rateController.text) ?? 0.0;

    await BillService.saveBudget(finalBudget);
    await BillService.saveBaseRate(finalBaseRate);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Budget parameters updated successfully!'),
        backgroundColor: AppColors.blue.withValues(alpha: 0.8),
      ),
    );

    if (context.canPop()) context.pop();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Tariff & Budget',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: AppColors.text,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.text),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BudgetInput(
                controller: _budgetController,
                sliderValue: _budgetSliderValue,
                maxBudget: _maxBudgetLimit,
                onSliderChanged: (val) {
                  setState(() {
                    _budgetSliderValue = val;
                    _budgetController.text = val.toStringAsFixed(0);
                  });
                },
              ),
              const SizedBox(height: 32),
              RateInput(controller: _rateController),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _saveConfigurations,
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 22),
                  label: const Text(
                    'Apply Adjustments',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: AppColors.ink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const WattBottomNav(currentIndex: 3),
    );
  }
}
