import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: LoadingScreen(),
    );
  }
}