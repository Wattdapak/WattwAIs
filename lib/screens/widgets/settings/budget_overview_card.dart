import 'package:flutter/material.dart';

class BudgetOverviewCard extends StatelessWidget {
  const BudgetOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F9FF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Budget Overview",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),

          _RowItem(label: "Set Budget", value: "₱2,250"),
          SizedBox(height: 5),
          _RowItem(label: "Predicted Next Bill", value: "₱2,580", valueColor: Colors.red),
          SizedBox(height: 5),
          _RowItem(label: "Difference", value: "+₱330 (15%)", valueColor: Colors.red),
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _RowItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            )),
      ],
    );
  }
}