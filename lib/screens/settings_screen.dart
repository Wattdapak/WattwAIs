import 'package:flutter/material.dart';
import 'package:wattwais/screens/widgets/settings/budget_limit_card.dart';
import 'package:wattwais/screens/widgets/settings/budget_overview_card.dart';
import 'package:wattwais/screens/widgets/settings/notifications_settings_card.dart';
import 'package:wattwais/screens/widgets/settings/save_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: const [
              SizedBox(height: 10),
              Text(
                "Budget Settings",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              BudgetLimitCard(),
              SizedBox(height: 20),

              BudgetOverviewCard(),
              SizedBox(height: 20),

              NotificationSettingsCard(),
              SizedBox(height: 25),

              SaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}