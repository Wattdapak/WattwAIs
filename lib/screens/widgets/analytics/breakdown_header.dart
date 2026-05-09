import 'package:flutter/material.dart';

class BreakdownHeader extends StatelessWidget {
  const BreakdownHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text(
        "Monthly Breakdown",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}