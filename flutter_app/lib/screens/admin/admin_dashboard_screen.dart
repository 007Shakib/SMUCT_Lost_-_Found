import 'package:flutter/material.dart';

/// Admin Dashboard Screen (Navigation Hub for Administrator Use Cases)
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Administrator Oversight Portal',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Manage university platform users, listings, claims, and statistics.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          _buildAdminTile(
            context,
            title: 'UC-10: Manage User Accounts',
            subtitle: 'View registered users, suspend or revoke accounts (FR-10)',
            icon: Icons.people_alt_outlined,
            route: '/admin/users',
            color: Colors.blue,
          ),
          _buildAdminTile(
            context,
            title: 'UC-11: Moderate Posts',
            subtitle: 'Review reported lost & found posts, remove invalid items (FR-11)',
            icon: Icons.gavel_outlined,
            route: '/admin/posts',
            color: Colors.amber,
          ),
          _buildAdminTile(
            context,
            title: 'UC-12: Approve / Reject Claims',
            subtitle: 'Review ownership justifications and adjudicate claim requests (FR-12)',
            icon: Icons.fact_check_outlined,
            route: '/admin/claims',
            color: Colors.green,
          ),
          _buildAdminTile(
            context,
            title: 'UC-13: Platform Statistics',
            subtitle: 'View total users, active listings, recovery rate & analytics (FR-13)',
            icon: Icons.bar_chart_outlined,
            route: '/admin/stats',
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildAdminTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
