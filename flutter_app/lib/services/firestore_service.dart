import 'dart:async';
import '../models/item_model.dart';
import '../models/claim_model.dart';

/// Cloud Firestore Data Service Handler (UC-04, UC-05, UC-07, UC-10, UC-12)
class FirestoreService {
  final List<ItemModel> _mockItems = [
    ItemModel(
      itemId: 'itm_001',
      userId: 'usr_staff_02',
      categoryId: 'Documents & IDs',
      title: 'Student ID Card & Wallet',
      description: 'Found a black leather wallet containing a SMUCT Student ID card (Batch 34th) near the study desk area.',
      status: 'Found',
      claimStatus: 'Available',
      imageUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=500&auto=format&fit=crop&q=80',
      location: 'Central Library (3rd Floor)',
      datePosted: DateTime.now().subtract(const Duration(days: 1)),
      authorName: 'Library Staff',
    ),
    ItemModel(
      itemId: 'itm_002',
      userId: 'usr_student_01',
      categoryId: 'Electronics',
      title: 'Apple AirPods Pro Case',
      description: 'Lost my white AirPods Pro charging case with a blue silicone sleeve during lunch hour around 1:30 PM.',
      status: 'Lost',
      claimStatus: 'Available',
      imageUrl: 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=500&auto=format&fit=crop&q=80',
      location: 'Campus Cafeteria',
      datePosted: DateTime.now().subtract(const Duration(days: 2)),
      authorName: 'Mahin Mia',
    ),
  ];

  final List<ClaimModel> _mockClaims = [];

  Stream<List<ItemModel>> streamListings({String? category, String? status}) async* {
    List<ItemModel> result = List.from(_mockItems);
    if (status != null && status != 'All') {
      result = result.where((item) => item.status == status).toList();
    }
    if (category != null && category != 'All Categories') {
      result = result.where((item) => item.categoryId == category).toList();
    }
    yield result;
  }

  Future<void> addItemReport(ItemModel item) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockItems.insert(0, item);
  }

  Future<void> submitClaim(ClaimModel claim) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockClaims.add(claim);
  }

  Future<void> submitClaimRequest(ClaimModel claim) => submitClaim(claim);

  Stream<List<ClaimModel>> streamUserClaims(String userId) async* {
    yield _mockClaims.where((c) => c.claimantId == userId).toList();
  }

  Future<List<ClaimModel>> getPendingClaims() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockClaims.where((c) => c.status == 'Pending').toList();
  }

  Future<void> updateClaimStatus(String claimId, String newStatus) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockClaims.indexWhere((c) => c.claimId == claimId);
    if (index != -1) {
      final updated = ClaimModel(
        claimId: _mockClaims[index].claimId,
        itemId: _mockClaims[index].itemId,
        claimantId: _mockClaims[index].claimantId,
        itemTitle: _mockClaims[index].itemTitle,
        justification: _mockClaims[index].justification,
        status: newStatus,
        dateSubmitted: _mockClaims[index].dateSubmitted,
      );
      _mockClaims[index] = updated;
    }
  }
}
