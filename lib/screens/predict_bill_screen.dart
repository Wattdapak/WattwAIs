import 'package:flutter/material.dart';

import '../models/appliance_model.dart';
import '../models/bill_entry.dart';
import '../models/appliance_template.dart';

import '../services/appliance_service.dart';
import '../services/bill_service.dart';
import '../services/prediction_service.dart';

import '../widgets/bill_card.dart';
import '../widgets/bottom_nav.dart';

import 'appliance_section.dart';

class PredictBillScreen extends StatefulWidget {
  const PredictBillScreen({super.key});

  @override
  State<PredictBillScreen> createState() => _PredictBillScreenState();
}

class _PredictBillScreenState extends State<PredictBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final _applianceFormKey = GlobalKey<FormState>();

  final _budgetController = TextEditingController();
  final _baseRateController = TextEditingController();

  final _newApplianceNameController = TextEditingController();
  final _newApplianceWattsController = TextEditingController();
  final _newApplianceQuantityController = TextEditingController(text: '1');
  final _newApplianceHoursController = TextEditingController(text: '1');
  final _newApplianceDaysController = TextEditingController(text: '7');

  List<ApplianceModel> _appliances = [];
  List<BillEntry> _bills = [];

  String _predictionTarget = 'current_month';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _bills = BillService.generateRequiredMonths(_predictionTarget);

    await _loadAppliances();
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

  Future<void> _showAddApplianceDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Appliance'),
          content: Form(
            key: _applianceFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _newApplianceNameController,
                    decoration: const InputDecoration(
                      labelText: 'Appliance Name',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter appliance name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _newApplianceWattsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Watts',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _newApplianceQuantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Qty',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _newApplianceHoursController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Hrs/day',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _newApplianceDaysController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Days/week',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                await _addManualAppliance();
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadAppliances() async {
    final appliances = await ApplianceService.loadAppliances();
    setState(() {
      _appliances = appliances;
    });
  }

  Future<void> _addApplianceFromDefault(ApplianceTemplate template) async {
    final alreadyExists = _appliances.any(
      (a) => a.name.toLowerCase() == template.name.toLowerCase(),
    );

    if (alreadyExists) return;

    final newAppliance = ApplianceModel(
      id: '',
      name: template.name,
      icon: template.icon,
      watts: template.defaultWatts,
      quantity: template.defaultQuantity,
      hoursPerDay: template.defaultHoursPerDay,
      daysPerWeek: template.defaultDaysPerWeek,
    );

    await ApplianceService.saveAppliance(newAppliance);
    await _loadAppliances();
  }

  Future<void> _addManualAppliance() async {
    if (!_applianceFormKey.currentState!.validate()) return;

    final newAppliance = ApplianceModel(
      id: '',
      name: _newApplianceNameController.text.trim(),
      icon: Icons.devices,
      watts: int.tryParse(_newApplianceWattsController.text) ?? 0,
      quantity: int.tryParse(_newApplianceQuantityController.text) ?? 1,
      hoursPerDay: int.tryParse(_newApplianceHoursController.text) ?? 1,
      daysPerWeek: int.tryParse(_newApplianceDaysController.text) ?? 7,
    );

    await ApplianceService.saveAppliance(newAppliance);
    await _loadAppliances();
    _clearManualApplianceForm();
  }

  void _clearManualApplianceForm() {
    _newApplianceNameController.clear();
    _newApplianceWattsController.clear();
    _newApplianceQuantityController.text = '1';
    _newApplianceHoursController.text = '1';
    _newApplianceDaysController.text = '7';
  }

  Future<void> _updateAppliance(ApplianceModel appliance) async {
    await ApplianceService.saveAppliance(appliance);
    await _loadAppliances();
  }

  Future<void> _deleteAppliance(String id) async {
    await ApplianceService.deleteAppliance(id);
    await _loadAppliances();
  }

  Future<void> _editAppliance(ApplianceModel model) async {
    final nameController = TextEditingController(text: model.name);
    final wattsController = TextEditingController(text: model.watts.toString());
    final quantityController = TextEditingController(text: model.quantity.toString());
    final hoursController = TextEditingController(text: model.hoursPerDay.toString());
    final daysController = TextEditingController(text: model.daysPerWeek.toString());

    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Appliance'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    controller: wattsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Watts'),
                  ),
                  TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                  ),
                  TextFormField(
                    controller: hoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Hours/day'),
                  ),
                  TextFormField(
                    controller: daysController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Days/week'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                final updated = model.copyWith(
                  name: nameController.text.trim(),
                  watts: int.parse(wattsController.text),
                  quantity: int.parse(quantityController.text),
                  hoursPerDay: int.parse(hoursController.text),
                  daysPerWeek: int.parse(daysController.text),
                );

                await _updateAppliance(updated);
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _predictBill() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final bills = await BillService.saveBills(_bills);
      final appliances = await ApplianceService.loadAppliances();

      await BillService.saveBudget(double.parse(_budgetController.text));
      await BillService.saveBaseRate(double.parse(_baseRateController.text));

      await PredictionService.savePrediction(
        predictionTarget: _predictionTarget,
        appliances: appliances,
        budget: double.parse(_budgetController.text),
        baseRate: double.parse(_baseRateController.text),
        bills: bills,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prediction saved successfully'),
        ),
      );
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _baseRateController.dispose();
    _newApplianceNameController.dispose();
    _newApplianceWattsController.dispose();
    _newApplianceQuantityController.dispose();
    _newApplianceHoursController.dispose();
    _newApplianceDaysController.dispose();

    for (final bill in _bills) {
      bill.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predict Bill'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Prediction Target',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
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
              for (final bill in _bills) ...[
                BillCard(entry: bill),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 24),
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
              ),
              const SizedBox(height: 24),
              ApplianceSection(
                appliances: _appliances,
                onAddTemplate: _addApplianceFromDefault,
                onAddManual: _showAddApplianceDialog,
                onEdit: _editAppliance,
                onDelete: _deleteAppliance,
                onChanged: _updateAppliance,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _predictBill,
                child: const Text('Predict Bill'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const WattBottomNav(
        currentIndex: 0,
      ),
    );
  }
}