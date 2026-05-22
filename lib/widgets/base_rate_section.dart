import 'package:flutter/material.dart';

class BaseRateSection extends StatelessWidget {
  const BaseRateSection({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Base Rate (₱/kWh)',
        hintText: '12.5',
        prefixText: '₱ ',
        suffixText: '/kWh',
        border: OutlineInputBorder(),
      ),
    );
  }
}
