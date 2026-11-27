import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/admin_service.dart';
import '../../widgets/statistic_card.dart';

/// Platform Analytics & Statistics Dashboard (SRS Requirement 1 & 5)
/// Real-time metrics streaming from Cloud Firestore
class PlatformStatsScreen extends StatelessWidget {
  const PlatformStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminService = AdminService.instance;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: Text('Platform Statistics', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: adminService,
          builder: (context, _) {
            final totalUsers = adminService.registeredUsersCount;
            final activePosts = adminService.activePostsCount;
            final pendingClaims = adminService.pendingClaimsCount;
            final resolvedClaims = adminService.resolvedItemsCount;
            final recoveryRate = adminService.recoveryRate;
            final split = adminService.categorySplit;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recovery Rate Highlight Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Campus Recovery Rate',
                              style: GoogleFonts.outfit(color: const Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const Icon(Icons.trending_up_rounded, color: Color(0xFF10B981), size: 24),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          recoveryRate,
                          style: GoogleFonts.outfit(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: (double.tryParse(recoveryRate.replaceAll('%', '')) ?? 85.0) / 100,
                            minHeight: 8,
                            backgroundColor: const Color(0xFF334155),
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$resolvedClaims resolved out of ${resolvedClaims + activePosts} total campus reports.',
                          style: GoogleFonts.inter(color: const Color(0xFFCBD5E1), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Statistics Grid
                  Text('Detailed Platform Analytics', style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.35,
                    children: [
                      StatisticCard(title: 'Total Users', value: '$totalUsers', icon: Icons.people_alt_rounded, accentColor: const Color(0xFF0284C7)),
                      StatisticCard(title: 'Active Posts', value: '$activePosts', icon: Icons.calendar_month_outlined, accentColor: const Color(0xFF0284C7)),
                      StatisticCard(title: 'Pending Claims', value: '$pendingClaims', icon: Icons.hourglass_top_rounded, accentColor: const Color(0xFFF59E0B)),
                      StatisticCard(title: 'Resolved Items', value: '$resolvedClaims', icon: Icons.verified_user_rounded, accentColor: const Color(0xFF10B981)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Visual Category Breakdown Bars
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Listings by Category (Live)', style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        ...split.entries.map((entry) {
                          final pct = (entry.value / 100).clamp(0.0, 1.0);
                          return _buildBarRow(entry.key, pct, '${entry.value}%');
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
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
              Text(label, style: GoogleFonts.inter(color: const Color(0xFF334155), fontSize: 12, fontWeight: FontWeight.w600)),
              Text(percent, style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: const Color(0xFFE2E8F0),
              color: const Color(0xFF0284C7),
            ),
          ),
        ],
      ),
    );
  }
}
