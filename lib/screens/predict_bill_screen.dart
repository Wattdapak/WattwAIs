import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wattwais/core/routes/screen_routes.dart';

import 'package:wattwais/models/models.dart';
import 'package:wattwais/services/services.dart';
import 'package:wattwais/widgets/widgets.dart';
import 'package:wattwais/utils/bill_utils.dart';
import 'package:wattwais/utils/bill_validator.dart';

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

  final _worflowService = PredictBillWorkflowService();
  final _settingsService = SettingsPersistenceService();

  final _newApplianceNameController = TextEditingController();
  final _newApplianceWattsController = TextEditingController();
  final _newApplianceQuantityController = TextEditingController(text: '1');
  final _newApplianceHoursController = TextEditingController(text: '1');
  final _newApplianceDaysController = TextEditingController(text: '7');

  List<ApplianceModel> _appliances = [];
  List<BillEntry> _bills = [];

  String _predictionTarget = 'current_month';

  bool _isPredicting = false;
  bool _showBackendWarning = false;

  @override
  void initState() {
    super.initState();
    _budgetController.addListener(() {
      _settingsService.onBudgetChanged(_budgetController);
    });

    _baseRateController.addListener(() {
      _settingsService.onBaseRateChanged(_baseRateController);
    });
    _initialize();
  }

  Future<void> _initialize() async {
    for (final bill in _bills) {
      bill.dispose();
    }

    _bills = BillService.generateRequiredMonths(_predictionTarget);

    await _loadAppliances();
    await BillService.loadBills(_bills);

    final budget = await BillService.loadBudget();
    if (budget != null) {
      _settingsService.applyBudgetValue(value: budget, controller: _budgetController);
    }

    final baseRate = await BillService.loadBaseRate();
    if (baseRate != null) {
      _settingsService.applyBaseRateValue(value: baseRate, controller: _baseRateController);
    }
    if (!mounted) return;
    setState(() {});
  }

 Future<void> _showAddApplianceDialog() async {
  await showDialog(
    context: context,
    builder: (_) {
      return AddApplianceDialog(
        formKey: _applianceFormKey,
        nameController: _newApplianceNameController,
        wattsController: _newApplianceWattsController,
        quantityController: _newApplianceQuantityController,
        hoursController: _newApplianceHoursController,
        daysController: _newApplianceDaysController,
        onSubmit: _addManualAppliance,
      );
    },
  );
}

  Future<void> _loadAppliances() async {
    final appliances = await ApplianceService.loadAppliances();
    if (!mounted) return;
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

    final id = await ApplianceService.saveAppliance(newAppliance);
    if (!mounted) return;
    setState(() {
      _appliances = [newAppliance.copyWith(id: id ?? ''), ..._appliances];
    });
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

    final id = await ApplianceService.saveAppliance(newAppliance);
    if (!mounted) return;
    setState(() {
      _appliances = [newAppliance.copyWith(id: id ?? ''), ..._appliances];
    });
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
    setState(() {
      _appliances = [
        for (final item in _appliances)
          if (item.id == appliance.id) appliance else item,
      ];
    });
    await ApplianceService.saveAppliance(appliance);
  }

  Future<void> _deleteAppliance(String id) async {
    setState(() {
      _appliances = _appliances.where((item) => item.id != id).toList();
    });
    await ApplianceService.deleteAppliance(id);
  }

  Future<void> _predictBill() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {
        _isPredicting = true;
      });

      final validationError = PredictBillValidator.validate(
        budgetText: _budgetController.text,
        baseRateText: _baseRateController.text,
        bills: _bills,
        formatMonth: formatMonth,
      );
      
      if (validationError != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validationError)),
        );
        return;
      }

      final monthlyBudget = double.parse(_budgetController.text.trim());
      final baseRate = double.parse(_baseRateController.text.trim());
      final bills = await BillService.saveBills(_bills);

      PredictionResult? result;
      String? predictionErrorMessage;
      try {
        result = await _worflowService.predict(
          bills: bills,
          appliances: _appliances,
          monthlyBudget: monthlyBudget,
          baseRate: baseRate,
          predictionTarget: _predictionTarget,
        );
        _showBackendWarning = false;
      } on TimeoutException {
        _showBackendWarning = true;
        predictionErrorMessage = 'Prediction request timed out. Backend may be waking up, please try again in a few seconds.';
      } catch (e) {
        debugPrint(
          'Prediction API error: $e',
        );
        _showBackendWarning = true;
        predictionErrorMessage = 'Prediction failed. Please try again.';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result == null
                ? predictionErrorMessage ?? 'Inputs saved. Prediction failed.'
                : 'Prediction computed and saved',
          ),
        ),
      );

      if (result != null && mounted) {
        context.go(Routes.tipsscreen);
      }
    } catch (e) {
      debugPrint('$e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Prediction failed: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isPredicting = false;
        });
      }
    }
  }

  Future<void> _onPredictionTargetChanged(String? value) async {
    if (value == null || value == _predictionTarget) return;
    _predictionTarget = value;
    await _initialize();
  }

  @override
  void dispose() {
    _settingsService.dispose();
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
      appBar: AppBar(title: const Text('Predict Bill')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_showBackendWarning) ...[
                Card(
                  color: Colors.amber.shade100,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Backend unreachable. Check your internet connection and API base URL.',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              PredictionTargetSection(
                value: _predictionTarget,
                onChanged: _onPredictionTargetChanged,
              ),
              const SizedBox(height: 24),
              for (final bill in _bills) ...[
                BillCard(key: ValueKey(bill.monthId), entry: bill),
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
                onDelete: _deleteAppliance,
                onChanged: _updateAppliance,
              ),
              const SizedBox(height: 24),
              PredictBillButton(isLoading: _isPredicting, onPressed: _predictBill),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const WattBottomNav(currentIndex: 0),
    );
  }
}
