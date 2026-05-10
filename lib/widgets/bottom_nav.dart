

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:wattwais/core/theme/app_theme.dart';
//import 'package:wattwais/models/wattwais_models.dart';
//import 'package:wattwais/widgets/app_chrome.dart';
//import 'package:wattwais/screens/dashboard.dart';

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 72,
          padding: const EdgeInsets.symmetric(vertical: 8),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(18),
          //   border: selected
          //       ? Border.all(color: AppColors.text, width: 2)
          //       : null,
          // ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF0C4C76)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: selected ? AppColors.cyan : AppColors.muted,
                  size: 27,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.cyan : AppColors.muted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WattBottomNav extends StatelessWidget {
  const WattBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  static const _items = [
    (Icons.home_outlined, 'Home'),
    (Icons.bar_chart_rounded, 'Stats'),
    (Icons.lightbulb_outline_rounded, 'Tips'),
    (Icons.person_outline_rounded, 'Me'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 147,
      decoration: const BoxDecoration(
        color: AppColors.ink,
        border: Border(top: BorderSide(color: AppColors.mutedBorder, width: 1)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        math.max(18, MediaQuery.paddingOf(context).bottom + 8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final item in _items.indexed)
            _NavItem(
              icon: item.$2.$1,
              label: item.$2.$2,
              selected: item.$1 == currentIndex,
              onTap: () => onChanged(item.$1),
            ),
        ],
      ),
    );
  }
}