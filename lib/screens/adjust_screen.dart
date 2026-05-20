import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wattwais/core/theme/app_theme.dart'; 
import "package:wattwais/widgets/bottom_nav.dart";

class AdjustValuesScreen extends StatefulWidget {
  const AdjustValuesScreen({super.key});

  @override
  State<AdjustValuesScreen> createState() => _AdjustValuesScreenState();
}

class _AdjustValuesScreenState extends State<AdjustValuesScreen> {
  // Text controllers for fine-tuned precision input
  final _budgetController = TextEditingController();
  final _rateController = TextEditingController();

  // Slider state for quick budget adjustments
  double _budgetSliderValue = 150.0; 
  final double _maxBudgetLimit = 500.0; // Adjust this ceiling as needed

  @override
  void initState() {
    super.initState();
    // TODO: Fetch existing saved values from Firebase/Local Storage here
    // Setting initial default values for template display
    _budgetController.text = _budgetSliderValue.toStringAsFixed(0);
    _rateController.text = "0.15"; // Example default base rate ($/kWh)
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  // Updates the text field when slider moves
  void _onSliderChanged(double value) {
    setState(() {
      // Clamp ensures the value stays strictly between 0 and _maxBudgetLimit
      _budgetSliderValue = value.clamp(0.0, _maxBudgetLimit);
      _budgetController.text = _budgetSliderValue.toStringAsFixed(0);
    });
  }

  void _onBudgetTextChanged(String text) {
    // If the user clears the field, default it safely to 0 instead of crashing
    if (text.isEmpty) {
      setState(() {
        _budgetSliderValue = 0.0;
      });
      return;
    }

    final parsed = double.tryParse(text);
    if (parsed != null) {
      setState(() {
        // Clamp the text input so it never goes below 0 or above your max limit
        _budgetSliderValue = parsed.clamp(0.0, _maxBudgetLimit);
      });
    }
  }

  void _saveConfigurations() {
    final finalBudget = double.tryParse(_budgetController.text) ?? _budgetSliderValue;
    final finalBaseRate = double.tryParse(_rateController.text) ?? 0.0;

    // TODO: Implement your database/state update logic here
    debugPrint("Saving Target Budget: \$$finalBudget");
    debugPrint("Saving Base Rate: \$$finalBaseRate/kWh");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Budget parameters updated successfully!'),
        backgroundColor: AppColors.blue.withValues(alpha: 0.8),
      ),
    );

    if (context.canPop()) {
      context.pop();
    }
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
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: AppColors.text),
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Intro
              Row(
                children: [
                  Icon(Icons.tune_rounded, color: AppColors.cyan, size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'Adjust Thresholds',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Fine-tune your financial baseline to help the XGBoost prediction engine accurately forecast your upcoming bill spikes.',
                style: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 36),

              // --- SECTION 1: MONTHLY BUDGET ---
              const Row(
                children: [
                  Icon(Icons.monetization_on_outlined, color: AppColors.blue, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Monthly Target Budget',
                    style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Budget input field paired with slider tracking
              TextField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
                onChanged: _onBudgetTextChanged,
                decoration: InputDecoration(
                  prefixText: '\P ',
                  prefixStyle: const TextStyle(color: AppColors.cyan, fontWeight: FontWeight.bold),
                  hintText: 'Enter maximum budget',
                  hintStyle: const TextStyle(color: AppColors.muted),
                  filled: true,
                  fillColor: AppColors.blue.withValues(alpha: 0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.blue, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _budgetSliderValue,
                min: 0,
                max: _maxBudgetLimit,
                activeColor: AppColors.cyan,
                inactiveColor: AppColors.muted.withValues(alpha: 0.15),
                onChanged: _onSliderChanged,
              ),
              const SizedBox(height: 32),

              // --- SECTION 2: BASE ELECTRICITY RATE ---
              const Row(
                children: [
                  Icon(Icons.electric_bolt_rounded, color: AppColors.blue, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Base Electricity Rate',
                    style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Check your utility provider statement for your current flat cost per kilowatt-hour.',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _rateController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  suffixText: '/ kWh',
                  suffixStyle: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w500),
                  prefixStyle: const TextStyle(color: AppColors.cyan, fontWeight: FontWeight.bold),
                  hintText: '0.00',
                  hintStyle: const TextStyle(color: AppColors.muted),
                  filled: true,
                  fillColor: AppColors.blue.withValues(alpha: 0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.blue, width: 2),
                  ),
                ),
              ),
              
              const SizedBox(height: 48),

              // --- SAVE ACTION BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _saveConfigurations,
                  icon: const Icon(Icons.check_circle_outline_rounded, size: 22),
                  label: const Text(
                    'Apply Adjustments',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: AppColors.ink,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const WattBottomNav(
      currentIndex: 3,
      ),
    );
  }
}