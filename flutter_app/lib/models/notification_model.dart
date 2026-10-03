/// Notification Model (ER Diagram: Notification Entity / UC-09, FR-09)
class NotificationModel {
  final String notificationId;
  final String userId;
  final String message;
  final String type; // 'claim_update', 'post_moderation', 'system'
  final DateTime timestamp;
  final bool readStatus;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.message,
    required this.type,
    required this.timestamp,
    this.readStatus = false,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      notificationId: id,
      userId: map['userId'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'system',
      timestamp: (map['timestamp'] != null)
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      readStatus: map['readStatus'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'message': message,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'readStatus': readStatus,
    };
  }
}
