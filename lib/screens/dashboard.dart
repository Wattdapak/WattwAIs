import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wattwais/core/routes/screen_routes.dart';
import 'package:wattwais/models/wattwais_models.dart';
import 'package:wattwais/widgets/bottom_nav.dart';

// Screen Imports
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adapt screen layouts if viewed on tablets or landscape screen configurations
        final bool isWideLayout = constraints.maxWidth > 720;

        return Scaffold(
          // Uses an intentional, responsive container structure to constraint content blowing up on big screens
          body: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isWideLayout ? 600 : double.infinity,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: IndexedStack(
                  key: ValueKey(_tab),
                  index: _tab,
                  children: [
                    HomeScreen(
                      onPredict: () {
                        context.go(Routes.predictBill);
                      },
                      bill: _bill,
                      usage: _usage,
                      budgetUsage: _budgetUsage,
                    ),
                    const StatsScreen(),
                    const TipsScreen(), // Adding const if constructors support it
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: WattBottomNav(
            currentIndex: 0
          ),
        );
      },
    );
  }
}