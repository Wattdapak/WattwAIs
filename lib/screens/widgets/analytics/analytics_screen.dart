import 'package:flutter/material.dart';
import 'ai_tip_card.dart';
import 'breakdown_header.dart';
import 'monthly_item_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AiTipCard(),

          const SizedBox(height: 20),

          const BreakdownHeader(),

          const MonthlyItemCard(
            month: "Mar 2026",
            kwh: "327 kWh",
            price: "₱2450",
          ),

          const MonthlyItemCard(
            month: "Feb 2026",
            kwh: "293 kWh",
            price: "₱2200",
          ),

          const MonthlyItemCard(
            month: "Jan 2026",
            kwh: "260 kWh",
            price: "₱1950",
          ),

          const MonthlyItemCard(
            month: "Dec 2026",
            kwh: "313 kWh",
            price: "₱2350",
          ),

          const MonthlyItemCard(
            month: "Nov 2026",
            kwh: "280 kWh",
            price: "₱2100",
          ),

          const MonthlyItemCard(
            month: "Oct 2026",
            kwh: "247 kWh",
            price: "₱1850",
          ),
        ],
      ),
    );
  }
}
