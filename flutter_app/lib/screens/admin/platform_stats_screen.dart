import 'package:flutter/material.dart';
import '../../services/admin_service.dart';

/// Platform Statistics & Analytics Screen (UC-13 / FR-13)
class PlatformStatsScreen extends StatelessWidget {
  const PlatformStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminService = AdminService();

    return Scaffold(
      appBar: AppBar(title: const Text('Platform Statistics (UC-13)')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: adminService.fetchPlatformStatistics(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard('Total Registered Users', '${stats['totalUsers']}', Icons.people, Colors.blue),
                _buildStatCard('Active Item Listings', '${stats['activeListings']}', Icons.inventory_2, Colors.amber),
                _buildStatCard('Pending Claims', '${stats['pendingClaims']}', Icons.hourglass_top, Colors.orange),
                _buildStatCard('Resolved Claims', '${stats['resolvedClaims']}', Icons.check_circle, Colors.green),
                _buildStatCard('Recovery Rate', '${stats['recoveryRate']}', Icons.trending_up, Colors.purple),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
