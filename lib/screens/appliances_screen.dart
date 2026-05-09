// TODO: implement add appliance with button at top right

import 'package:flutter/material.dart';
import 'package:wattwais/screens/widgets/appliances/appliances_card.dart';
import 'package:wattwais/screens/widgets/appliances/appliances_header.dart';
import 'package:wattwais/screens/widgets/appliances/energy_distribution_card.dart';

class AppliancesScreen extends StatelessWidget {
  const AppliancesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [

              AppliancesHeader(),

              SizedBox(height: 24),

              ApplianceCard(
                icon: Icons.ac_unit,
                iconColor: Colors.blue,
                title: "Air Conditioner",
                usage: "35% of total usage",
              ),

              SizedBox(height: 24),

              EnergyDistributionCard(),
            ],
          ),
        ),
      ),
    );
  }
}