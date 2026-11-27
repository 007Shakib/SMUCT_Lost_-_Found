import 'package:cloud_firestore/cloud_firestore.dart';

/// Notification Model
class NotificationModel {
  final String notificationId;
  final String userId;
  final String message;
  final String type; // 'claim_update', 'claim_approved', 'claim_rejected', 'claim_info_requested', 'post_moderation', 'system'
  final DateTime timestamp;
  bool readStatus;
  final String? claimId;
  final String? itemId;

  String? _customTitle;
  String? _customBody;

  String get id => notificationId;
  String get title => _customTitle ?? (type.startsWith('claim') ? 'Claim Update' : 'System Alert');
  String get body => _customBody ?? message;
  bool get isRead => readStatus;
  set isRead(bool val) => readStatus = val;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.message,
    required this.type,
    required this.timestamp,
    this.readStatus = false,
    this.claimId,
    this.itemId,
    String? id,
    String? title,
    String? body,
    bool? isRead,
  }) : _customTitle = title,
       _customBody = body {
    if (isRead != null) readStatus = isRead;
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parsedTime = DateTime.now();
    if (map['timestamp'] != null) {
      if (map['timestamp'] is Timestamp) {
        parsedTime = (map['timestamp'] as Timestamp).toDate();
      } else if (map['timestamp'] is String) {
        parsedTime = DateTime.tryParse(map['timestamp']) ?? DateTime.now();
      }
    }

    return NotificationModel(
      notificationId: id,
      userId: map['userId'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'system',
      timestamp: parsedTime,
      readStatus: map['readStatus'] ?? map['isRead'] ?? false,
      claimId: map['claimId'],
      itemId: map['itemId'],
      title: map['title'],
      body: map['body'] ?? map['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'message': message,
      'title': title,
      'body': body,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'readStatus': readStatus,
      'claimId': claimId,
      'itemId': itemId,
    };
  }
}
