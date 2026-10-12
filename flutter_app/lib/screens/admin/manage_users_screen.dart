import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../mock/mock_data.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/status_badge.dart';

/// Admin User Management Screen
class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  String _searchQuery = '';

  List<UserModel> get _filteredUsers {
    return MockData.users.where((u) {
      return u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.role.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _showUserActionDialog(UserModel user, String action) {
    final isSuspend = action == 'Suspend';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('$action User?', style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to $action "${user.name}" (${user.email})?',
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSuspend ? AppTheme.statusPending : AppTheme.statusLost,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User "${user.name}" $action action processed.')),
              );
            },
            child: Text(action),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final users = _filteredUsers;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CustomSearchBar(
                hintText: 'Search by name, email, role...',
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (ctx, idx) {
                    final user = users[idx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderSubtle),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundImage: NetworkImage(user.avatarUrl ?? ''),
                                backgroundColor: AppTheme.primaryNavy,
                                child: user.avatarUrl == null
                                    ? Text(user.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(color: AppTheme.textMain, fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      user.email,
                                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              StatusBadge(status: user.role == 'Admin' ? 'CLAIMED' : 'AVAILABLE', isSmall: true),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                user.department ?? 'Faculty Member',
                                style: const TextStyle(color: AppTheme.accentCyan, fontSize: 11),
                              ),
                              Row(
                                children: [
                                  OutlinedButton(
                                    onPressed: () => _showUserActionDialog(user, 'Suspend'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppTheme.statusPending,
                                      side: BorderSide(color: AppTheme.statusPending.withValues(alpha: 0.5)),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                      minimumSize: Size.zero,
                                    ),
                                    child: const Text('Suspend', style: TextStyle(fontSize: 11)),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton(
                                    onPressed: () => _showUserActionDialog(user, 'Delete'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppTheme.statusLost,
                                      side: BorderSide(color: AppTheme.statusLost.withValues(alpha: 0.5)),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                      minimumSize: Size.zero,
                                    ),
                                    child: const Text('Delete', style: TextStyle(fontSize: 11)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
