
import 'package:flutter/material.dart';
import 'package:wattwais/core/theme/app_theme.dart';
//import 'package:wattwais/models/wattwais_models.dart';
//import 'package:wattwais/widgets/app_chrome.dart';
//import 'package:wattwais/screens/dashboard.dart';

class ScreenScaffold extends StatelessWidget {
  const ScreenScaffold({
    super.key,
    required this.child,
    this.background = AppColors.ink,
    this.withBottomPadding = true,
  });

  final Widget child;
  final Color background;
  final bool withBottomPadding;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: background,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            AppSpacing.page,
            24,
            AppSpacing.page,
            withBottomPadding ? 124 : 24,
          ),
          child: child,
        ),
      ),
    );
  }
}
