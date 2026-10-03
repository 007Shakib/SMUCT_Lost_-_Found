import 'package:flutter/material.dart';
import 'config/app_routes.dart';
import 'config/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialization stub
  // await Firebase.initializeApp();
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
