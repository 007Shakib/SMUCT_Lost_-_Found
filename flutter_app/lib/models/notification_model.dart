/// Notification Model
class NotificationModel {
  final String notificationId;
  final String userId;
  final String message;
  final String type; // 'claim_update', 'post_moderation', 'system'
  final DateTime timestamp;
  bool readStatus;

  String? _customTitle;
  String? _customBody;

  String get id => notificationId;
  String get title => _customTitle ?? (type == 'claim_update' ? 'Claim Update' : 'System Alert');
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
    String? id,
    String? title,
    String? body,
    bool? isRead,
  }) : _customTitle = title,
       _customBody = body {
    if (isRead != null) readStatus = isRead;
  }

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
