class ApplianceInput {
  final String name;
  final int quantity;
  final double watts;
  final double hoursPerDay;
  final int daysPerWeek;

  ApplianceInput({
    required this.name,
    required this.quantity,
    required this.watts,
    required this.hoursPerDay,
    required this.daysPerWeek,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'watts': watts,
      'hours_per_day': hoursPerDay,
      'days_per_week': daysPerWeek,
    };
  }
}