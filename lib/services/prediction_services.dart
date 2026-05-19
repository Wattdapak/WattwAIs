import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/appliance_input.dart';
import '../models/prediction_result.dart';

class PredictionService {
  // android emulator uses 10.0.2.2 to access localhost on your pc
  static const String baseUrl = 'http://10.0.2.2:8000';

  Future<PredictionResult> predictBill({
    required List<ApplianceInput> appliances,
    required double baseRate,
    required double sixMonthTotalBill,
    required double sixMonthTotalKwh,
    required double monthlyBudget,
  }) async {
    final url = Uri.parse('$baseUrl/predict');

    final body = {
      'appliances': appliances.map((item) => item.toJson()).toList(),
      'base_rate': baseRate,
      'six_month_total_bill': sixMonthTotalBill,
      'six_month_total_kwh': sixMonthTotalKwh,
      'monthly_budget': monthlyBudget,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'prediction failed (${response.statusCode}): ${response.body}',
      );
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    return PredictionResult.fromJson(data);
  }

  Future<bool> checkBackendHealth() async {
    try {
      final url = Uri.parse('$baseUrl/');
      final response = await http.get(url);

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}