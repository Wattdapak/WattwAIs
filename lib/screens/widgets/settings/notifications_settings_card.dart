import 'package:flutter/material.dart';

class NotificationSettingsCard extends StatefulWidget {
  const NotificationSettingsCard({super.key});

  @override
  State<NotificationSettingsCard> createState() =>
      _NotificationSettingsCardState();
}

class _NotificationSettingsCardState extends State<NotificationSettingsCard> {
  bool budgetAlert = true;
  bool usageAlert = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Notification Settings",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          SwitchListTile(
            value: budgetAlert,
            title: const Text("Budget Alerts"),
            subtitle: const Text("Get notified when exceeding budget"),
            onChanged: (val) => setState(() => budgetAlert = val),
          ),

          SwitchListTile(
            value: usageAlert,
            title: const Text("Usage Alerts"),
            subtitle: const Text("Daily usage notifications"),
            onChanged: (val) => setState(() => usageAlert = val),
          ),
        ],
      ),
    );
  }
}