import 'package:flutter/material.dart';

final Map<int, IconData> _iconByCodePoint = <int, IconData>{
  Icons.ac_unit.codePoint: Icons.ac_unit,
  Icons.kitchen.codePoint: Icons.kitchen,
  Icons.toys.codePoint: Icons.toys,
  Icons.tv.codePoint: Icons.tv,
  Icons.phone_iphone_rounded.codePoint: Icons.phone_iphone_rounded,
  Icons.laptop_mac_rounded.codePoint: Icons.laptop_mac_rounded,
  Icons.rice_bowl_rounded.codePoint: Icons.rice_bowl_rounded,
  Icons.local_cafe_rounded.codePoint: Icons.local_cafe_rounded,
  Icons.water_drop_outlined.codePoint: Icons.water_drop_outlined,
  Icons.devices.codePoint: Icons.devices,
};

class ApplianceModel {
  final String id;
  final String name;
  final IconData icon;
  final int watts;
  final int quantity;
  final int hoursPerDay;
  final int daysPerWeek;

  const ApplianceModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.watts,
    required this.quantity,
    required this.hoursPerDay,
    required this.daysPerWeek,
  });

  //copy wiht
  ApplianceModel copyWith({
    String? id,
    String? name,
    IconData? icon,
    int? watts,
    int? quantity,
    int? hoursPerDay,
    int? daysPerWeek,
  }) {
    return ApplianceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      watts: watts ?? this.watts,
      quantity: quantity ?? this.quantity,
      hoursPerDay: hoursPerDay ?? this.hoursPerDay,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
    );
  }

  //from firestore
  factory ApplianceModel.fromMap(String id, Map<String, dynamic> map) {
    final rawCodePoint = map['icon_codepoint'];
    final parsedCodePoint = rawCodePoint is int
        ? rawCodePoint
        : int.tryParse(rawCodePoint?.toString() ?? '');

    return ApplianceModel(
      id: id,
      name: map['name'] ?? '',
      icon: _iconByCodePoint[parsedCodePoint] ?? Icons.devices,
      watts: (map['watts'] ?? 0) as int,
      quantity: (map['quantity'] ?? 1) as int,
      hoursPerDay: (map['hours_per_day'] ?? 1) as int,
      daysPerWeek: (map['days_per_week'] ?? 7) as int,
    );
  }

  // to firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon_codepoint': icon.codePoint,
      'watts': watts,
      'quantity': quantity,
      'hours_per_day': hoursPerDay,
      'days_per_week': daysPerWeek,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }
}
