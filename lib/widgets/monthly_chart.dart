import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/wattwais_models.dart';

class MonthlyChart extends StatelessWidget {
  const MonthlyChart({super.key, required this.data});

  final List<UsageMonth> data;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MonthlyChartPainter(data),
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
    const chartTop = 14.0;
    final chartBottom = size.height - 32;

    final maxKwh = data.map((item) => item.kwh).reduce(math.max);
    final minKwh = data.map((item) => item.kwh).reduce(math.min);
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
        Offset(
          gap * i + gap / 2 - labelPainter.width / 2,
          size.height - 18,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MonthlyChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
