import 'dart:async';
import '../models/user_model.dart';
import '../models/item_model.dart';
import '../models/claim_model.dart';

/// Administrator Service Handler
/// Covers: UC-10 (Manage Users), UC-11 (Moderate Posts), UC-12 (Approve/Reject Claims), UC-13 (Platform Statistics)
class AdminService {
  /// UC-10: Retrieve list of registered platform users (FR-10)
  Future<List<UserModel>> fetchRegisteredUsers() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      UserModel(
        userId: 'usr_student_01',
        name: 'Mahin Mia',
        email: 'mahin.241071018@shanto-mariam.edu.bd',
        role: 'Student',
        phoneNumber: '+880 1712-345678',
      ),
      UserModel(
        userId: 'usr_student_02',
        name: 'Shakib Sharkar',
        email: 'shakib.241071041@shanto-mariam.edu.bd',
        role: 'Student',
        phoneNumber: '+880 1819-987654',
      ),
      UserModel(
        userId: 'usr_staff_01',
        name: 'Library Admin',
        email: 'library@shanto-mariam.edu.bd',
        role: 'Staff',
      ),
    ];
  }

  /// UC-10: Suspend or restore user account
  Future<void> toggleUserSuspension(String userId, bool suspend) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// UC-11: Moderate / remove inappropriate lost/found posts (FR-11)
  Future<void> removePost(String itemId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  /// UC-12: Adjudicate pending claim request - Approve or Reject (FR-12)
  Future<void> adjudicateClaim({
    required String claimId,
    required String itemId,
    required bool approve,
    String? adminNotes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// UC-13: Fetch Platform Summary Statistics (FR-13)
  Future<Map<String, dynamic>> fetchPlatformStatistics() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'totalUsers': 142,
      'activeListings': 38,
      'pendingClaims': 5,
      'resolvedClaims': 24,
      'recoveryRate': '86.3%',
    };
  }
}
