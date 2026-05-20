import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wattwais/core/routes/screen_routes.dart';
import 'package:wattwais/models/wattwais_models.dart';
import 'package:wattwais/widgets/bottom_nav.dart';

// Screen Imports
import 'profilescreen.dart';
import 'tipsscreen.dart';
import 'statscreen.dart';
import 'homescreen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _tab = 0;
  var _appliances = defaultAppliances;
  var _bill = 0.0;
  var _usage = 0.0;
  var _budgetUsage = 500.0;

  void _updateAppliance(int index, Appliance appliance) {
    setState(() {
      _appliances = [
        for (var i = 0; i < _appliances.length; i++)
          if (i == index) appliance else _appliances[i],
      ];
    });
  }

  void _removeAppliance(int index) {
    setState(() {
      _appliances = [
        for (var i = 0; i < _appliances.length; i++)
          if (i != index) _appliances[i],
      ];
    });
  }

  void _addAppliance(Appliance appliance) {
    if (_appliances.any((item) => item.name == appliance.name)) return;
    setState(() => _appliances = [..._appliances, appliance]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: IndexedStack(
          key: ValueKey(_tab),
          index: _tab,
          children: [
            HomeScreen(
              // Triggering the GoRouter navigation route instead of managing local overlay states
              onPredict: () {
                context.go(Routes.predictBill);
              },
              bill: _bill,
              usage: _usage,
              budgetUsage: _budgetUsage,
            ),
            const StatsScreen(),
            TipsScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: WattBottomNav(
        currentIndex: 0,
      ),
    );
  }
}