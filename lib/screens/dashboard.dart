import 'package:flutter/material.dart';
//import 'package:wattwais/core/theme/app_theme.dart';
import 'package:wattwais/models/wattwais_models.dart';
//import 'package:wattwais/widgets/app_chrome.dart';
import 'profilescreen.dart';
import 'tipsscreen.dart';
import 'statscreen.dart';
import 'homescreen.dart';
import 'setupscreen.dart';
import '../widgets/bottom_nav.dart';
//

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _tab = 0;
  var _showSetup = false;
  var _predicting = false;
  var _appliances = defaultAppliances;

  void _openSetup() {
    setState(() => _showSetup = true);
  }

  Future<void> _predictBill() async {
    setState(() => _predicting = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _predicting = false;
      _showSetup = false;
      _tab = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prediction refreshed from your appliance inventory.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
    if (_showSetup) {
      return SetupScreen(
        appliances: _appliances,
        isPredicting: _predicting,
        onBack: () => setState(() => _showSetup = false),
        onAdd: _addAppliance,
        onChange: _updateAppliance,
        onDelete: _removeAppliance,
        onPredict: _predictBill,
      );
    }

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: IndexedStack(
          key: ValueKey(_tab),
          index: _tab,
          children: [
            HomeScreen(onPredict: _openSetup),
            const StatsScreen(),
            TipsScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: WattBottomNav(
        currentIndex: _tab,
        onChanged: (index) => setState(() => _tab = index),
      ),
    );
  }
}
