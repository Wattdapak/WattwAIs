import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:wattwais/core/routes/screen_routes.dart";
import "package:wattwais/core/theme/app_theme.dart";

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(Routes.dashboard);
      } else {
        debugPrint(
          "Splash Screen: context not mounted. Cant navigate to dashboard",
        );
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue.withValues(alpha: .42),
                    blurRadius: 46,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.bolt_rounded,
                color: AppColors.ink,
                size: 76,
              ),
            ),
            const SizedBox(height: 54),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 46,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
                children: [
                  TextSpan(text: 'Wattw'),
                  TextSpan(
                    text: 'AI',
                    style: TextStyle(color: AppColors.cyan),
                  ),
                  TextSpan(text: 's'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'PREDICT · SAVE · POWER',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
