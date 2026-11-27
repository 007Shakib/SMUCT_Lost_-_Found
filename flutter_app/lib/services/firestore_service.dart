import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../config/firebase_config.dart';
import '../models/item_model.dart';
import '../models/claim_model.dart';
import '../mock/mock_data.dart';

/// Cloud Firestore Data Service Handler (UC-04, UC-05, UC-07, UC-10, UC-12)
class FirestoreService {
  FirebaseFirestore get _firestore => FirebaseConfig.isInitialized ? FirebaseConfig.firestore : FirebaseFirestore.instance;

  /// Real-time stream of campus item listings from Cloud Firestore
  Stream<List<ItemModel>> streamListings({String? category, String? status}) {
    Query<Map<String, dynamic>> query = _firestore.collection('items');

    if (status != null && status != 'All') {
      query = query.where('status', isEqualTo: status);
    }
    if (category != null && category != 'All' && category != 'All Categories') {
      query = query.where('categoryId', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        // Fallback to mock data if Firestore has not yet been populated
        List<ItemModel> result = List.from(MockData.items);
        if (status != null && status != 'All') {
          result = result.where((item) => item.status == status).toList();
        }
        if (category != null && category != 'All' && category != 'All Categories') {
          result = result.where((item) => item.categoryId == category).toList();
        }
        return result;
      }

      final list = snapshot.docs.map((doc) => ItemModel.fromMap(doc.data(), doc.id)).toList();
      // Sort newest first
      list.sort((a, b) => b.datePosted.compareTo(a.datePosted));
      return list;
    });
  }

  /// Create new item report in Firestore
  Future<void> addItemReport(ItemModel item) async {
    try {
      await _firestore.collection('items').doc(item.itemId).set(item.toMap());
    } catch (e) {
      debugPrint('FirestoreService.addItemReport error: $e');
      // Sync with in-memory list for graceful offline experience
      MockData.items.insert(0, item);
    }
  }

  /// Submit new claim request in Firestore
  Future<void> submitClaim(ClaimModel claim) async {
    try {
      await _firestore.collection('claims').doc(claim.claimId).set(claim.toMap());
    } catch (e) {
      debugPrint('FirestoreService.submitClaim error: $e');
      MockData.claims.insert(0, claim);
    }
  }

  Future<void> submitClaimRequest(ClaimModel claim) => submitClaim(claim);

  /// Stream claims submitted by a specific student/user
  Stream<List<ClaimModel>> streamUserClaims(String userId) {
    return _firestore
        .collection('claims')
        .where('claimantId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return MockData.claims.where((c) => c.claimantId == userId).toList();
      }
      final list = snapshot.docs.map((doc) => ClaimModel.fromMap(doc.data(), doc.id)).toList();
      list.sort((a, b) => b.dateSubmitted.compareTo(a.dateSubmitted));
      return list;
    });
  }

  /// Fetch all pending claims
  Future<List<ClaimModel>> getPendingClaims() async {
    try {
      final snapshot = await _firestore
          .collection('claims')
          .where('status', isEqualTo: 'Pending')
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((d) => ClaimModel.fromMap(d.data(), d.id)).toList();
      }
    } catch (e) {
      debugPrint('FirestoreService.getPendingClaims error: $e');
    }
    return MockData.claims.where((c) => c.status == 'Pending').toList();
  }

  /// Update claim status
  Future<void> updateClaimStatus(String claimId, String newStatus) async {
    try {
      await _firestore.collection('claims').doc(claimId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('FirestoreService.updateClaimStatus error: $e');
      final index = MockData.claims.indexWhere((c) => c.claimId == claimId);
      if (index != -1) {
        MockData.claims[index] = MockData.claims[index].copyWith(status: newStatus);
      }
    }
  }
}
