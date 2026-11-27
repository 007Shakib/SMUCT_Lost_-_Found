import 'package:flutter/material.dart';
import 'config/app_routes.dart';
import 'config/app_theme.dart';
import 'config/firebase_config.dart';
import 'services/notification_service.dart';
import 'services/admin_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // 1. Initialize Firebase exactly once using the central project configuration
    await FirebaseConfig.initialize();
    debugPrint("Firebase initialized successfully with project: ${FirebaseConfig.app.options.projectId}");
  } catch (e, stackTrace) {
    debugPrint("Firebase initialization error: $e\n$stackTrace");
  }

  // 2. Launch UI immediately so the user never sees a blank screen
  runApp(const SmuctLostAndFoundApp());

  // 3. Run background services asynchronously without blocking startup
  _initBackgroundServices();
}

void _initBackgroundServices() async {
  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint("NotificationService background init: $e");
  }

  try {
    await AdminService.instance.seedInitialDataIfEmpty().timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        debugPrint("AdminService.seedInitialDataIfEmpty skipped: Firestore offline or not provisioned yet.");
      },
    );
  } catch (e) {
    debugPrint("AdminService background seed: $e");
  }
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
