import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:wattwais/core/routes/screen_routes.dart';
import 'package:wattwais/widgets/bottom_nav.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go(Routes.predictBill);
          },
          child: const Text('Predict Bill'),
        ),
      ),

      bottomNavigationBar: const WattBottomNav(
        currentIndex: 0,
      ),
    );
  }
}


// class Dashboard extends StatefulWidget {
//   const Dashboard({super.key});

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   var _tab = 0;
//   var _showSetup = false;
//   var _predicting = false;
//   var _appliances = defaultAppliances;
//   var _bill = 0.0;
//   var _usage = 0.0;
//   var _budgetUsage = 500.0;

//   void _openSetup() {
//     setState(() => _showSetup = true);
//   }

//   Future<void> _predictBill({required double bill, required double rate}) async {
//     setState(() => _predicting = true);
    
//     await Future<void>.delayed(const Duration(milliseconds: 900));
//     if (!mounted) return;
//     setState(() {
//       _predicting = false;
//       _showSetup = false;
//       _tab = 0;
//       // TODO: replace with actuall values
//       _bill = bill;
//       _usage = bill / rate;
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Prediction refreshed from your appliance inventory.'),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _updateAppliance(int index, Appliance appliance) {
//     setState(() {
//       _appliances = [
//         for (var i = 0; i < _appliances.length; i++)
//           if (i == index) appliance else _appliances[i],
//       ];
//     });
//   }

//   void _removeAppliance(int index) {
//     setState(() {
//       _appliances = [
//         for (var i = 0; i < _appliances.length; i++)
//           if (i != index) _appliances[i],
//       ];
//     });
//   }

//   void _addAppliance(Appliance appliance) {
//     if (_appliances.any((item) => item.name == appliance.name)) return;
//     setState(() => _appliances = [..._appliances, appliance]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_showSetup) {
//       return SetupScreen(
//         appliances: _appliances,
//         isPredicting: _predicting,
//         onBack: () => setState(() => _showSetup = false),
//         onAdd: _addAppliance,
//         onChange: _updateAppliance,
//         onDelete: _removeAppliance,
//         onPredict: ({required double bill, required double rate}) => 
//           _predictBill(bill: bill, rate: rate),
//       );
//     }

//     return Scaffold(
//       body: AnimatedSwitcher(
//         duration: const Duration(milliseconds: 260),
//         child: IndexedStack(
//           key: ValueKey(_tab),
//           index: _tab,
//           children: [
//             HomeScreen(
//               onPredict: _openSetup,
//               bill: _bill,
//               usage: _usage,
//               budgetUsage: _budgetUsage,
//             ),
//             const StatsScreen(),
//             TipsScreen(),
//             ProfileScreen(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: WattBottomNav(
//         currentIndex: _tab,
//         onChanged: (index) => setState(() => _tab = index),
//       ),
//     );
//   }
// }
