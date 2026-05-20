import 'package:flutter/material.dart';
import 'package:wattwais/core/theme/app_theme.dart';
//import 'package:wattwais/models/wattwais_models.dart';
import 'package:wattwais/widgets/app_chrome.dart';
//import 'package:wattwais/screens/dashboard.dart';
//import '../widgets/bottom_nav.dart';
import '../widgets/screenscaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key, 
    required this.onPredict,
    required this.bill,
    required this.usage,
    required this.budgetUsage,
  });

  final VoidCallback onPredict;
  final double bill;
  final double usage;
  final double budgetUsage;

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      background: AppColors.midnight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double currentWidth = constraints.maxWidth;
          // Dynamically handle spacing parameters for small vs normal screens
          final double spacing = currentWidth < 360 ? 10.0 : 14.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HomeHeader(),
              const SizedBox(height: 22),
              BillHeroCard(
                bill: bill, 
                usage: usage, 
                budgetusage: budgetUsage
              ),
              const SizedBox(height: 16),
              
              // Responsive Metric Grid Container Row
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      icon: Icons.trending_up_rounded,
                      value: '22.7 kWh',
                      label: 'Daily avg',
                      delta: '-4%',
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: MetricCard(
                      icon: Icons.eco_outlined,
                      value: '12.4 kg',
                      label: 'CO₂ saved',
                      delta: '+8%',
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing),
              const ApplianceUsageCard(),
              SizedBox(height: spacing),
              const AiInsightCard(),
              const SizedBox(height: 52),
              
              // Bottom Action Button Wrapper
              SizedBox(
                width: double.infinity,
                child: PrimaryPillButton(
                  label: 'Predict next bill  →',
                  onPressed: onPredict,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFE6DFD2), Color(0xFFB7C0CC)],
            ),
          ),
          child: const Center(
            child: Text(
              'J',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Good evening',
                  style: TextStyle(
                    color: Color(0xFFC9CEE1),
                    fontSize: 16,
                    fontFamily: 'Helvetica Neue',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Julo',
                  style: TextStyle(
                    color: Color(0xFFDDE1F0),
                    fontSize: 19,
                    fontFamily: 'Helvetica Neue',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF252B56),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_none_rounded),
            ),
            Positioned(
              top: 14,
              right: 13,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: AppColors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BillHeroCard extends StatelessWidget {
  const BillHeroCard({
    super.key,
    required this.bill,
    required this.usage,
    required this.budgetusage,
  });

  final double bill;
  final double usage;
  final double budgetusage;

  @override
  Widget build(BuildContext context) {
    final billWhole = bill.toStringAsFixed(2).split('.')[0];
    final billDecimal = bill.toStringAsFixed(2).split('.')[1];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your bill for this month',
            style: TextStyle(
              color: Color(0xFF073A68),
              fontSize: 14,
              fontFamily: 'Helvetica Neue',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 26),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: AppColors.midnight,
                  fontSize: 56,
                  fontFamily: 'Helvetica Neue',
                  fontWeight: FontWeight.w900,
                  height: .9,
                  letterSpacing: 0,
                ),
                children: [
                  TextSpan(text: '₱$billWhole'),
                  TextSpan(
                    text: ".$billDecimal",
                    style: const TextStyle(color: AppColors.blueDark),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${usage.toStringAsFixed(0)} kWh',
              style: const TextStyle(
                color: Color(0xFF083D6D),
                fontSize: 13,
                fontFamily: 'Helvetica Neue',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: budgetusage > 0 ? (usage / budgetusage) : 0.0,
              color: AppColors.midnight,
              backgroundColor: AppColors.blueDark,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('0 kWh', style: TextStyle(color: Color(0xFF11517D), fontFamily: 'Helvetica Neue')),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text('Budget: ${budgetusage.toStringAsFixed(0)} kWh'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.delta,
  });

  final IconData icon;
  final String value;
  final String label;
  final String delta;

  @override
  Widget build(BuildContext context) {
    return WattCard(
      color: AppColors.navyPanel,
      borderColor: AppColors.border,
      padding: const EdgeInsets.all(18),
      child: SizedBox(
        height: 104,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.muted, size: 27),
                const Spacer(),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      delta,
                      style: const TextStyle(
                        color: AppColors.blue,
                        fontSize: 12,
                        fontFamily: 'Helvetica Neue',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontFamily: 'Helvetica Neue',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 13,
                  fontFamily: 'Helvetica Neue',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ApplianceUsageCard extends StatelessWidget {
  const ApplianceUsageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return WattCard(
      color: AppColors.navyPanel,
      borderColor: AppColors.border,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      radius: 24,
      child: Row(
        children: [
          const IconBubble(icon: Icons.lightbulb_outline_rounded),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Most Used Appliance',
                    style: TextStyle(color: AppColors.muted, fontSize: 12, fontFamily: 'Helvetica Neue', fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Air Conditioner',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, fontFamily: 'Helvetica Neue'),
                  ),
                ),
                SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '175 kWh · ₱1,400 this month',
                    style: TextStyle(color: AppColors.muted, fontSize: 12, fontFamily: 'Helvetica Neue'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '64%',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800, fontFamily: 'Helvetica Neue'),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('of usage', style: const TextStyle(color: AppColors.muted, fontSize: 8, fontFamily: 'Helvetica Neue')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AiInsightCard extends StatelessWidget {
  const AiInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return WattCard(
      color: AppColors.navyPanel,
      borderColor: AppColors.border,
      radius: 24,
      padding: const EdgeInsets.all(22),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBubble(icon: Icons.smart_toy_outlined),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Insight',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 12),
                Text(
                  'Your AC is driving 64% of usage. Raising the thermostat by 1°C could save you ~ ₱420 this month.',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    height: 1.16,
                    fontFamily: 'Helvetica Neue',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}