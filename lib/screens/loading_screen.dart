import 'package:flutter/material.dart';
import 'dashboard.dart';
import '../services/app_initializer.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await AppInitializer.initialize();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Dashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}