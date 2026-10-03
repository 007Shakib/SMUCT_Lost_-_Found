class ClaimModel {
  final String claimId;
  final String itemId;
  final String claimantId;
  final String itemTitle;
  final String justification;
  final String status; // 'Pending', 'Approved', 'Rejected'
  final DateTime dateSubmitted;
  final String? reviewedByAdminId;

  ClaimModel({
    required this.claimId,
    required this.itemId,
    required this.claimantId,
    required this.itemTitle,
    required this.justification,
    required this.status,
    required this.dateSubmitted,
    this.reviewedByAdminId,
  });

  factory ClaimModel.fromMap(Map<String, dynamic> map, String id) {
    return ClaimModel(
      claimId: id,
      itemId: map['itemId'] ?? '',
      claimantId: map['claimantId'] ?? '',
      itemTitle: map['itemTitle'] ?? '',
      justification: map['justification'] ?? '',
      status: map['status'] ?? 'Pending',
      dateSubmitted: (map['dateSubmitted'] != null)
          ? DateTime.parse(map['dateSubmitted'])
          : DateTime.now(),
      reviewedByAdminId: map['reviewedByAdminId'],
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
    };
  }
}
