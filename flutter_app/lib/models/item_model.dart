import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String itemId;
  final String userId;
  final String categoryId;
  final String title;
  final String description;
  final String status; // 'Lost', 'Found', 'Removed'
  final String claimStatus; // 'Available', 'Pending', 'Claimed'
  final String imageUrl;
  final String location;
  final DateTime datePosted;
  final String authorName;
  final String moderationStatus; // 'Approved', 'Pending', 'Removed'
  final bool isFlagged;
  final String? flagReason;
  final String? lockerNumber;
  final bool isHandedOver;

  String get category => categoryId;

  ItemModel({
    required this.itemId,
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.status,
    required this.claimStatus,
    required this.imageUrl,
    required this.location,
    required this.datePosted,
    required this.authorName,
    this.moderationStatus = 'Approved',
    this.isFlagged = false,
    this.flagReason,
    this.lockerNumber,
    this.isHandedOver = false,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parsedDate = DateTime.now();
    if (map['datePosted'] != null) {
      if (map['datePosted'] is Timestamp) {
        parsedDate = (map['datePosted'] as Timestamp).toDate();
      } else if (map['datePosted'] is String) {
        parsedDate = DateTime.tryParse(map['datePosted']) ?? DateTime.now();
      }
    }

    return ItemModel(
      itemId: id,
      userId: map['userId'] ?? '',
      categoryId: map['categoryId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'Lost',
      claimStatus: map['claimStatus'] ?? 'Available',
      imageUrl: map['imageUrl'] ?? '',
      location: map['location'] ?? '',
      datePosted: parsedDate,
      authorName: map['authorName'] ?? '',
      moderationStatus: map['moderationStatus'] ?? 'Approved',
      isFlagged: map['isFlagged'] ?? false,
      flagReason: map['flagReason'],
      lockerNumber: map['lockerNumber'],
      isHandedOver: map['isHandedOver'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'categoryId': categoryId,
      'title': title,
      'description': description,
      'status': status,
      'claimStatus': claimStatus,
      'imageUrl': imageUrl,
      'location': location,
      'datePosted': datePosted.toIso8601String(),
      'authorName': authorName,
      'moderationStatus': moderationStatus,
      'isFlagged': isFlagged,
      'flagReason': flagReason,
      'lockerNumber': lockerNumber,
      'isHandedOver': isHandedOver,
    };
  }

  ItemModel copyWith({
    String? categoryId,
    String? title,
    String? description,
    String? status,
    String? claimStatus,
    String? imageUrl,
    String? location,
    DateTime? datePosted,
    String? authorName,
    String? moderationStatus,
    bool? isFlagged,
    String? flagReason,
    String? lockerNumber,
    bool? isHandedOver,
  }) {
    return ItemModel(
      itemId: itemId,
      userId: userId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      claimStatus: claimStatus ?? this.claimStatus,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      datePosted: datePosted ?? this.datePosted,
      authorName: authorName ?? this.authorName,
      moderationStatus: moderationStatus ?? this.moderationStatus,
      isFlagged: isFlagged ?? this.isFlagged,
      flagReason: flagReason ?? this.flagReason,
      lockerNumber: lockerNumber ?? this.lockerNumber,
      isHandedOver: isHandedOver ?? this.isHandedOver,
    );
  }
}
