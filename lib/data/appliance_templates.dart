import "package:flutter/material.dart";
import "package:wattwais/models/appliance_template.dart";

//appliance template data with default values
//populate with common appliances
const applianceTemplates = [

  //aircon
  ApplianceTemplate(
    name: 'Air Conditioner',
    icon: Icons.ac_unit,
    defaultWatts: 1500,
    defaultQuantity: 1,
    defaultHoursPerDay: 8,
    defaultDaysPerWeek: 7,
  ),

  //ref
  ApplianceTemplate(
    name: 'Refrigerator',
    icon: Icons.kitchen,
    defaultWatts: 200,
    defaultQuantity: 1,
    defaultHoursPerDay: 24,
    defaultDaysPerWeek: 7,
  ),

  //fan
  ApplianceTemplate(
    name: 'Electric Fan',
    icon: Icons.toys,
    defaultWatts: 75,
    defaultQuantity: 1,
    defaultHoursPerDay: 10,
    defaultDaysPerWeek: 7,
  ),

  //TV
  ApplianceTemplate(
    name: 'TV',
    icon: Icons.tv,
    defaultWatts: 120,
    defaultQuantity: 1,
    defaultHoursPerDay: 5,
    defaultDaysPerWeek: 7,
  ),
];
