import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../models/user_model.dart';

/// Manage Users Screen (UC-10 / FR-10)
class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final _adminService = AdminService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users (UC-10 / FR-10)')),
      body: FutureBuilder<List<UserModel>>(
        future: _adminService.fetchRegisteredUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(child: Text(user.name[0])),
                  title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${user.email} • Role: ${user.role}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'suspend') {
                        _adminService.toggleUserSuspension(user.userId, true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Account for ${user.name} suspended (UC-10).')),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'suspend',
                        child: Text('Suspend Account'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete Account', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
