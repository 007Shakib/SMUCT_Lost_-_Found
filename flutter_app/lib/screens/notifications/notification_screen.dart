import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../mock/mock_data.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/empty_state.dart';

/// Notifications Inbox Screen (SRS Requirement 4 & 5)
/// Real-time live Firestore notifications stream
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    final currentUid = AuthService().currentUser?.userId ?? AuthService().currentFirebaseUser?.uid ?? 'usr_student_01';

    return StreamBuilder<List<NotificationModel>>(
      stream: _notificationService.streamUserNotifications(currentUid),
      builder: (context, snapshot) {
        final notifications = snapshot.data ?? MockData.notifications.where((n) => n.userId == currentUid).toList();

        return Scaffold(
          backgroundColor: AppTheme.darkBackground,
          appBar: AppBar(
            title: const Text('Notifications'),
            backgroundColor: Colors.transparent,
            actions: [
              if (notifications.any((n) => !n.isRead))
                TextButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await _notificationService.markAllAsRead(currentUid);
                    messenger.showSnackBar(
                      const SnackBar(content: Text('All notifications marked as read')),
                    );
                  },
                  child: const Text('Mark all read', style: TextStyle(color: AppTheme.accentCyan, fontSize: 12)),
                ),
            ],
          ),
          body: SafeArea(
            child: notifications.isEmpty
                ? const EmptyState(
                    icon: Icons.notifications_off_outlined,
                    title: "You're all caught up",
                    description: "There are no new notifications or updates at this time.",
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (ctx, idx) {
                      final notif = notifications[idx];
                      final formattedDate = DateFormat('MMM d, h:mm a').format(notif.timestamp);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: notif.isRead
                              ? AppTheme.cardSurface
                              : AppTheme.accentCyan.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: notif.isRead
                                ? AppTheme.borderSubtle
                                : AppTheme.accentCyan.withValues(alpha: 0.4),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(14),
                          leading: CircleAvatar(
                            backgroundColor: notif.isRead
                                ? AppTheme.primaryNavy
                                : AppTheme.accentCyan.withValues(alpha: 0.2),
                            child: Icon(
                              notif.title.contains('Approved')
                                  ? Icons.check_circle_outline_rounded
                                  : (notif.title.contains('Rejected')
                                      ? Icons.cancel_outlined
                                      : Icons.notifications_active_outlined),
                              color: notif.isRead ? Colors.white70 : AppTheme.accentCyan,
                              size: 20,
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                notif.title,
                                style: TextStyle(
                                  color: AppTheme.textMain,
                                  fontSize: 14,
                                  fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.bold,
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 10),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              notif.body,
                              style: TextStyle(
                                color: notif.isRead ? AppTheme.textMuted : const Color(0xFF334155),
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),
                          ),
                          onTap: () async {
                            await _notificationService.markNotificationAsRead(notif.notificationId);
                          },
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
