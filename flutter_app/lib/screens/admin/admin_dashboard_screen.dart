import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../mock/mock_data.dart';
import '../../services/admin_service.dart';

/// Admin Dashboard Screen conforming strictly to SMUCT Admin Console Figma Design
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  final AdminService _adminService = AdminService.instance;
  int _selectedTabIndex = 0; // 0: Dashboard, 1: Posts, 2: Claims, 3: Users
  int _bottomNavIndex = 0; // 0: Home, 1: Search, 2: Report, 3: My Posts, 4: Profile

  @override
  void initState() {
    super.initState();
    _adminService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _adminService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  // Handle Quick Approve
  void _handleApprove(Map<String, dynamic> claim) async {
    final success = await _adminService.approveClaim(claim['id']);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: const Color(0xFF10B981),
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Claim for "${claim['title']}" APPROVED. Notification sent to ${claim['claimantName'].toString().split(' ')[0]}.',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Handle Detailed Review Modal
  void _showReviewModal(Map<String, dynamic> claim) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.verified_user_rounded, color: Color(0xFF0284C7), size: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Claim Adjudication',
                        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'HIGH PRIORITY',
                      style: GoogleFonts.outfit(color: const Color(0xFFEF4444), fontSize: 10, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Item thumbnail & title banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        claim['imageUrl'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 60,
                          height: 60,
                          color: const Color(0xFFE2E8F0),
                          child: const Icon(Icons.image_not_supported_rounded, color: Color(0xFF94A3B8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            claim['title'],
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF0284C7)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  claim['location'],
                                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Claimant Identity Verification Card
              Text(
                'CLAIMANT IDENTITY',
                style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF64748B), letterSpacing: 0.6),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFFE0F2FE),
                          child: Icon(Icons.person, color: Color(0xFF0284C7), size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                claim['claimantName'],
                                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                              ),
                              Text(
                                claim['department'] ?? 'SMUCT Student Registry',
                                style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Active Student',
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF10B981)),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 18, color: Color(0xFFF1F5F9)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Contact Phone:', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                        Text(claim['phone'] ?? '+880 1712-000000', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Ownership Justification / Proof
              Text(
                'OWNERSHIP PROOF STATEMENT',
                style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF64748B), letterSpacing: 0.6),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Text(
                  claim['proof'] ?? 'No additional proof text provided.',
                  style: GoogleFonts.inter(fontSize: 13, height: 1.45, color: const Color(0xFF334155)),
                ),
              ),
              const SizedBox(height: 22),

              // Action Buttons: Approve / Reject
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEF4444),
                        side: const BorderSide(color: Color(0xFFEF4444)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await _adminService.rejectClaim(claim['id'], reason: 'Unverified proof details');
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Claim rejected and student notified.')),
                          );
                        }
                      },
                      child: Text('Reject Claim', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00E5D9), Color(0xFF38EF7D)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(color: Color(0x3300E5D9), blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: const Color(0xFF0F172A),
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _handleApprove(claim);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF0F172A)),
                            const SizedBox(width: 6),
                            Text('Approve Claim', style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 13, color: const Color(0xFF0F172A))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Handle Flag Inspection Modal
  void _showInspectModal(Map<String, dynamic> flag) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.flag_rounded, color: Color(0xFFEF4444), size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    flag['title'],
                    style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              flag['subtitle'],
              style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF0284C7)),
                      const SizedBox(width: 6),
                      Text('System Moderation Report', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    flag['details'] ?? 'Item flagged by automated campus integrity guidelines.',
                    style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569), height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await _adminService.dismissFlag(flag['id']);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Flag dismissed. Post kept active.')),
                        );
                      }
                    },
                    child: Text('Dismiss Flag', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await _adminService.removeFlaggedPost(flag['id']);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Listing removed from campus feed.')),
                        );
                      }
                    },
                    child: Text('Remove Listing', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Handle Physical Desk Handover Modal
  void _showHandoverModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF0D9488), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Physical Desk Handover',
                        style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                      ),
                      Text(
                        'Scan Student QR / Verify Campus Safe ID',
                        style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Scanner Viewfinder Mockup
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF00E5D9), width: 1.5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.qr_code_2_rounded, size: 90, color: Color(0x33FFFFFF)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5D9).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF00E5D9)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.document_scanner_rounded, size: 14, color: Color(0xFF00E5D9)),
                            const SizedBox(width: 6),
                            Text('Scanning Active...', style: GoogleFonts.outfit(color: const Color(0xFF00E5D9), fontSize: 11, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Align student phone QR code in frame',
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Demo Quick Trigger Button
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Locker Bay #14 • Ready for Handover', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13, color: const Color(0xFF0F172A))),
                        Text('AirPods Pro Gen 2 • Claim #7721 verified', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF00E5D9), Color(0xFF38EF7D)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await _adminService.completeDeskHandover(
                      studentId: 'CS-22-09',
                      lockerNumber: 'Locker #14',
                      itemName: 'AirPods Pro Gen 2',
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color(0xFF10B981),
                          content: Text('Item successfully marked as Handed Over to student!'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.check_rounded, color: Color(0xFF0F172A)),
                  label: Text(
                    'Complete Desk Handover & Release',
                    style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar: SMUCT L&F / Home + Bell & Avatar
                    _buildTopHeader(),
                    const SizedBox(height: 14),

                    // Admin Console Card with Live Indicator & Super Admin Badge
                    _buildAdminConsoleCard(),
                    const SizedBox(height: 14),

                    // Horizontal Navigation Pills: Dashboard, Posts, Claims, Users
                    _buildHorizontalTabs(),
                    const SizedBox(height: 18),

                    // Content based on selected tab
                    if (_selectedTabIndex == 0) ...[
                      // 2x2 Metric Cards Grid
                      _buildMetricCardsGrid(),
                      const SizedBox(height: 18),

                      // Category Split Section
                      _buildCategorySplitCard(),
                      const SizedBox(height: 20),

                      // Claim Approvals Section (3 HIGH PRIORITY)
                      _buildClaimApprovalsSection(),
                      const SizedBox(height: 20),

                      // Flagged Moderation Section
                      _buildFlaggedModerationSection(),
                      const SizedBox(height: 20),

                      // Physical Desk Handover Card
                      _buildPhysicalDeskHandoverCard(),
                      const SizedBox(height: 24),
                    ] else if (_selectedTabIndex == 1) ...[
                      _buildPostsTabContent(),
                    ] else if (_selectedTabIndex == 2) ...[
                      _buildClaimsTabContent(),
                    ] else ...[
                      _buildUsersTabContent(),
                    ],
                  ],
                ),
              ),
            ),

            // Persistent Floating Bottom Navigation matching screenshot
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  // 1. Top Bar
  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SMUCT L&F',
              style: GoogleFonts.outfit(
                color: const Color(0xFF0284C7),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
            Text(
              'Home',
              style: GoogleFonts.outfit(
                color: const Color(0xFF0F172A),
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Notification Bell with unread badge dot
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/notifications'),
                  icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF0F172A), size: 24),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),

            // Profile Avatar with SMUCT Crest
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF0F2B5C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
                  boxShadow: const [
                    BoxShadow(color: Color(0x220284C7), blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shield_rounded, size: 16, color: Colors.white),
                      Text(
                        'L&F',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2. Admin Console Card
  Widget _buildAdminConsoleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF7DD3FC), width: 1.2),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield_rounded, size: 18, color: Color(0xFF0284C7)),
                  Text(
                    'L & F',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF0369A1),
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title & Live Grid
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Admin Console',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'CAMPUS GRID',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF64748B),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.show_chart_rounded, size: 13, color: Color(0xFF10B981)),
                    const SizedBox(width: 2),
                    Text(
                      'Live',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Super Admin Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_user_rounded, size: 13, color: Color(0xFF0284C7)),
                const SizedBox(width: 4),
                Text(
                  'Super Admin',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF0284C7),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Horizontal Navigation Tabs
  Widget _buildHorizontalTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTabPill(
            index: 0,
            icon: Icons.space_dashboard_rounded,
            label: 'Dashboard',
            isActive: _selectedTabIndex == 0,
          ),
          const SizedBox(width: 10),
          _buildTabPill(
            index: 1,
            icon: Icons.tune_rounded,
            label: 'Posts',
            isActive: _selectedTabIndex == 1,
          ),
          const SizedBox(width: 10),
          _buildTabPill(
            index: 2,
            icon: Icons.assignment_outlined,
            label: 'Claims',
            isActive: _selectedTabIndex == 2,
            hasRedDot: true,
          ),
          const SizedBox(width: 10),
          _buildTabPill(
            index: 3,
            icon: Icons.people_alt_outlined,
            label: 'Users',
            isActive: _selectedTabIndex == 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTabPill({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
    bool hasRedDot = false,
  }) {
    return InkWell(
      onTap: () => setState(() => _selectedTabIndex = index),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? null : Colors.white,
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF00E5D9), Color(0xFF2DD4BF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          borderRadius: BorderRadius.circular(25),
          border: isActive ? null : Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: isActive
              ? const [
                  BoxShadow(color: Color(0x3300E5D9), blurRadius: 10, offset: Offset(0, 3)),
                ]
              : const [
                  BoxShadow(color: Color(0x04000000), blurRadius: 4, offset: Offset(0, 2)),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? const Color(0xFF0F172A) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: isActive ? const Color(0xFF0F172A) : const Color(0xFF334155),
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
              ),
            ),
            if (hasRedDot) ...[
              const SizedBox(width: 5),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 4. Metric Cards 2x2 Grid
  Widget _buildMetricCardsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.25,
      children: [
        // Card 1: 142 Active Posts
        _buildStatCard(
          icon: Icons.calendar_month_outlined,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF0284C7),
          badgeWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.trending_up_rounded, size: 12, color: Color(0xFF10B981)),
                const SizedBox(width: 2),
                Text('+12', style: GoogleFonts.outfit(color: const Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          value: '${_adminService.activePostsCount}',
          label: 'Active Posts',
          onTap: () => setState(() => _selectedTabIndex = 1),
        ),

        // Card 2: 8 Pending Claims
        _buildStatCard(
          icon: Icons.assignment_late_outlined,
          iconBg: const Color(0xFFFEE2E2),
          iconColor: const Color(0xFFEF4444),
          badgeWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Needs Review',
              style: GoogleFonts.outfit(color: const Color(0xFFEF4444), fontSize: 10, fontWeight: FontWeight.w800),
            ),
          ),
          value: '${_adminService.pendingClaimsCount}',
          label: 'Pending Claims',
          onTap: () => setState(() => _selectedTabIndex = 2),
        ),

        // Card 3: 389 Resolved Items
        _buildStatCard(
          icon: Icons.check_circle_outline_rounded,
          iconBg: const Color(0xFFDCFCE7),
          iconColor: const Color(0xFF10B981),
          badgeWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '94% Rate',
              style: GoogleFonts.outfit(color: const Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.w800),
            ),
          ),
          value: '${_adminService.resolvedItemsCount}',
          label: 'Resolved Items',
          onTap: () => Navigator.pushNamed(context, '/admin/stats'),
        ),

        // Card 4: 2,450 Registered Users
        _buildStatCard(
          icon: Icons.badge_outlined,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF0284C7),
          badgeWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'SMUCT ID',
              style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontSize: 10, fontWeight: FontWeight.w800),
            ),
          ),
          value: '2,450',
          label: 'Registered Users',
          onTap: () => setState(() => _selectedTabIndex = 3),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required Widget badgeWidget,
    required String value,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                badgeWidget,
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 5. Category Split Card
  Widget _buildCategorySplitCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.public_rounded, size: 16, color: Color(0xFF0284C7)),
                  const SizedBox(width: 8),
                  Text(
                    'Category Split',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Text(
                '142 Reported',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0284C7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Multi-segment progress bar matching screenshot
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: const SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(flex: 45, child: ColoredBox(color: Color(0xFF00D2FF))),
                  SizedBox(width: 2),
                  Expanded(flex: 25, child: ColoredBox(color: Color(0xFF38BDF8))),
                  SizedBox(width: 2),
                  Expanded(flex: 15, child: ColoredBox(color: Color(0xFF86EFAC))),
                  SizedBox(width: 2),
                  Expanded(flex: 15, child: ColoredBox(color: Color(0xFFBFDBFE))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2x2 Category Legend
          Row(
            children: [
              Expanded(child: _buildLegendItem(color: const Color(0xFF00D2FF), label: 'Electronics', percent: '45%')),
              const SizedBox(width: 14),
              Expanded(child: _buildLegendItem(color: const Color(0xFF38BDF8), label: 'Cards & IDs', percent: '25%')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildLegendItem(color: const Color(0xFF86EFAC), label: 'Keys', percent: '15%')),
              const SizedBox(width: 14),
              Expanded(child: _buildLegendItem(color: const Color(0xFFBFDBFE), label: 'Bags', percent: '15%')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label, required String percent}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF475569), fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Text(
          percent,
          style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
        ),
      ],
    );
  }

  // 6. Claim Approvals Section
  Widget _buildClaimApprovalsSection() {
    final claims = _adminService.claimApprovals.where((c) => c['status'] == 'Pending').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 16, color: Color(0xFF0284C7)),
                const SizedBox(width: 6),
                Text(
                  'Claim Approvals',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '3 HIGH PRIORITY',
                style: GoogleFonts.outfit(
                  color: const Color(0xFFEF4444),
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (claims.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Center(
              child: Text(
                'All high priority claims have been reviewed! 🎉',
                style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 12),
              ),
            ),
          )
        else
          ...claims.map((claim) => _buildClaimApprovalCard(claim)),
      ],
    );
  }

  Widget _buildClaimApprovalCard(Map<String, dynamic> claim) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  claim['imageUrl'],
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 52,
                    height: 52,
                    color: const Color(0xFFE2E8F0),
                    child: const Icon(Icons.devices_other_rounded, color: Color(0xFF94A3B8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            claim['title'],
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          claim['timeAgo'],
                          style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded, size: 12, color: Color(0xFF0284C7)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            claim['claimantName'],
                            style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF0284C7)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            claim['location'],
                            style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Two Action Buttons side-by-side
          Row(
            children: [
              // Approve Button (Green Gradient)
              Expanded(
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00E5D9), Color(0xFF38EF7D)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Color(0x3300E5D9), blurRadius: 6, offset: Offset(0, 2)),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => _handleApprove(claim),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_rounded, size: 16, color: Color(0xFF0F172A)),
                        const SizedBox(width: 4),
                        Text(
                          'Approve',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Review Button (Soft Purple/Blue)
              Expanded(
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => _showReviewModal(claim),
                    icon: const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF4F46E5)),
                    label: Text(
                      'Review',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: const Color(0xFF4F46E5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 7. Flagged Moderation Section
  Widget _buildFlaggedModerationSection() {
    final flags = _adminService.flaggedItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.flag_outlined, size: 16, color: Color(0xFFEF4444)),
                const SizedBox(width: 6),
                Text(
                  'Flagged Moderation',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            Text(
              '${flags.length} New',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0284C7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (flags.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Center(
              child: Text('No flagged items currently.', style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 12)),
            ),
          )
        else
          ...flags.map((flag) => _buildFlaggedCard(flag)),
      ],
    );
  }

  Widget _buildFlaggedCard(Map<String, dynamic> flag) {
    final isDuplicate = flag['type'] == 'duplicate';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDuplicate ? const Color(0xFFFEE2E2) : const Color(0xFFFFEDD5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isDuplicate ? Icons.warning_amber_rounded : Icons.hide_image_outlined,
              size: 20,
              color: isDuplicate ? const Color(0xFFEF4444) : const Color(0xFFF97316),
            ),
          ),
          const SizedBox(width: 12),

          // Titles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flag['title'],
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  flag['subtitle'],
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Inspect Button
          InkWell(
            onTap: () => _showInspectModal(flag),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Inspect',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF4F46E5),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 9, color: Color(0xFF4F46E5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 8. Physical Desk Handover Card
  Widget _buildPhysicalDeskHandoverCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F7FA), Color(0xFFE8F5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBAE6FD)),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBAE6FD)),
            ),
            child: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF0284C7), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Physical Desk Handover',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Scan QR on locker or student phone',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Camera circular action button
          GestureDetector(
            onTap: _showHandoverModal,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF0D9488),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Color(0x330D9488), blurRadius: 8, offset: Offset(0, 3)),
                ],
              ),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // 9. Floating Bottom Navigation Bar matching screenshot
  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home Tab (Active)
          _buildBottomNavItem(
            index: 0,
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
            onTap: () => setState(() => _selectedTabIndex = 0),
          ),

          // Search
          _buildBottomNavItem(
            index: 1,
            icon: Icons.search_outlined,
            activeIcon: Icons.search_rounded,
            label: 'Search',
            onTap: () => Navigator.pushNamed(context, '/search-filter'),
          ),

          // Floating Center (+) Button
          GestureDetector(
            onTap: _showAdminQuickActionSheet,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00D2FF), Color(0xFF38EF7D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x4400D2FF),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.black, size: 26),
                ),
              ],
            ),
          ),

          // My Posts / Moderation
          _buildBottomNavItem(
            index: 3,
            icon: Icons.grid_view_outlined,
            activeIcon: Icons.grid_view_rounded,
            label: 'My Posts',
            onTap: () => setState(() => _selectedTabIndex = 1),
          ),

          // Profile
          _buildBottomNavItem(
            index: 4,
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: 'Profile',
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = (_bottomNavIndex == index && _selectedTabIndex == 0);

    return InkWell(
      onTap: () {
        setState(() => _bottomNavIndex = index);
        onTap();
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF94A3B8),
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF94A3B8),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Admin Quick Action Modal on (+) button
  void _showAdminQuickActionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Campus Admin Quick Actions', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFFE0F7FA), child: Icon(Icons.qr_code_scanner, color: Color(0xFF0D9488))),
              title: Text('Desk QR Handover', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
              subtitle: const Text('Scan & release verified items to student'),
              onTap: () {
                Navigator.pop(ctx);
                _showHandoverModal();
              },
            ),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFFEFF6FF), child: Icon(Icons.add_box_rounded, color: Color(0xFF0284C7))),
              title: Text('Add Found Item from Desk', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
              subtitle: const Text('Directly log items handed in to Security Desk'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, '/report-item', arguments: 'Found');
              },
            ),
            ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFFFEE2E2), child: Icon(Icons.campaign_rounded, color: Color(0xFFEF4444))),
              title: Text('Broadcast Campus Notice', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
              subtitle: const Text('Send high-priority alert to all students'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notice broadcast sent to campus students.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Tab 1 Subview: Posts Moderation
  Widget _buildPostsTabContent() {
    final posts = MockData.items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Campus Posts Moderation', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800)),
            Text('${posts.length} Active', style: GoogleFonts.inter(color: const Color(0xFF0284C7), fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 12),
        ...posts.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 50, height: 50, color: const Color(0xFFE2E8F0)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13), maxLines: 1),
                        Text('By ${item.authorName} • ${item.location}', style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                    onPressed: () async {
                      await _adminService.removePost(item.itemId, 'Moderated');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post "${item.title}" removed.')));
                      }
                    },
                  ),
                ],
              ),
            )),
      ],
    );
  }

  // Tab 2 Subview: Claims Queue
  Widget _buildClaimsTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('All Claim Requests', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800)),
            Text('${_adminService.pendingClaimsCount} Pending', style: GoogleFonts.inter(color: const Color(0xFFEF4444), fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 12),
        ..._adminService.claimApprovals.map((claim) => _buildClaimApprovalCard(claim)),
      ],
    );
  }

  // Tab 3 Subview: Users Management
  Widget _buildUsersTabContent() {
    final users = _adminService.users;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Campus Registered Users', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800)),
            Text('${users.length} Users', style: GoogleFonts.inter(color: const Color(0xFF0284C7), fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 12),
        ...users.map((user) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFE0F2FE),
                    child: Text(user.name.isNotEmpty ? user.name[0] : 'U', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF0284C7))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13)),
                        Text('${user.role} • ${user.email}', style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: user.isSuspended ? const Color(0xFFFEE2E2) : const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      user.isSuspended ? 'Suspended' : 'Active',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: user.isSuspended ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
