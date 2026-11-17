import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/app_routes.dart';
import 'config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    debugPrint("Firebase initialized successfully.");
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }
  runApp(const SmuctLostAndFoundApp());
}

/// SMUCT Lost & Found Mobile Application (SRS Version 1.0)
class SmuctLostAndFoundApp extends StatelessWidget {
  const SmuctLostAndFoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMUCT Lost & Found Portal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
    );
  }
}
