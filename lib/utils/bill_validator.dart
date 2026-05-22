import '../models/bill_entry.dart';

class PredictBillValidator {
  static String? validate({
    required String budgetText,
    required String baseRateText,
    required List<BillEntry> bills,
    required String Function(String monthId)
        formatMonth,
  }) {
    final monthlyBudget = double.tryParse(budgetText.trim());

    if (monthlyBudget == null || monthlyBudget < 0) {
      return 'Please enter a valid budget amount.';
    }

    final baseRate = double.tryParse(baseRateText.trim());

    if (baseRate == null || baseRate < 0) {
      return 'Please enter a valid base rate.';
    }

    for (final bill in bills) {
      final billAmount = double.tryParse(
        bill.billController.text.trim(),
      );

      if (billAmount == null || billAmount < 0) {
        return 'Please enter a valid bill amount for ${formatMonth(bill.monthId)}.';
      }

      final kwhText = bill.kwhController.text.trim();

      final kwh = double.tryParse(kwhText);

      if (kwhText.isEmpty || kwh == null || kwh < 0) {
        return 'Please enter kWh used for ${formatMonth(bill.monthId)}.';
      }
    }
    return null;
  }
}