import 'package:flutter/material.dart';

class BudgetLimitCard extends StatelessWidget {
  const BudgetLimitCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Monthly Budget Limit",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          const Text("₱ 2250",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(height: 2, color: Colors.blueAccent),
        ],
      ),
    );
  }
}