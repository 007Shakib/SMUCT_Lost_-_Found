import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import '../../models/notification_model.dart';

/// Notification Center Screen (UC-09 / FR-09)
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService();

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications (UC-09)')),
      body: StreamBuilder<List<NotificationModel>>(
        stream: notificationService.streamUserNotifications('usr_student_01'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!;

          if (notifications.isEmpty) {
            return const Center(child: Text('No notifications yet.'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final n = notifications[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF0284C7).withOpacity(0.2),
                  child: const Icon(Icons.notifications_active, color: Color(0xFF0284C7)),
                ),
                title: Text(n.message),
                subtitle: Text(n.timestamp.toString().split('.')[0]),
                trailing: n.readStatus
                    ? null
                    : const Icon(Icons.circle, color: Colors.cyan, size: 12),
              );
            },
          );
        },
      ),
    );
  }
}
