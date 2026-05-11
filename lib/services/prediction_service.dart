import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for handling electricity consumption predictions using XGBoost backend.
///
/// This service communicates with the FastAPI backend inference pipeline to predict
/// daily electricity consumption and generate bill estimates with budget recommendations.
///
/// Base URL Configuration:
/// - Default: http://127.0.0.1:8000 (for development on Windows/macOS/Linux)
/// - Android Emulator: Replace 127.0.0.1 with 10.0.2.2:8000
/// - Production/APK: Use the deployed API URL (e.g., https://api.example.com)
class PredictionService {
  /// Base URL for the backend API
  static const String baseUrl = 'http://127.0.0.1:8000';

  /// Makes a prediction request to the backend and returns consumption estimates and recommendations.
  ///
  /// Parameters:
  /// - [lag1]: Previous day's consumption (kWh)
  /// - [lag2]: Consumption from 2 days ago (kWh)
  /// - [lag3]: Consumption from 3 days ago (kWh)
  /// - [lag7]: Consumption from 7 days ago (kWh)
  /// - [rollingMean3]: 3-day rolling average consumption (kWh)
  /// - [rollingMean7]: 7-day rolling average consumption (kWh)
  /// - [dayOfWeek]: Day of the week (0-6, where 0 is Monday)
  /// - [month]: Month of the year (1-12)
  /// - [trend]: Trend component or sequential day number
  /// - [ratePerKwh]: Electricity rate in currency per kWh
  /// - [budget]: Monthly electricity budget in currency
  ///
  /// Returns:
  /// A [Future] that resolves to a map containing:
  /// - [predicted_daily_kwh]: Predicted daily consumption
  /// - [estimated_monthly_kwh]: Estimated monthly consumption (predicted * 30)
  /// - [estimated_bill]: Estimated monthly bill (estimated_monthly_kwh * rate_per_kwh)
  /// - [budget]: The provided budget value
  /// - [exceeds_budget]: Boolean indicating if estimated bill exceeds budget
  /// - [recommendation]: Usage recommendation based on prediction
  ///
  /// Throws:
  /// - [Exception]: If the HTTP request fails or returns a non-200 status code
  /// - [FormatException]: If the response cannot be decoded as JSON
  Future<Map<String, dynamic>> predictBill({
    required double lag1,
    required double lag2,
    required double lag3,
    required double lag7,
    required double rollingMean3,
    required double rollingMean7,
    required int dayOfWeek,
    required int month,
    required int trend,
    required double ratePerKwh,
    required double budget,
  }) async {
    try {
      // Prepare request body with exact field names matching backend
      final requestBody = {
        'lag_1': lag1,
        'lag_2': lag2,
        'lag_3': lag3,
        'lag_7': lag7,
        'rolling_mean_3': rollingMean3,
        'rolling_mean_7': rollingMean7,
        'day_of_week': dayOfWeek,
        'month': month,
        'trend': trend,
        'rate_per_kwh': ratePerKwh,
        'budget': budget,
      };

      // Send POST request to backend
      final response = await http.post(
        Uri.parse('$baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // Check response status
      if (response.statusCode == 200) {
        // Decode and return the response
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonResponse;
      } else if (response.statusCode == 503) {
        // Model not loaded
        throw Exception(
          'Backend model error: ${jsonDecode(response.body)['detail']}',
        );
      } else {
        // Other HTTP errors
        throw Exception(
          'Prediction request failed with status ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      // Re-throw with context
      throw Exception('Failed to get prediction: ${e.toString()}');
    }
  }

  /// Health check method to verify backend connectivity
  ///
  /// Returns true if the backend is running and responding correctly.
  Future<bool> isBackendAvailable() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/'))
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
