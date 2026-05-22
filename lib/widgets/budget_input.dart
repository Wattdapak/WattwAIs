import 'package:flutter/material.dart';
import 'package:wattwais/core/theme/app_theme.dart';

class BudgetInput extends StatelessWidget {
  final TextEditingController controller;
  final double sliderValue;
  final double maxBudget;
  final ValueChanged<double> onSliderChanged;

  const BudgetInput({
    super.key,
    required this.controller,
    required this.sliderValue,
    required this.maxBudget,
    required this.onSliderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.money_rounded, color: AppColors.cyan, size: 20),
            SizedBox(width: 8),
            Text(
              'Monthly Target Budget',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            prefixText: '₱ ',
            prefixStyle: const TextStyle(color: AppColors.cyan, fontWeight: FontWeight.bold),
            hintText: '0',
            hintStyle: const TextStyle(color: AppColors.muted),
            filled: true,
            fillColor: AppColors.blue.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (text) {
            final parsed = double.tryParse(text);
            if (parsed != null) {
              onSliderChanged(parsed.clamp(0.0, maxBudget));
            }
          },
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(trackHeight: 4),
          child: Slider(
            value: sliderValue,
            min: 0,
            max: maxBudget,
            activeColor: AppColors.cyan,
            inactiveColor: AppColors.muted.withValues(alpha: 0.15),
            onChanged: onSliderChanged,
          ),
        ),
      ],
    );
  }
}
