import 'package:flutter/material.dart';

class AiTipCard extends StatelessWidget {
  const AiTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        "Set your AC to 24°C instead of 22°C to save approximately ₱300/month.",
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}