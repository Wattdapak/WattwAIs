import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _dartDefineBaseUrl =
      String.fromEnvironment('PREDICT_API_BASE_URL');

  static const String _defaultProductionBaseUrl =
      'https://YOUR-RENDER-SERVICE.onrender.com';

  static String get predictionApiBaseUrl {
    if (_dartDefineBaseUrl.isNotEmpty) {
      return _dartDefineBaseUrl;
    }

    if (kReleaseMode) {
      return _defaultProductionBaseUrl;
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // Android emulator -> host machine localhost.
        return 'http://10.0.2.2:8000';
      default:
        return 'http://127.0.0.1:8000';
    }
  }

  static const Duration predictionApiTimeout = Duration(seconds: 15);

  // Example for production:
  // flutter run --dart-define=PREDICT_API_BASE_URL=https://YOUR-RENDER-SERVICE.onrender.com
}
