import "package:flutter/material.dart";
import "package:wattwais/core/routes/router.dart";

class WattwAIsApp extends StatelessWidget {
  const WattwAIsApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "WattwAIs",
      debugShowCheckedModeBanner: false,
      routerConfig: WattwaisRouter.router,
    );
  }
}