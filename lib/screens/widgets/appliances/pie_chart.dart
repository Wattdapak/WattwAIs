import 'package:flutter/material.dart';

class PieChart extends StatelessWidget {
  const PieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PieChartPainter(),
    );
  }
}

class PieChartPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.pink,
    ];

    final percentages = [35, 25, 20, 12, 8];

    double startRadian = -1.57;

    for (int i = 0; i < percentages.length; i++) {

      final sweepRadian =
          (percentages[i] / 100) * 6.28319;

      paint.color = colors[i];

      canvas.drawArc(
        rect,
        startRadian,
        sweepRadian,
        true,
        paint,
      );

      startRadian += sweepRadian;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}