import 'package:cloud_firestore/cloud_firestore.dart';

class ClaimModel {
  final String claimId;
  final String itemId;
  final String claimantId;
  final String itemTitle;
  final String justification;
  final String status; // 'Pending', 'Approved', 'Rejected'
  final DateTime dateSubmitted;
  final String? reviewedByAdminId;
  final String? adminNotes;
  final bool additionalInfoRequested;
  final String? claimantName;
  final String? claimantDepartment;
  final String? claimantPhone;
  final String? claimantStudentId;
  final String? itemImageUrl;
  final String? itemLocation;

  String? get rejectionReason => adminNotes;

  ClaimModel({
    required this.claimId,
    required this.itemId,
    required this.claimantId,
    required this.itemTitle,
    required this.justification,
    required this.status,
    required this.dateSubmitted,
    this.reviewedByAdminId,
    this.adminNotes,
    this.additionalInfoRequested = false,
    this.claimantName,
    this.claimantDepartment,
    this.claimantPhone,
    this.claimantStudentId,
    this.itemImageUrl,
    this.itemLocation,
  });

  factory ClaimModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parsedDate = DateTime.now();
    if (map['dateSubmitted'] != null) {
      if (map['dateSubmitted'] is Timestamp) {
        parsedDate = (map['dateSubmitted'] as Timestamp).toDate();
      } else if (map['dateSubmitted'] is String) {
        parsedDate = DateTime.tryParse(map['dateSubmitted']) ?? DateTime.now();
      }
    }

    return ClaimModel(
      claimId: id,
      itemId: map['itemId'] ?? '',
      claimantId: map['claimantId'] ?? '',
      itemTitle: map['itemTitle'] ?? '',
      justification: map['justification'] ?? '',
      status: map['status'] ?? 'Pending',
      dateSubmitted: parsedDate,
      reviewedByAdminId: map['reviewedByAdminId'],
      adminNotes: map['adminNotes'] ?? map['rejectReason'],
      additionalInfoRequested: map['additionalInfoRequested'] ?? false,
      claimantName: map['claimantName'],
      claimantDepartment: map['claimantDepartment'],
      claimantPhone: map['claimantPhone'],
      claimantStudentId: map['claimantStudentId'],
      itemImageUrl: map['itemImageUrl'],
      itemLocation: map['itemLocation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'claimantId': claimantId,
      'itemTitle': itemTitle,
      'justification': justification,
      'status': status,
      'dateSubmitted': dateSubmitted.toIso8601String(),
      'reviewedByAdminId': reviewedByAdminId,
      'adminNotes': adminNotes,
      'additionalInfoRequested': additionalInfoRequested,
      'claimantName': claimantName,
      'claimantDepartment': claimantDepartment,
      'claimantPhone': claimantPhone,
      'claimantStudentId': claimantStudentId,
      'itemImageUrl': itemImageUrl,
      'itemLocation': itemLocation,
    };
  }

  ClaimModel copyWith({
    String? status,
    String? reviewedByAdminId,
    String? adminNotes,
    bool? additionalInfoRequested,
    String? claimantName,
    String? claimantDepartment,
    String? claimantPhone,
    String? claimantStudentId,
    String? itemImageUrl,
    String? itemLocation,
  }) {
    return ClaimModel(
      claimId: claimId,
      itemId: itemId,
      claimantId: claimantId,
      itemTitle: itemTitle,
      justification: justification,
      status: status ?? this.status,
      dateSubmitted: dateSubmitted,
      reviewedByAdminId: reviewedByAdminId ?? this.reviewedByAdminId,
      adminNotes: adminNotes ?? this.adminNotes,
      additionalInfoRequested: additionalInfoRequested ?? this.additionalInfoRequested,
      claimantName: claimantName ?? this.claimantName,
      claimantDepartment: claimantDepartment ?? this.claimantDepartment,
      claimantPhone: claimantPhone ?? this.claimantPhone,
      claimantStudentId: claimantStudentId ?? this.claimantStudentId,
      itemImageUrl: itemImageUrl ?? this.itemImageUrl,
      itemLocation: itemLocation ?? this.itemLocation,
    );
  }
}
