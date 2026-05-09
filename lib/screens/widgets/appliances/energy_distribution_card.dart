import 'package:flutter/material.dart';
import 'pie_chart.dart';

class EnergyDistributionCard extends StatelessWidget {
  const EnergyDistributionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFFEFF4F5),
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [

          Text(
            "Energy Distribution",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 24),

          Center(
            child: SizedBox(
              width: 180,
              height: 180,
              child: PieChart(),
            ),
          ),
        ],
      ),
    );
  }
}