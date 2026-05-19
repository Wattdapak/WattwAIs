import 'package:flutter/material.dart';

class Appliance {
  const Appliance({
    required this.name,
    required this.icon,
    required this.watts,
    required this.hoursPerDay,
    required this.quantity,
    required this.daysPerWeek,
  });

  final String name;
  final IconData icon;
  final int watts;
  final int hoursPerDay;
  final int quantity;
  final int daysPerWeek;

  Appliance copyWith({int? watts, int? hoursPerDay, int? quantity, int? daysPerWeek}) {
    return Appliance(
      name: name,
      icon: icon,
      watts: watts ?? this.watts,
      hoursPerDay: hoursPerDay ?? this.hoursPerDay,
      quantity: quantity ?? this.quantity,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
    );
  }

  int get monthlyKwh => ((watts * hoursPerDay * quantity * (daysPerWeek / 7) * 30) / 1000).round();
}

class UsageMonth {
  const UsageMonth(this.label, this.kwh);

  final String label;
  final double kwh;
}

final defaultAppliances = <Appliance>[
  const Appliance(
    name: 'Air Conditioner',
    icon: Icons.ac_unit_rounded,
    watts: 1500,
    hoursPerDay: 8,
    quantity: 1,
    daysPerWeek: 7,
  ),
  const Appliance(
    name: 'Refrigerator',
    icon: Icons.kitchen_rounded,
    watts: 200,
    hoursPerDay: 24,
    quantity: 1,
    daysPerWeek: 7,
  ),
  const Appliance(
    name: 'Ceiling Fan',
    icon: Icons.toys_rounded,
    watts: 75,
    hoursPerDay: 12,
    quantity: 3,
    daysPerWeek: 7,
  ),
  const Appliance(
    name: 'Smart TV',
    icon: Icons.tv_rounded,
    watts: 120,
    hoursPerDay: 5,
    quantity: 1,
    daysPerWeek: 7,
  ),
];

const usageHistory = <UsageMonth>[
  UsageMonth('Jan', 245),
  UsageMonth('Feb', 228),
  UsageMonth('Mar', 262),
  UsageMonth('Apr', 238),
  UsageMonth('May', 215),
  UsageMonth('Jun', 226),
  UsageMonth('Jul', 197),
];
