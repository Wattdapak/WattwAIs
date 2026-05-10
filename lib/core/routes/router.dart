import "package:go_router/go_router.dart";
import "package:wattwais/core/routes/screen_routes.dart";

import "package:wattwais/screens/dashboard.dart";
import "package:wattwais/screens/splash_screen.dart";

class WattwaisRouter {
  static final router = GoRouter(
    initialLocation: Routes.splashscreen,

    routes: [
      GoRoute(
        path: Routes.splashscreen,
        builder: (context, state) => const LogoScreen(),
      ),

      GoRoute(
        path: Routes.dashboard,
        builder: (context, state) => const Dashboard(),
      ),
    ],
  );
}
