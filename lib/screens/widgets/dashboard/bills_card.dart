import 'package:flutter/material.dart';

class BillCard extends StatelessWidget {
  const BillCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2962FF),
            Color(0xFF00C853),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

            Icon (
              Icons.psychology,
              color: Colors.white,
              size: 14,
            ),

            Text(
              " AI Prediction",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              )
            ],
          ),
          
          const SizedBox(height: 6),


          const Text(
            "₱2,580",
            style: TextStyle(
              fontSize: 42,
              color: Colors.white,
            ),
          ),

          const Text(
            "Estimated bill for April 2026",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}