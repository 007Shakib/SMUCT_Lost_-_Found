import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../mock/mock_data.dart';

/// Admin Service providing backend integration for SMUCT Lost & Found Admin Console
class AdminService extends ChangeNotifier {
  static final AdminService instance = AdminService._internal();

  AdminService._internal() {
    _initializeData();
  }

  factory AdminService() => instance;

  // Platform Metrics
  int _activePostsCount = 142;
  int _pendingClaimsCount = 8;
  int _resolvedItemsCount = 389;
  int _registeredUsersCount = 2450;

  int get activePostsCount => _activePostsCount;
  int get pendingClaimsCount => _pendingClaimsCount;
  int get resolvedItemsCount => _resolvedItemsCount;
  int get registeredUsersCount => _registeredUsersCount;

  // Category Split Percentages
  final Map<String, int> _categorySplit = {
    'Electronics': 45,
    'Cards & IDs': 25,
    'Keys': 15,
    'Bags': 15,
  };
  Map<String, int> get categorySplit => Map.unmodifiable(_categorySplit);

  // High Priority Claim Approvals
  final List<Map<String, dynamic>> _claimApprovals = [];
  List<Map<String, dynamic>> get claimApprovals => List.unmodifiable(_claimApprovals);

  // Flagged Moderation Items
  final List<Map<String, dynamic>> _flaggedItems = [];
  List<Map<String, dynamic>> get flaggedItems => List.unmodifiable(_flaggedItems);

  // Registered Users list
  final List<UserModel> _users = [];
  List<UserModel> get users => List.unmodifiable(_users);

  void _initializeData() {
    // Initialize Claim Approvals matching screenshot
    _claimApprovals.clear();
    _claimApprovals.addAll([
      {
        'id': 'clm_high_1',
        'title': 'AirPods Pro Gen 2',
        'timeAgo': '12m ago',
        'claimantName': 'Tanvir Ahmed (CS-22-09)',
        'studentId': 'CS-22-09',
        'location': 'Dept. Library, Table 14',
        'imageUrl': 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=600',
        'proof': 'Purchased from Apple Store Dhanmondi. Serial ends with 4X98. Inside right earbud has a minor green speck.',
        'status': 'Pending',
        'isHighPriority': true,
        'department': 'Computer Science & Engineering',
        'phone': '+880 1712-998877',
      },
      {
        'id': 'clm_high_2',
        'title': 'Student ID Card (BBA)',
        'timeAgo': '34m ago',
        'claimantName': 'Nafisa Karim (BBA-23-41)',
        'studentId': 'BBA-23-41',
        'location': 'Cafeteria Counter B',
        'imageUrl': 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=600',
        'proof': 'My SMUCT BBA student ID card with semester validation sticker 2024. Has my student photo and ID 23-41.',
        'status': 'Pending',
        'isHighPriority': true,
        'department': 'Faculty of Business Administration',
        'phone': '+880 1819-334455',
      },
    ]);

    // Initialize Flagged Moderation Items matching screenshot
    _flaggedItems.clear();
    _flaggedItems.addAll([
      {
        'id': 'flag_1',
        'title': 'Suspected Duplicate Listing',
        'subtitle': 'Post #8412 • By Fahim S. • 2 hrs ago',
        'type': 'duplicate',
        'postId': '#8412',
        'reporter': 'Automated Detection Engine',
        'details': 'Image and description match 98% with existing Post #8390 submitted yesterday by another user.',
        'author': 'Fahim S.',
      },
      {
        'id': 'flag_2',
        'title': 'Unclear Claim Proof Image',
        'subtitle': 'Claim #310 • By Sadia A. • Today',
        'type': 'unclear_image',
        'claimId': '#310',
        'reporter': 'Moderation Queue',
        'details': 'Uploaded proof document photo is low resolution and serial number cannot be verified.',
        'author': 'Sadia A.',
      },
    ]);

    // Initialize Users
    _users.clear();
    _users.addAll(MockData.users);
  }

  /// Approve Claim action
  Future<bool> approveClaim(String claimId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _claimApprovals.indexWhere((c) => c['id'] == claimId);
    if (index != -1) {
      _claimApprovals[index]['status'] = 'Approved';
      _pendingClaimsCount = (_pendingClaimsCount > 0) ? _pendingClaimsCount - 1 : 0;
      _resolvedItemsCount += 1;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Reject Claim action with optional reason
  Future<bool> rejectClaim(String claimId, {String? reason}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _claimApprovals.indexWhere((c) => c['id'] == claimId);
    if (index != -1) {
      _claimApprovals[index]['status'] = 'Rejected';
      _claimApprovals[index]['rejectReason'] = reason ?? 'Verification proof insufficient';
      _pendingClaimsCount = (_pendingClaimsCount > 0) ? _pendingClaimsCount - 1 : 0;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Dismiss Flagged Moderation Item
  Future<void> dismissFlag(String flagId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _flaggedItems.removeWhere((f) => f['id'] == flagId);
    notifyListeners();
  }

  /// Remove Post associated with Flag
  Future<void> removeFlaggedPost(String flagId, {String? reason}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _flaggedItems.removeWhere((f) => f['id'] == flagId);
    _activePostsCount = (_activePostsCount > 0) ? _activePostsCount - 1 : 0;
    notifyListeners();
  }

  /// Complete Physical Desk Handover via QR Scan
  Future<Map<String, dynamic>> completeDeskHandover({
    required String studentId,
    required String lockerNumber,
    String? itemName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _resolvedItemsCount += 1;
    _activePostsCount = (_activePostsCount > 0) ? _activePostsCount - 1 : 0;
    notifyListeners();
    return {
      'success': true,
      'studentId': studentId,
      'lockerNumber': lockerNumber,
      'itemName': itemName ?? 'Item',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Toggle User Suspension
  Future<void> toggleUserSuspension(String userId, bool suspend) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _users.indexWhere((u) => u.userId == userId);
    if (idx != -1) {
      _users[idx].isSuspended = suspend;
      notifyListeners();
    }
  }

  /// Delete User
  Future<void> deleteUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _users.removeWhere((u) => u.userId == userId);
    _registeredUsersCount = (_registeredUsersCount > 0) ? _registeredUsersCount - 1 : 0;
    notifyListeners();
  }

  /// Legacy methods compatibility
  Future<List<UserModel>> fetchRegisteredUsers() async {
    return _users;
  }

  Future<void> removePost(String itemId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _activePostsCount = (_activePostsCount > 0) ? _activePostsCount - 1 : 0;
    notifyListeners();
  }

  Future<void> adjudicateClaim({
    required String claimId,
    required String itemId,
    required bool approve,
    String? adminNotes,
  }) async {
    if (approve) {
      await approveClaim(claimId);
    } else {
      await rejectClaim(claimId, reason: adminNotes);
    }
  }

  Future<Map<String, dynamic>> fetchPlatformStatistics() async {
    return {
      'totalUsers': _registeredUsersCount,
      'activeListings': _activePostsCount,
      'pendingClaims': _pendingClaimsCount,
      'resolvedClaims': _resolvedItemsCount,
      'recoveryRate': '94.0%',
      'categorySplit': _categorySplit,
    };
  }
}
