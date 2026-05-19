class UsageMonth {
  const UsageMonth(this.label, this.kwh);

  final String label;
  final double kwh;
}

const usageHistory = <UsageMonth>[
  UsageMonth('Jan', 245),
  UsageMonth('Feb', 228),
  UsageMonth('Mar', 262),
  UsageMonth('Apr', 238),
  UsageMonth('May', 215),
  UsageMonth('Jun', 226),
  UsageMonth('Jul', 197),
];
