import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../config/firebase_config.dart';
import '../models/notification_model.dart';
import 'auth_service.dart';

/// Firebase Cloud Messaging (FCM) & Firestore In-App Notification Service (SRS Section 4 & 5)
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  FirebaseFirestore get _firestore => FirebaseConfig.isInitialized ? FirebaseConfig.firestore : FirebaseFirestore.instance;
  FirebaseMessaging get _fcm => FirebaseMessaging.instance;

  bool _initialized = false;
  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize FCM token and foreground message listener
  Future<void> initialize() async {
    if (_initialized) return;
    if (!FirebaseConfig.isInitialized) {
      await FirebaseConfig.initialize();
    }
    _initialized = true;

    // FCM web push requires custom service worker and VAPID key; safely skip on web
    if (kIsWeb) {
      debugPrint('NotificationService: Web push registration skipped.');
      return;
    }

    try {
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      debugPrint('FCM Notification permission status: ${settings.authorizationStatus}');

      _fcmToken = await _fcm.getToken();
      debugPrint('FCM Device Token: $_fcmToken');

      // If user is already logged in, persist token to their profile in Firestore
      final uid = AuthService().currentUser?.userId ?? AuthService().currentFirebaseUser?.uid;
      if (uid != null && _fcmToken != null) {
        await saveDeviceToken(uid, _fcmToken!);
      }

      // Listen for foreground notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('FCM Foreground Notification Received: ${message.notification?.title}');
      });

      // Listen for token refresh
      _fcm.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        final currentUid = AuthService().currentUser?.userId ?? AuthService().currentFirebaseUser?.uid;
        if (currentUid != null) {
          saveDeviceToken(currentUid, newToken);
        }
      });
    } catch (e) {
      debugPrint('NotificationService.initialize warning (continuing with in-app): $e');
    }
  }

  /// Store FCM device token in user's Firestore document
  Future<void> saveDeviceToken(String userId, String token) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'fcmToken': token,
        'tokenUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Failed to save device token in Firestore: $e');
    }
  }

  /// Real-time stream of notifications for a specific user from Cloud Firestore
  Stream<List<NotificationModel>> streamUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data(), doc.id);
      }).toList();
      // Sort newest first
      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    });
  }

  /// Send notification to a specific user (Created by Admin in Firestore + FCM)
  Future<void> sendNotification({
    required String recipientUserId,
    required String title,
    required String body,
    required String type,
    String? claimId,
    String? itemId,
  }) async {
    final notifId = 'notif_${DateTime.now().millisecondsSinceEpoch}_${recipientUserId.substring(0, recipientUserId.length > 5 ? 5 : recipientUserId.length)}';

    try {
      await _firestore.collection('notifications').doc(notifId).set({
        'notificationId': notifId,
        'userId': recipientUserId,
        'title': title,
        'body': body,
        'message': '$title: $body',
        'type': type,
        'timestamp': FieldValue.serverTimestamp(),
        'readStatus': false,
        'isRead': false,
        if (claimId != null) 'claimId': claimId,
        if (itemId != null) 'itemId': itemId,
      });
      debugPrint('Notification sent to user $recipientUserId: $title');
    } catch (e) {
      debugPrint('NotificationService.sendNotification error: $e');
    }
  }

  /// Mark specific notification as read in Firestore
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'readStatus': true,
        'isRead': true,
      });
    } catch (e) {
      debugPrint('Failed to mark notification as read: $e');
    }
  }

  /// Mark all notifications for current user as read
  Future<void> markAllAsRead(String userId) async {
    try {
      final query = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('readStatus', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (var doc in query.docs) {
        batch.update(doc.reference, {'readStatus': true, 'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Failed to mark all notifications as read: $e');
    }
  }
}
