//import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wattwais/core/theme/app_theme.dart';
//import 'package:wattwais/models/wattwais_models.dart';
import 'package:wattwais/widgets/app_chrome.dart';
import 'package:wattwais/widgets/bottom_nav.dart';
//import 'package:wattwais/screens/dashboard.dart';
//import '../widgets/bottom_nav.dart';
import '../widgets/screenscaffold.dart';


class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tips', style: context.titleLarge),
          const SizedBox(height: 8),
          const Text(
            'Smarter savings this week',
            style: TextStyle(color: AppColors.muted, fontSize: 14),
          ),
          const SizedBox(height: 22),
          const WattCard(
            color: AppColors.navyPanel,
            borderColor: AppColors.border,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconBubble(icon: Icons.thermostat_rounded),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Raise AC by 1°C',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Estimated savings: ₱420 monthly while keeping your peak hours comfortable.',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 16,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const WattCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconBubble(icon: Icons.schedule_rounded),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shift laundry off peak',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Run high-load appliances before 7 PM to lower evening spikes.',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 16,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const WattCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 160, height: 18),
                SizedBox(height: 16),
                SkeletonLine(width: double.infinity, height: 14),
                SizedBox(height: 10),
                SkeletonLine(width: 220, height: 14),
              ],
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: const WattBottomNav(currentIndex: 2),
  );
  }
}