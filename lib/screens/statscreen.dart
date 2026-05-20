import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wattwais/core/theme/app_theme.dart';
import 'package:wattwais/models/wattwais_models.dart';
import 'package:wattwais/widgets/app_chrome.dart';
import '../widgets/screenscaffold.dart';
import 'package:wattwais/widgets/bottom_nav.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              'Last 7 months',
              style: TextStyle(
                color: AppColors.muted, 
                fontSize: 14, 
                fontFamily: 'Helvetica Neue',
              ),
            ),
            const SizedBox(height: 24),
            const _AverageCard(),
            const SizedBox(height: 22),
            const WattCard(
              padding: EdgeInsets.fromLTRB(22, 26, 22, 22),
              child: SizedBox(
                height: 238,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly kWh',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.w800, 
                        fontFamily: 'Helvetica Neue',
                      ),
                    ),
                    SizedBox(height: 12),
                    Expanded(child: MonthlyChart()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Side-by-side Adaptive Grid System
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 280) {
                  return const Column(
                    children: [
                      _SmallStat(
                        title: 'PEAK HOUR',
                        value: '7–9 PM',
                        label: '42% of daily use',
                      ),
                      SizedBox(height: 14),
                      _SmallStat(
                        title: 'VS PREV MONTH',
                        value: '-12%',
                        label: 'More efficient',
                        accent: true,
                      ),
                    ],
                  );
                }
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _SmallStat(
                        title: 'PEAK HOUR',
                        value: '7–9 PM',
                        label: '42% of daily use',
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: _SmallStat(
                        title: 'VS PREV MONTH',
                        value: '-12%',
                        label: 'More efficient',
                        accent: true,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),
            const WattCard(
              child: Row(
                children: [
                  IconBubble(icon: Icons.calendar_today_outlined),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
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
                        SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Estimated ₱2,184 · Aug 24',
                            style: TextStyle(
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
  const _AverageCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AVG MONTHLY',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 13,
              letterSpacing: 0,
              fontFamily: 'Helvetica Neue',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '₱2,340',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                fontFamily: 'Helvetica Neue',
              ),
            ),
          ),
          SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '⌄ 6.2% lower vs last quarter',
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

class MonthlyChart extends StatelessWidget {
  const MonthlyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MonthlyChartPainter(usageHistory),
      child: const SizedBox.expand(),
    );
  }
}

class _MonthlyChartPainter extends CustomPainter {
  const _MonthlyChartPainter(this.data);

  final List<UsageMonth> data;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final labelPainter = TextPainter(textDirection: TextDirection.ltr);
    final chartTop = 14.0;
    final chartBottom = size.height - 32;
    final maxKwh = data.map((item) => item.kwh).reduce(math.max);
    final minKwh = data.map((item) => item.kwh).reduce(math.min);
    
    // Safety check for single records or flat data sets
    final delta = (maxKwh - minKwh) == 0 ? 1.0 : (maxKwh - minKwh);
    final gap = size.width / data.length;
    final points = <Offset>[];

    for (var i = 0; i < data.length; i++) {
      final normalized = (data[i].kwh - minKwh) / delta;
      points.add(
        Offset(
          gap * i + gap / 2,
          chartBottom - normalized * (chartBottom - chartTop),
        ),
      );
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final point = points[i];
      path.cubicTo(
        previous.dx + gap * .38,
        previous.dy,
        point.dx - gap * .38,
        point.dy,
        point.dx,
        point.dy,
      );
    }

    final fill = Path.from(path)
      ..lineTo(points.last.dx, chartBottom)
      ..lineTo(points.first.dx, chartBottom)
      ..close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x4431C6FF), Color(0x0031C6FF)],
        ).createShader(Rect.fromLTWH(0, chartTop, size.width, chartBottom)),
    );
    
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.cyan
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4,
    );

    for (final point in points) {
      canvas.drawCircle(point, 5, Paint()..color = AppColors.cyan);
    }

    for (var i = 0; i < data.length; i++) {
      labelPainter.text = TextSpan(
        text: data[i].label,
        style: const TextStyle(color: AppColors.muted, fontSize: 12),
      );
      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(gap * i + gap / 2 - labelPainter.width / 2, size.height - 18),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MonthlyChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

class _SmallStat extends StatelessWidget {
  const _SmallStat({
    required this.title,
    required this.value,
    required this.label,
    this.accent = false,
  });

  final String title;
  final String value;
  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return WattCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title, 
              style: context.sectionLabel.copyWith(fontSize: 12, letterSpacing: 0),
            ),
          ),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: accent ? AppColors.cyan : AppColors.text,
                fontSize: 23,
                fontFamily: 'Helvetica Neue',
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}