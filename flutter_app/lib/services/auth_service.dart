import 'dart:async';
import '../models/user_model.dart';

/// Authentication Service (UC-01 Register Account, UC-02 Login, FR-01, FR-02)
/// Interfaces with Firebase Authentication & Cloud Firestore user collection.
class AuthService {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  /// Authenticate user via Email & Password (UC-02)
  Future<UserModel?> loginWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (email.contains('admin')) {
      _currentUser = UserModel(
        userId: 'usr_admin_01',
        name: 'System Administrator',
        email: email,
        role: 'Admin',
      );
    } else {
      _currentUser = UserModel(
        userId: 'usr_student_01',
        name: 'Mahin Mia',
        email: email,
        role: 'Student',
        phoneNumber: '+880 1712-345678',
      );
    }
    return _currentUser;
  }

  /// Register new user account (UC-01)
  Future<UserModel?> registerUser({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phoneNumber,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = UserModel(
      userId: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      role: role,
      phoneNumber: phoneNumber,
    );
    return _currentUser;
  }

  /// Update Profile Information (UC-03 / FR-14)
  Future<void> updateProfile({String? name, String? phone, String? photoUrl}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (_currentUser != null) {
      _currentUser = UserModel(
        userId: _currentUser!.userId,
        name: name ?? _currentUser!.name,
        email: _currentUser!.email,
        role: _currentUser!.role,
        phoneNumber: phone ?? _currentUser!.phoneNumber,
        profilePhotoUrl: photoUrl ?? _currentUser!.profilePhotoUrl,
      );
    }
  }

  /// Sign out active session
  Future<void> signOut() async {
    _currentUser = null;
  }
}
