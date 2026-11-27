import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../firebase_options.dart';

/// Central Firebase Configuration and Lifecycle Manager
/// Ensures single initialization, consistent app instance, and prevents early uninitialized access.
class FirebaseConfig {
  FirebaseConfig._();

  static bool _initializing = false;

  /// Check whether Firebase has been initialized
  static bool get isInitialized => Firebase.apps.isNotEmpty;

  /// Get the active default Firebase app
  static FirebaseApp get app {
    if (Firebase.apps.isNotEmpty) {
      return Firebase.app();
    }
    throw StateError(
      "[FirebaseConfig] Firebase App has not been initialized yet. "
      "Ensure await FirebaseConfig.initialize() completes before accessing Firebase services.",
    );
  }

  /// Centralized FirebaseAuth instance bound to the initialized app
  static FirebaseAuth get auth => FirebaseAuth.instanceFor(app: app);

  /// Centralized FirebaseFirestore instance bound to the initialized app
  static FirebaseFirestore get firestore => FirebaseFirestore.instanceFor(app: app);

  /// Centralized FirebaseStorage instance bound to the initialized app
  static FirebaseStorage get storage => FirebaseStorage.instanceFor(app: app);

  /// Initialize Firebase exactly once using the project's central configuration
  static Future<FirebaseApp> initialize() async {
    // 1. If already initialized, return existing instance immediately
    if (Firebase.apps.isNotEmpty) {
      return Firebase.app();
    }

    // 2. Prevent concurrent duplicate initializations
    while (_initializing) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (Firebase.apps.isNotEmpty) {
        return Firebase.app();
      }
    }

    _initializing = true;
    try {
      // 1. Try initializing with platform options
      try {
        final app = await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        debugPrint('[FirebaseConfig] Initialized Firebase [DEFAULT] app with options: ${app.name} (${app.options.projectId})');
        return app;
      } catch (optionsError) {
        debugPrint('[FirebaseConfig] Options initialization notice: $optionsError. Falling back to native/default initialization...');
        // 2. Fallback: on Android/iOS where native configuration already initialized, or if options were not required
        final app = await Firebase.initializeApp();
        debugPrint('[FirebaseConfig] Initialized Firebase [DEFAULT] app natively: ${app.name}');
        return app;
      }
    } catch (e) {
      if (Firebase.apps.isNotEmpty) {
        return Firebase.app();
      }
      debugPrint('[FirebaseConfig] Fatal Firebase.initializeApp error: $e');
      rethrow;
    } finally {
      _initializing = false;
    }
  }
}
