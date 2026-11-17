import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  User? get currentFirebaseUser => _auth.currentUser;
  bool get isAuthenticated => _auth.currentUser != null;
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;
  bool get isAdmin => _currentUser?.role == 'Admin';
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// User-friendly error message resolution
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'operation-not-allowed':
          return 'Email/Password sign-in is disabled in Firebase Console. Please enable it in Authentication > Sign-in method.';
        case 'user-not-found':
          return 'No account found with this email address. Please check or register.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password. Please try again.';
        case 'email-already-in-use':
          return 'This email is already registered. Please log in or reset your password.';
        case 'invalid-email':
          return 'The email address is improperly formatted.';
        case 'weak-password':
          return 'Password is too weak. Please use at least 6 characters.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'user-disabled':
          return error.message ?? 'This account has been suspended by the administrator.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a few moments and try again.';
        default:
          return error.message ?? 'Authentication error (${error.code}).';
      }
    } else if (error is FirebaseException) {
      return error.message ?? 'Firebase service error (${error.code}).';
    }
    return error?.toString() ?? 'An unexpected error occurred.';
  }

  /// Register new user account (UC-01)
  /// Enforces secure role assignment (prevents self-granting 'Admin' role)
  /// Stores user profile in Cloud Firestore at `users/{uid}`
  /// Automatically sends an email verification link
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
      // Security: Never permit self-granting Admin privilege via registration
      final safeRole = (role == 'Teacher & Staff') ? 'Teacher & Staff' : 'Student';

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) throw Exception('User creation failed.');

      if (name.isNotEmpty) {
        await user.updateDisplayName(name);
      }

      // Send Email Verification (Requirement 4)
      try {
        await user.sendEmailVerification();
        debugPrint('Verification email sent to ${user.email}');
      } catch (e) {
        debugPrint('Failed to send verification email: $e');
      }

      final userModel = UserModel(
        userId: user.uid,
        name: name,
        email: email.trim(),
        role: safeRole,
        phoneNumber: phoneNumber,
        department: department,
        studentId: studentId,
        isSuspended: false,
      );

      // Store in Cloud Firestore under `users/{uid}` (Requirement 6)
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'userId': user.uid,
          'name': name,
          'email': email.trim(),
          'role': safeRole,
          'phoneNumber': phoneNumber ?? '',
          'department': department ?? '',
          'studentId': studentId ?? '',
          'profilePhotoUrl': '',
          'isSuspended': false,
          'emailVerified': user.emailVerified,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } catch (firestoreError) {
        debugPrint('Firestore user document creation error: $firestoreError');
        // Continue even if Firestore rules or offline temporarily delays write
      }

      _currentUser = userModel;
      MockData.currentUser = userModel;
      return _currentUser;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      debugPrint('AuthService.registerUser error: $e');
      rethrow;
    }
  }

  /// Authenticate user via Email & Password (UC-02)
  /// Fetches profile from Cloud Firestore `users/{uid}` to resolve roles & status
  Future<UserModel?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) throw Exception('Login returned no active user.');

      UserModel userModel;

      // Fetch profile from Firestore
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null) {
          userModel = UserModel.fromMap(doc.data()!, user.uid);
        } else {
          // Fallback if document not yet created
          final defaultRole = email.toLowerCase().contains('admin') ? 'Admin' : 'Student';
          userModel = UserModel(
            userId: user.uid,
            name: user.displayName ?? email.split('@').first,
            email: email.trim(),
            role: defaultRole,
            phoneNumber: user.phoneNumber,
            profilePhotoUrl: user.photoURL,
            isSuspended: false,
          );

          await _firestore.collection('users').doc(user.uid).set({
            'userId': user.uid,
            'name': userModel.name,
            'email': userModel.email,
            'role': userModel.role,
            'phoneNumber': userModel.phoneNumber ?? '',
            'profilePhotoUrl': userModel.profilePhotoUrl ?? '',
            'isSuspended': false,
            'emailVerified': user.emailVerified,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      } catch (e) {
        debugPrint('Warning: Could not fetch Firestore user profile ($e), using local model');
        final defaultRole = email.toLowerCase().contains('admin') ? 'Admin' : 'Student';
        userModel = UserModel(
          userId: user.uid,
          name: user.displayName ?? email.split('@').first,
          email: email.trim(),
          role: defaultRole,
          phoneNumber: user.phoneNumber,
          profilePhotoUrl: user.photoURL,
          isSuspended: false,
        );
      }

      // Check suspension
      if (userModel.isSuspended) {
        await signOut();
        throw FirebaseAuthException(
          code: 'user-disabled',
          message: 'Your account has been suspended by the campus administrator.',
        );
      }

      _currentUser = userModel;
      MockData.currentUser = userModel;
      return _currentUser;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      debugPrint('AuthService.loginWithEmailAndPassword error: $e');
      rethrow;
    }
  }

  /// Reload user and fetch active Firestore profile
  /// Used on app restart to maintain auth state and resolve home destination
  Future<UserModel?> loadCurrentUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _currentUser = null;
        return null;
      }

      await user.reload();
      final updatedUser = _auth.currentUser;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        _currentUser = UserModel.fromMap(doc.data()!, user.uid);
      } else {
        final defaultRole = (updatedUser?.email ?? '').toLowerCase().contains('admin') ? 'Admin' : 'Student';
        _currentUser = UserModel(
          userId: user.uid,
          name: updatedUser?.displayName ?? (updatedUser?.email?.split('@').first ?? 'User'),
          email: updatedUser?.email ?? '',
          role: defaultRole,
          phoneNumber: updatedUser?.phoneNumber,
          profilePhotoUrl: updatedUser?.photoURL,
          isSuspended: false,
        );
      }

      if (_currentUser!.isSuspended) {
        await signOut();
        return null;
      }

      MockData.currentUser = _currentUser!;
      return _currentUser;
    } catch (e) {
      debugPrint('AuthService.loadCurrentUserProfile error: $e');
      if (_auth.currentUser != null) {
        final fallback = UserModel(
          userId: _auth.currentUser!.uid,
          name: _auth.currentUser!.displayName ?? (_auth.currentUser!.email?.split('@').first ?? 'User'),
          email: _auth.currentUser!.email ?? '',
          role: (_auth.currentUser!.email ?? '').toLowerCase().contains('admin') ? 'Admin' : 'Student',
          isSuspended: false,
        );
        _currentUser = fallback;
        MockData.currentUser = fallback;
        return fallback;
      }
      return null;
    }
  }

  /// Send email verification link
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// Send password reset link
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      debugPrint('AuthService.sendPasswordResetEmail error: $e');
      rethrow;
    }
  }

  /// Update Profile Information in both Auth and Firestore
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
    String? department,
    String? studentId,
  }) async {
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
          role: _currentUser!.role, // Retain existing role securely
          phoneNumber: phone ?? _currentUser!.phoneNumber,
          profilePhotoUrl: photoUrl ?? _currentUser!.profilePhotoUrl,
          department: department ?? _currentUser!.department,
          studentId: studentId ?? _currentUser!.studentId,
          isSuspended: _currentUser!.isSuspended,
        );
        MockData.currentUser = _currentUser!;

        if (user != null) {
          await _firestore.collection('users').doc(user.uid).update({
            if (name != null) 'name': name,
            if (phone != null) 'phoneNumber': phone,
            if (photoUrl != null) 'profilePhotoUrl': photoUrl,
            if (department != null) 'department': department,
            if (studentId != null) 'studentId': studentId,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
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
