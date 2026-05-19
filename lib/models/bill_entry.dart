import "package:flutter/material.dart";

//bill entry for a given month.
//hold controllers for bill amount and kWh usage.
class BillEntry {
  //unique identifier for the month (format: yyyy-mm, ex. "2026-05").
  final String monthId;

  //controller for the bill amount input field.
  final TextEditingController billController = TextEditingController();

  //controller for the kWh usage input field.
  final TextEditingController kwhController = TextEditingController();

  BillEntry({required this.monthId});

  //dispose controllers to prevent memory leaks.
  void dispose() {
    billController.dispose();
    kwhController.dispose();
  }
}
