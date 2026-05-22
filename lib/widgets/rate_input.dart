import 'package:flutter/material.dart';
import 'package:wattwais/core/theme/app_theme.dart';

class RateInput extends StatelessWidget {
  final TextEditingController controller;

  const RateInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.electric_bolt_rounded, color: AppColors.blue, size: 20),
            SizedBox(width: 8),
            Text(
              'Base Electricity Rate',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
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
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            prefixText: '₱ ',
            suffixText: '/ kWh',
            suffixStyle: const TextStyle(color: AppColors.muted, fontWeight: FontWeight.w500),
            prefixStyle: const TextStyle(color: AppColors.cyan, fontWeight: FontWeight.bold),
            hintText: '0.00',
            hintStyle: const TextStyle(color: AppColors.muted),
            filled: true,
            fillColor: AppColors.blue.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
