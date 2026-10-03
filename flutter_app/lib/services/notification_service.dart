import 'dart:async';
import '../models/notification_model.dart';

/// Firebase Cloud Messaging (FCM) Notification Service (UC-09, FR-09)
class NotificationService {
  final List<NotificationModel> _mockNotifications = [
    NotificationModel(
      notificationId: 'notif_01',
      userId: 'usr_student_01',
      message: 'Your claim for "Apple AirPods Pro Case" has been received and is pending administrator review.',
      type: 'claim_update',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      notificationId: 'notif_02',
      userId: 'usr_student_01',
      message: 'Claim request #CLM-402 was approved by Administrator.',
      type: 'claim_update',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      readStatus: true,
    ),
  ];

  /// Get user notification stream
  Stream<List<NotificationModel>> streamUserNotifications(String userId) async* {
    yield _mockNotifications.where((n) => n.userId == userId).toList();
  }

  /// Send FCM push notification (Triggered on UC-12 Claim Approval/Rejection)
  Future<void> sendPushNotification({
    required String recipientUserId,
    required String title,
    required String body,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockNotifications.insert(
      0,
      NotificationModel(
        notificationId: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        userId: recipientUserId,
        message: '$title: $body',
        type: 'claim_update',
        timestamp: DateTime.now(),
      ),
    );
  }
}
