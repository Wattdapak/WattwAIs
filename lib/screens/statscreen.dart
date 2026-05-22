import 'package:flutter/material.dart';
import 'package:wattwais/core/theme/app_theme.dart';
import 'package:wattwais/models/wattwais_models.dart';
import 'package:wattwais/services/prediction_store_service.dart';
import 'package:wattwais/widgets/app_chrome.dart';
import 'package:wattwais/widgets/screenscaffold.dart';
import 'package:wattwais/widgets/bottom_nav.dart';
import 'package:wattwais/widgets/monthly_chart.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key, this.latestPrediction, this.aiInsights});

  final Map<String, dynamic>? latestPrediction;
  final Map<String, dynamic>? aiInsights;

  List<UsageMonth> _buildUsageHistory(Map<String, dynamic>? record) {
    final bills = record?['bills'];
    if (bills is! List || bills.isEmpty) {
      return usageHistory;
    }

    final mapped = <UsageMonth>[];
    for (final item in bills.reversed) {
      if (item is! Map<String, dynamic>) continue;
      final month = (item['month'] as String?) ?? '';
      final kwh = (item['kwh_used'] as num?)?.toDouble() ?? 0.0;
      final label = month.length >= 7 ? month.substring(5, 7) : '--';
      mapped.add(UsageMonth(label, kwh));
    }

    return mapped.isEmpty ? usageHistory : mapped;
  }

  @override
  Widget build(BuildContext context) {
    if (latestPrediction != null) {
      return _buildScaffold(context, latestPrediction);
    }

    return StreamBuilder<Map<String, dynamic>?>(
      stream: PredictionStoreService.streamLatestPrediction(),
      builder: (context, snapshot) {
        return _buildScaffold(context, snapshot.data);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, Map<String, dynamic>? record) {
    final prediction = record?['prediction_result'] as Map<String, dynamic>?;
    final estimatedBill = (prediction?['estimated_bill'] as num?)?.toDouble() ?? 0.0;
    final estimatedKwh = (prediction?['estimated_monthly_kwh'] as num?)?.toDouble() ?? 0.0;
    final chartData = _buildUsageHistory(record);
    final statsInsight = aiInsights?['stats_insight'] as Map<String, dynamic>?;
    final statsHeadline = (statsInsight?['headline'] ?? 'Usage trend').toString();
    final statsMessage = (statsInsight?['message'] ?? 'Run a prediction to generate trend insights.').toString();
    final statsDriver = (statsInsight?['key_driver'] ?? 'Latest prediction').toString();

    return Scaffold(
      body: ScreenScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Your usage', style: context.titleLarge),
            ),
            const SizedBox(height: 8),
            const Text(
              'Latest prediction and history',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 14,
                fontFamily: 'Helvetica Neue',
              ),
            ),
            const SizedBox(height: 24),
            _AverageCard(averageBill: estimatedBill),
            const SizedBox(height: 22),
            WattCard(
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
              child: SizedBox(
                height: 238,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monthly kWh',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Helvetica Neue',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(child: MonthlyChart(data: chartData)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            WattCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const IconBubble(icon: Icons.insights_rounded),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            statsHeadline,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          statsMessage,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 14,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Key driver: $statsDriver',
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            WattCard(
              child: Row(
                children: [
                  const IconBubble(icon: Icons.calendar_today_outlined),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Next billing',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Helvetica Neue',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Estimated PHP ${estimatedBill.toStringAsFixed(2)} · ${estimatedKwh.toStringAsFixed(0)} kWh',
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 14,
                              fontFamily: 'Helvetica Neue',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const WattBottomNav(currentIndex: 1),
    );
  }
}

class _AverageCard extends StatelessWidget {
  const _AverageCard({required this.averageBill});

  final double averageBill;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AVG MONTHLY',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 13,
              letterSpacing: 0,
              fontFamily: 'Helvetica Neue',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'PHP ${averageBill.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                fontFamily: 'Helvetica Neue',
              ),
            ),
          ),
          const SizedBox(height: 16),
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Based on your latest prediction',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 15,
                fontFamily: 'Helvetica Neue',
              ),
            ),
          ),
        ],
      ),
    );
  }
}