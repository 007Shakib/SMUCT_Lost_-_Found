import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../mock/mock_data.dart';
import '../models/user_model.dart';

/// Authentication Service (UC-01 Register Account, UC-02 Login, FR-01, FR-02)
/// Interfaces with Firebase Authentication & Cloud Firestore user collection.
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  User? get currentFirebaseUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Map Firebase error codes to user-friendly error messages
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'operation-not-allowed':
          return 'Email/Password sign-in is disabled in Firebase Console. Enable it under Authentication > Sign-in method.';
        case 'user-not-found':
          return 'No account found with this email address.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password. Please try again.';
        case 'email-already-in-use':
          return 'This email address is already registered. Please log in.';
        case 'invalid-email':
          return 'The email address is improperly formatted.';
        case 'weak-password':
          return 'Password is too weak. Please use at least 6 characters.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'user-disabled':
          return 'This user account has been disabled by an administrator.';
        case 'too-many-requests':
          return 'Too many unsuccessful attempts. Please try again later.';
        default:
          return error.message ?? 'Authentication error (${error.code}).';
      }
    }
    return error?.toString() ?? 'An unknown error occurred.';
  }

  /// Authenticate user via Email & Password (UC-02)
  Future<UserModel?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      final role = (email.toLowerCase().contains('admin')) ? 'Admin' : 'Student';

      _currentUser = UserModel(
        userId: user?.uid ?? 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: user?.displayName ?? (email.split('@').first),
        email: email.trim(),
        role: role,
        phoneNumber: user?.phoneNumber,
        profilePhotoUrl: user?.photoURL,
      );

      MockData.currentUser = _currentUser!;
      return _currentUser;
    } on FirebaseAuthException catch (e) {
      debugPrint('AuthService.loginWithEmailAndPassword FirebaseAuthException: [${e.code}] ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('AuthService.loginWithEmailAndPassword error: $e');
      rethrow;
    }
  }

  /// Register new user account (UC-01)
  Future<UserModel?> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phoneNumber,
    String? department,
    String? studentId,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user != null && name.isNotEmpty) {
        await user.updateDisplayName(name);
      }

      _currentUser = UserModel(
        userId: user?.uid ?? 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email.trim(),
        role: role,
        phoneNumber: phoneNumber,
        department: department,
        studentId: studentId,
      );

      MockData.currentUser = _currentUser!;
      return _currentUser;
    } on FirebaseAuthException catch (e) {
      debugPrint('AuthService.registerUser FirebaseAuthException: [${e.code}] ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('AuthService.registerUser error: $e');
      rethrow;
    }
  }

  /// Send password reset link to user email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      debugPrint('AuthService.sendPasswordResetEmail FirebaseAuthException: [${e.code}] ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('AuthService.sendPasswordResetEmail error: $e');
      rethrow;
    }
  }

  /// Update Profile Information (UC-03 / FR-14)
  Future<void> updateProfile({String? name, String? phone, String? photoUrl}) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (name != null) await user.updateDisplayName(name);
        if (photoUrl != null) await user.updatePhotoURL(photoUrl);
      }
      if (_currentUser != null) {
        _currentUser = UserModel(
          userId: _currentUser!.userId,
          name: name ?? _currentUser!.name,
          email: _currentUser!.email,
          role: _currentUser!.role,
          phoneNumber: phone ?? _currentUser!.phoneNumber,
          profilePhotoUrl: photoUrl ?? _currentUser!.profilePhotoUrl,
          department: _currentUser!.department,
          studentId: _currentUser!.studentId,
        );
        MockData.currentUser = _currentUser!;
      }
    } catch (e) {
      debugPrint('AuthService.updateProfile error: $e');
      rethrow;
    }
  }

  /// Sign out active session
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('AuthService.signOut error: $e');
    } finally {
      _currentUser = null;
    }
  }
}
