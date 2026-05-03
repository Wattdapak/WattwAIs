class AppInitializer {
  static Future<void> initialize() async {
    await Future.delayed(Duration(seconds: 2));

    // Example:
    // await Firebase.initializeApp();
    // await loadUserData();
  }
}