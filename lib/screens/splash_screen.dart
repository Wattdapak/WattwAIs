import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:wattwais/core/routes/screen_routes.dart";

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
        debugPrint("Splash Screen: context not mounted. Cant navigate to dashboard");
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 28, 49),
      body: const Center(
        child: Text("WattwAIs", 
        style: TextStyle(color: Colors.white,))
      )
    );
  }
}