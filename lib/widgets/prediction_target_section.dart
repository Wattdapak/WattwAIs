import 'package:flutter/material.dart';

class PredictionTargetSection extends StatelessWidget {
  const PredictionTargetSection({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prediction Target',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        RadioGroup<String>(
          groupValue: value,
          onChanged: onChanged,
          child: Column(
            children: [
              RadioListTile<String>(
                value: 'current_month',
                title: const Text('Current Month'),
              ),
              RadioListTile<String>(
                value: 'next_month',
                title: const Text('Next Month'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
