import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../mock/mock_data.dart';
import '../../widgets/statistic_card.dart';

/// Platform Analytics & Statistics Dashboard
class PlatformStatsScreen extends StatelessWidget {
  const PlatformStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = MockData.adminStats;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Platform Statistics'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recovery Rate Highlight Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryNavy, AppTheme.cardSurface],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.accentCyan.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Campus Recovery Rate', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.bold)),
                        Icon(Icons.trending_up_rounded, color: AppTheme.statusFound, size: 24),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('83.1%', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const LinearProgressIndicator(
                        value: 0.831,
                        minHeight: 8,
                        backgroundColor: AppTheme.darkBackground,
                        color: AppTheme.statusFound,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('118 out of 142 submitted claims successfully reunited with owners.', style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Statistics Grid
              const Text('Detailed Analytics', style: TextStyle(color: AppTheme.textMain, fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.35,
                children: [
                  StatisticCard(title: 'Total Users', value: '${stats['totalUsers']}', icon: Icons.people_alt_rounded, accentColor: AppTheme.accentCyan),
                  StatisticCard(title: 'Lost Items', value: '${stats['lostItems']}', icon: Icons.search_off_rounded, accentColor: AppTheme.statusLost),
                  StatisticCard(title: 'Found Items', value: '${stats['foundItems']}', icon: Icons.check_circle_rounded, accentColor: AppTheme.statusFound),
                  StatisticCard(title: 'Pending Claims', value: '${stats['pendingClaims']}', icon: Icons.hourglass_top_rounded, accentColor: AppTheme.statusPending),
                  StatisticCard(title: 'Approved Claims', value: '${stats['approvedClaims']}', icon: Icons.verified_user_rounded, accentColor: AppTheme.statusFound),
                  StatisticCard(title: 'Rejected Claims', value: '${stats['rejectedClaims']}', icon: Icons.cancel_rounded, accentColor: AppTheme.statusLost),
                ],
              ),
              const SizedBox(height: 24),

              // Visual Category Breakdown Bars
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.cardSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Listings by Category', style: TextStyle(color: AppTheme.textMain, fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildBarRow('Electronics', 0.42, '42%'),
                    _buildBarRow('Documents & IDs', 0.28, '28%'),
                    _buildBarRow('Bags & Wallets', 0.16, '16%'),
                    _buildBarRow('Keys & Accessories', 0.14, '14%'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarRow(String label, double ratio, String percent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Color(0xFF334155), fontSize: 12, fontWeight: FontWeight.w600)),
              Text(percent, style: const TextStyle(color: AppTheme.accentCyan, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: AppTheme.darkBackground,
              color: AppTheme.accentCyan,
            ),
          ),
        ],
      ),
    );
  }
}
