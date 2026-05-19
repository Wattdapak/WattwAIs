import 'package:flutter/material.dart';
import 'package:wattwais/core/theme/app_theme.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = const Color(0xFF151D25),
    this.foreground = AppColors.text,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: foreground,
          size: 22,
        ),
      ),
    );
  }
}