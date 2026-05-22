import 'dart:async';

import '../models/appliance_input.dart';
import '../models/appliance_model.dart';
import '../models/bill_model.dart';
import '../models/prediction_result.dart';

import 'bill_service.dart';
import 'prediction_api_service.dart';
import 'prediction_store_service.dart';

class PredictBillWorkflowService {
  Future<PredictionResult?> predict({
    required List<BillModel> bills,
    required List<ApplianceModel> appliances,
    required double monthlyBudget,
    required double baseRate,
    required String predictionTarget,
  }) async {
    await BillService.saveBudget(monthlyBudget);
    await BillService.saveBaseRate(baseRate);
    final sixMonthTotalBill = bills.fold<double>(0.0,
      (sum, bill) => sum + bill.billAmount,
    );

    final sixMonthTotalKwh = bills.fold<double>(0.0,
      (sum, bill) => sum + (bill.kwhUsed ?? 0.0),
    );

    PredictionResult? result;

    final api = PredictionApiService();

    result = await api.predictBill(
      appliances: appliances
          .map(ApplianceInput.fromModel)
          .toList(),
      baseRate: baseRate,
      sixMonthTotalBill: sixMonthTotalBill,
      sixMonthTotalKwh: sixMonthTotalKwh,
      monthlyBudget: monthlyBudget,
    );

    await PredictionStoreService.savePrediction(
      predictionTarget: predictionTarget,
      appliances: appliances,
      budget: monthlyBudget,
      baseRate: baseRate,
      bills: bills,
      predictionResult: result,
    );

    return result;
  }
}