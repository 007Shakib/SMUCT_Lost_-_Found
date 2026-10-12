import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../mock/mock_data.dart';
import '../../widgets/empty_state.dart';

/// Notifications Inbox Screen
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  void _markAllAsRead() {
    setState(() {
      for (var n in MockData.notifications) {
        n.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifications = MockData.notifications;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        actions: [
          if (notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: _markAllAsRead,
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
                              color: Colors.white,
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
                            color: notif.isRead ? const Color(0xFF94A3B8) : const Color(0xFFCBD5E1),
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() => notif.isRead = true);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
