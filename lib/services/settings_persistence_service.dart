import 'dart:async';
import 'package:flutter/material.dart';

import 'bill_service.dart';

class SettingsPersistenceService {
  Timer? budgetDebounce;
  Timer? baseRateDebounce;

  bool budgetDirty = false;
  bool baseRateDirty = false;

  bool suspendListeners = false;

  void onBudgetChanged(TextEditingController controller) {
    if (suspendListeners) return;

    budgetDirty = true;
    budgetDebounce?.cancel();

    final parsed = double.tryParse(
      controller.text.replaceAll(',', '').trim(),
    );
    if (parsed == null) return;

    budgetDebounce = Timer(
      const Duration(milliseconds: 600),
      () => BillService.saveBudget(parsed),
    );
  }

  void onBaseRateChanged(TextEditingController controller) {
    if (suspendListeners) return;

    baseRateDirty = true;
    baseRateDebounce?.cancel();

    final parsed = double.tryParse(
      controller.text.replaceAll(',', '').trim(),
    );
    if (parsed == null) return;

    baseRateDebounce = Timer(
      const Duration(milliseconds: 600),
      () => BillService.saveBaseRate(parsed),
    );
  }

  void applyBudgetValue({
    required String value,
    required TextEditingController controller,
  }) {
    if (budgetDirty) return;

    suspendListeners = true;
    controller.text = value;
    suspendListeners = false;
  }

  void applyBaseRateValue({
    required String value,
    required TextEditingController controller,
  }) {
    if (baseRateDirty) return;

    suspendListeners = true;
    controller.text = value;
    suspendListeners = false;
  }

  void dispose() {
    budgetDebounce?.cancel();
    baseRateDebounce?.cancel();
  }
}
