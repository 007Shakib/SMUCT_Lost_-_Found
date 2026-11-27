import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart';
import '../../models/item_model.dart';
import '../../models/claim_model.dart';
import '../../services/admin_service.dart';
import '../../services/auth_service.dart';
import '../../config/app_routes.dart';

/// Admin Dashboard Screen conforming strictly to SMUCT Admin Console Figma Design & SRS Requirements
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminService _adminService = AdminService.instance;
  int _selectedTabIndex = 0; // 0: Dashboard, 1: Posts, 2: Claims, 3: Users
  int _bottomNavIndex = 0;

  // Search filter for Users tab
  String _userSearchQuery = '';

  // Filter for Posts tab
  String _postFilter = 'All';

  // Filter for Claims tab
  String _claimFilter = 'Pending';

  @override
  void initState() {
    super.initState();
    _adminService.addListener(_onServiceUpdate);

    // Enforce role-based access control (SRS Requirement 5)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!AuthService().isAdmin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Access Denied: Administrator role required.'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    });
  }

  @override
  void dispose() {
    _adminService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  // ==========================================
  // ACTION HANDLERS
  // ==========================================

  void _handleApprove(ClaimModel claim) async {
    try {
      final success = await _adminService.approveClaim(claim.claimId);
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
                    'Claim for "${claim.itemTitle}" APPROVED. Item marked as Claimed & claimant notified.',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFEF4444),
            content: Text('Approval failed: $e'),
          ),
        );
      }
    }
  }

  void _showRequestInfoDialog(ClaimModel claim) {
    final noteCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Request Additional Info', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 17)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Specify what additional proof the claimant must provide. The claim will remain Pending.',
              style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteCtrl,
              maxLines: 3,
              style: GoogleFonts.inter(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'e.g. Please provide device serial number or purchase invoice photo...',
                hintStyle: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final prompt = noteCtrl.text.trim();
              if (prompt.isEmpty) return;
              Navigator.pop(ctx);
              await _adminService.requestAdditionalInformation(claim.claimId, prompt);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Color(0xFF0284C7),
                    content: Text('Request sent to claimant. Claim kept in Pending status.'),
                  ),
                );
              }
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  void _showRejectClaimDialog(ClaimModel claim) {
    final reasonCtrl = TextEditingController(text: 'Ownership proof insufficient to verify rightful owner.');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Reject Claim?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 17)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter rejection reason. The claimant will be notified immediately.',
              style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              maxLines: 3,
              style: GoogleFonts.inter(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Enter reason for rejection...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await _adminService.rejectClaim(claim.claimId, reason: reasonCtrl.text.trim());
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Color(0xFFEF4444),
                    content: Text('Claim rejected and student notified.'),
                  ),
                );
              }
            },
            child: const Text('Reject Claim'),
          ),
        ],
      ),
    );
  }

  void _showReviewModal(ClaimModel claim) {
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
                      'STATUS: ${claim.status.toUpperCase()}',
                      style: GoogleFonts.outfit(
                        color: claim.status == 'Approved'
                            ? const Color(0xFF10B981)
                            : (claim.status == 'Rejected' ? const Color(0xFFEF4444) : const Color(0xFFF59E0B)),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
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
                        claim.itemImageUrl ?? 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=600',
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
                            claim.itemTitle,
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF0284C7)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  claim.itemLocation ?? 'Campus Grounds',
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
                                claim.claimantName ?? 'Claimant (${claim.claimantId.substring(0, claim.claimantId.length > 8 ? 8 : claim.claimantId.length)})',
                                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                              ),
                              Text(
                                claim.claimantDepartment ?? 'SMUCT Student Registry',
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
                            claim.claimantStudentId ?? 'Student',
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
                        Text(
                          claim.claimantPhone ?? '+880 1712-000000',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
                        ),
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
                  claim.justification.isNotEmpty ? claim.justification : 'No additional proof text provided.',
                  style: GoogleFonts.inter(fontSize: 13, height: 1.45, color: const Color(0xFF334155)),
                ),
              ),
              if (claim.adminNotes != null && claim.adminNotes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFFB45309)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Admin Note: ${claim.adminNotes}',
                          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF92400E)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 22),

              // Three Action Buttons: Reject | Request Info | Approve
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEF4444),
                        side: const BorderSide(color: Color(0xFFEF4444)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showRejectClaimDialog(claim);
                      },
                      child: Text('Reject', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0284C7),
                        side: const BorderSide(color: Color(0xFF0284C7)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showRequestInfoDialog(claim);
                      },
                      child: Text('Ask Info', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00E5D9), Color(0xFF38EF7D)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: const Color(0xFF0F172A),
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _handleApprove(claim);
                        },
                        child: Text('Approve', style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 13)),
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

  void _showInspectModal(ItemModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
                decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.flag_rounded, color: Color(0xFFEF4444), size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.title,
                    style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Posted by ${item.authorName} • Location: ${item.location}',
              style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B)),
            ),
            const SizedBox(height: 12),
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
                  Text('Moderation / Report Note:', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(
                    item.flagReason ?? 'Item flagged by automated campus integrity guidelines or student report.',
                    style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await _adminService.dismissFlag(item.itemId);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Flag dismissed. Post approved.')),
                        );
                      }
                    },
                    child: const Text('Dismiss & Keep'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      _showConfirmRemovePostDialog(item);
                    },
                    child: const Text('Remove Post'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmRemovePostDialog(ItemModel item) {
    final reasonCtrl = TextEditingController(text: 'Inappropriate or invalid campus listing.');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove Listing?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to remove "${item.title}"? Author will be notified.'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              decoration: const InputDecoration(labelText: 'Removal Reason'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () async {
              Navigator.pop(ctx);
              await _adminService.removePost(item.itemId, reasonCtrl.text.trim());
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Listing removed from campus portal.')),
                );
              }
            },
            child: const Text('Confirm Remove'),
          ),
        ],
      ),
    );
  }

  void _showHandoverModal() {
    final studentIdCtrl = TextEditingController(text: 'CS-22-09');
    final lockerCtrl = TextEditingController(text: 'Locker #14');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
                decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFE0F7FA), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF0D9488), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Physical Desk Handover', style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                      Text('Verify student credentials and release item', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: studentIdCtrl,
              decoration: const InputDecoration(labelText: 'Student ID / Registration', prefixIcon: Icon(Icons.badge_outlined)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lockerCtrl,
              decoration: const InputDecoration(labelText: 'Desk Bay / Locker Number', prefixIcon: Icon(Icons.meeting_room_outlined)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () async {
                  Navigator.pop(ctx);
                  await _adminService.completeDeskHandover(
                    studentId: studentIdCtrl.text.trim(),
                    lockerNumber: lockerCtrl.text.trim(),
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Color(0xFF10B981),
                        content: Text('Physical desk handover completed & logged successfully!'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                label: Text('Complete Handover & Release', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // BUILD METHOD
  // ==========================================

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
                    _buildTopHeader(),
                    const SizedBox(height: 14),
                    _buildAdminConsoleCard(),
                    const SizedBox(height: 14),
                    _buildHorizontalTabs(),
                    const SizedBox(height: 18),

                    if (_selectedTabIndex == 0) ...[
                      _buildMetricCardsGrid(),
                      const SizedBox(height: 18),
                      _buildCategorySplitCard(),
                      const SizedBox(height: 20),
                      _buildClaimApprovalsSection(),
                      const SizedBox(height: 20),
                      _buildFlaggedModerationSection(),
                      const SizedBox(height: 20),
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
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  // 1. Top Header
  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SMUCT L&F',
              style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.6),
            ),
            Text(
              'Admin Portal',
              style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
              icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF0F172A), size: 24),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [Color(0xFF0284C7), Color(0xFF0F2B5C)]),
                  border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
                ),
                child: const Center(
                  child: Icon(Icons.shield_rounded, size: 18, color: Colors.white),
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
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF7DD3FC), width: 1.2),
            ),
            child: const Center(
              child: Icon(Icons.shield_rounded, size: 22, color: Color(0xFF0284C7)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Admin Console', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                    const SizedBox(width: 6),
                    Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text('CAMPUS GRID', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF64748B), letterSpacing: 0.6)),
                    const SizedBox(width: 6),
                    const Icon(Icons.show_chart_rounded, size: 13, color: Color(0xFF10B981)),
                    const SizedBox(width: 2),
                    Text('Firebase Live', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFF10B981))),
                  ],
                ),
              ],
            ),
          ),
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
                Text('Admin Role', style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontSize: 11, fontWeight: FontWeight.w700)),
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
          _buildTabPill(index: 0, icon: Icons.space_dashboard_rounded, label: 'Dashboard', isActive: _selectedTabIndex == 0),
          const SizedBox(width: 10),
          _buildTabPill(index: 1, icon: Icons.tune_rounded, label: 'Posts', isActive: _selectedTabIndex == 1),
          const SizedBox(width: 10),
          _buildTabPill(
            index: 2,
            icon: Icons.assignment_outlined,
            label: 'Claims',
            isActive: _selectedTabIndex == 2,
            hasRedDot: _adminService.pendingClaimsCount > 0,
          ),
          const SizedBox(width: 10),
          _buildTabPill(index: 3, icon: Icons.people_alt_outlined, label: 'Users', isActive: _selectedTabIndex == 3),
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
              ? const LinearGradient(colors: [Color(0xFF00E5D9), Color(0xFF2DD4BF)])
              : null,
          borderRadius: BorderRadius.circular(25),
          border: isActive ? null : Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isActive ? const Color(0xFF0F172A) : const Color(0xFF64748B)),
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
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
            ],
          ],
        ),
      ),
    );
  }

  // 4. Metric Cards 2x2 Grid (SRS Requirement 1)
  Widget _buildMetricCardsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.25,
      children: [
        // 1. Total Active Posts
        _buildStatCard(
          icon: Icons.calendar_month_outlined,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF0284C7),
          badgeText: 'Active',
          badgeColor: const Color(0xFF0284C7),
          badgeBg: const Color(0xFFE0F2FE),
          value: '${_adminService.activePostsCount}',
          label: 'Active Posts',
          onTap: () => setState(() => _selectedTabIndex = 1),
        ),

        // 2. Pending Claims
        _buildStatCard(
          icon: Icons.assignment_late_outlined,
          iconBg: const Color(0xFFFEE2E2),
          iconColor: const Color(0xFFEF4444),
          badgeText: '${_adminService.pendingClaimsCount} Review',
          badgeColor: const Color(0xFFEF4444),
          badgeBg: const Color(0xFFFEE2E2),
          value: '${_adminService.pendingClaimsCount}',
          label: 'Pending Claims',
          onTap: () => setState(() => _selectedTabIndex = 2),
        ),

        // 3. Resolved Items
        _buildStatCard(
          icon: Icons.check_circle_outline_rounded,
          iconBg: const Color(0xFFDCFCE7),
          iconColor: const Color(0xFF10B981),
          badgeText: _adminService.recoveryRate,
          badgeColor: const Color(0xFF10B981),
          badgeBg: const Color(0xFFDCFCE7),
          value: '${_adminService.resolvedItemsCount}',
          label: 'Resolved Items',
          onTap: () => Navigator.pushNamed(context, AppRoutes.platformStats),
        ),

        // 4. Registered Users
        _buildStatCard(
          icon: Icons.badge_outlined,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF0284C7),
          badgeText: 'SMUCT',
          badgeColor: const Color(0xFF0284C7),
          badgeBg: const Color(0xFFEFF6FF),
          value: '${_adminService.registeredUsersCount}',
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
    required String badgeText,
    required Color badgeColor,
    required Color badgeBg,
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
          boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 3))],
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
                  decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(12)),
                  child: Text(badgeText, style: GoogleFonts.outfit(color: badgeColor, fontSize: 10, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A), height: 1.1),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF64748B)),
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
    final split = _adminService.categorySplit;
    final totalReported = _adminService.activePostsCount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
                  Text('Category Split', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                ],
              ),
              Text('$totalReported Active Items', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF0284C7))),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(flex: split['Electronics'] ?? 40, child: const ColoredBox(color: Color(0xFF00D2FF))),
                  const SizedBox(width: 2),
                  Expanded(flex: split['Cards & IDs'] ?? 25, child: const ColoredBox(color: Color(0xFF38BDF8))),
                  const SizedBox(width: 2),
                  Expanded(flex: split['Keys'] ?? 15, child: const ColoredBox(color: Color(0xFF86EFAC))),
                  const SizedBox(width: 2),
                  Expanded(flex: split['Bags'] ?? 20, child: const ColoredBox(color: Color(0xFFBFDBFE))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildLegendItem(color: const Color(0xFF00D2FF), label: 'Electronics', percent: '${split['Electronics'] ?? 40}%')),
              const SizedBox(width: 14),
              Expanded(child: _buildLegendItem(color: const Color(0xFF38BDF8), label: 'Cards & IDs', percent: '${split['Cards & IDs'] ?? 25}%')),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildLegendItem(color: const Color(0xFF86EFAC), label: 'Keys', percent: '${split['Keys'] ?? 15}%')),
              const SizedBox(width: 14),
              Expanded(child: _buildLegendItem(color: const Color(0xFFBFDBFE), label: 'Bags & Other', percent: '${split['Bags'] ?? 20}%')),
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
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF475569), fontWeight: FontWeight.w500)),
          ],
        ),
        Text(percent, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
      ],
    );
  }

  // 6. Claim Approvals Section (Stream from Firestore)
  Widget _buildClaimApprovalsSection() {
    return StreamBuilder<List<ClaimModel>>(
      stream: _adminService.streamClaims(status: 'Pending'),
      builder: (context, snapshot) {
        final claims = snapshot.data ?? [];

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
                      style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => setState(() => _selectedTabIndex = 2),
                  child: Text('View All (${claims.length})', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF0284C7))),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (claims.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Center(
                  child: Text('No pending claim requests right now! 🎉', style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 12)),
                ),
              )
            else
              ...claims.take(3).map((claim) => _buildClaimCard(claim)),
          ],
        );
      },
    );
  }

  Widget _buildClaimCard(ClaimModel claim) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  claim.itemImageUrl ?? 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=600',
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            claim.itemTitle,
                            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          DateFormat('h:mm a').format(claim.dateSubmitted),
                          style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      claim.claimantName ?? 'Claimant ID: ${claim.claimantId.substring(0, claim.claimantId.length > 8 ? 8 : claim.claimantId.length)}',
                      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      claim.justification,
                      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF00E5D9), Color(0xFF38EF7D)]),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () => _handleApprove(claim),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_rounded, size: 16, color: Color(0xFF0F172A)),
                        const SizedBox(width: 4),
                        Text('Approve', style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 12, color: const Color(0xFF0F172A))),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(18)),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: () => _showReviewModal(claim),
                    icon: const Icon(Icons.visibility_outlined, size: 15, color: Color(0xFF4F46E5)),
                    label: Text('Review', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 12, color: const Color(0xFF4F46E5))),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 7. Flagged Moderation Section (Stream from Firestore)
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
                  style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                ),
              ],
            ),
            Text('${flags.length} Flagged', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF0284C7))),
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
              child: Text('No flagged or reported posts currently.', style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 12)),
            ),
          )
        else
          ...flags.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.warning_amber_rounded, size: 20, color: Color(0xFFEF4444)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w800), maxLines: 1),
                          Text('By ${item.authorName} • ${item.flagReason ?? "Needs Review"}', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B)), maxLines: 1),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showInspectModal(item),
                      child: const Text('Inspect'),
                    ),
                  ],
                ),
              )),
      ],
    );
  }

  // 8. Physical Desk Handover Card
  Widget _buildPhysicalDeskHandoverCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFE0F7FA), Color(0xFFE8F5E9)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFBAE6FD))),
            child: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF0284C7), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Physical Desk Handover', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                const SizedBox(height: 2),
                Text('Scan QR on student phone or log bay locker', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
              ],
            ),
          ),
          GestureDetector(
            onTap: _showHandoverModal,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF0D9488),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // 9. Floating Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 18, offset: Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(
            index: 0,
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Home',
            onTap: () => setState(() => _selectedTabIndex = 0),
          ),
          _buildBottomNavItem(
            index: 1,
            icon: Icons.search_outlined,
            activeIcon: Icons.search_rounded,
            label: 'Search',
            onTap: () => Navigator.pushNamed(context, AppRoutes.searchFilter),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.reportItem, arguments: 'Found'),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF00D2FF), Color(0xFF38EF7D)]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, color: Colors.black, size: 26),
            ),
          ),
          _buildBottomNavItem(
            index: 3,
            icon: Icons.analytics_outlined,
            activeIcon: Icons.analytics_rounded,
            label: 'Analytics',
            onTap: () => Navigator.pushNamed(context, AppRoutes.platformStats),
          ),
          _buildBottomNavItem(
            index: 4,
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: 'Profile',
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
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
            Icon(isSelected ? activeIcon : icon, color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF94A3B8), size: 22),
            const SizedBox(height: 2),
            Text(label, style: GoogleFonts.outfit(color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF94A3B8), fontSize: 10, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB SUBVIEWS
  // ==========================================

  // Tab 1: Posts Moderation
  Widget _buildPostsTabContent() {
    return StreamBuilder<List<ItemModel>>(
      stream: _adminService.streamAllPosts(filterStatus: _postFilter),
      builder: (context, snapshot) {
        final posts = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Campus Posts Moderation', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800)),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.moderatePosts),
                  child: Text('Dedicated View ➔', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF0284C7))),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Lost', 'Found', 'Pending', 'Removed'].map((cat) {
                  final isSel = _postFilter == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat, style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold)),
                      selected: isSel,
                      selectedColor: const Color(0xFF0284C7),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF475569)),
                      onSelected: (val) => setState(() => _postFilter = cat),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            if (posts.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Center(child: Text('No posts found for $_postFilter filter.')),
              )
            else
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
                              Row(
                                children: [
                                  Text(item.title, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13)),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: item.status == 'Lost' ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item.status.toUpperCase(),
                                      style: GoogleFonts.outfit(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: item.status == 'Lost' ? const Color(0xFFEF4444) : const Color(0xFF047857),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text('By ${item.authorName} • ${item.location}', style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                          onPressed: () => _showConfirmRemovePostDialog(item),
                        ),
                      ],
                    ),
                  )),
          ],
        );
      },
    );
  }

  // Tab 2: Claims Management
  Widget _buildClaimsTabContent() {
    return StreamBuilder<List<ClaimModel>>(
      stream: _adminService.streamClaims(status: _claimFilter),
      builder: (context, snapshot) {
        final claims = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('All Claims Queue', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800)),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.approveClaims),
                  child: Text('Dedicated View ➔', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF0284C7))),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Claims filter
            Row(
              children: ['All', 'Pending', 'Approved', 'Rejected'].map((status) {
                final isSel = _claimFilter == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(status, style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold)),
                    selected: isSel,
                    selectedColor: const Color(0xFF0284C7),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF475569)),
                    onSelected: (val) => setState(() => _claimFilter = status),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            if (claims.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Center(child: Text('No $_claimFilter claims found.')),
              )
            else
              ...claims.map((claim) => _buildClaimCard(claim)),
          ],
        );
      },
    );
  }

  // Tab 3: Users Management (SRS Requirement 2)
  Widget _buildUsersTabContent() {
    return StreamBuilder<List<UserModel>>(
      stream: _adminService.streamUsers(),
      builder: (context, snapshot) {
        var users = snapshot.data ?? [];
        if (_userSearchQuery.isNotEmpty) {
          users = users.where((u) {
            final q = _userSearchQuery.toLowerCase();
            return u.name.toLowerCase().contains(q) ||
                u.email.toLowerCase().contains(q) ||
                (u.studentId != null && u.studentId!.toLowerCase().contains(q));
          }).toList();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('User Management', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800)),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.manageUsers),
                  child: Text('Dedicated View ➔', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF0284C7))),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                onChanged: (val) => setState(() => _userSearchQuery = val),
                decoration: const InputDecoration(
                  hintText: 'Search user by name or email...',
                  prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 14),

            if (users.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: const Center(child: Text('No registered users match your search.')),
              )
            else
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
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF0284C7)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(user.name, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13)),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: user.role == 'Admin'
                                          ? const Color(0xFFEFF6FF)
                                          : (user.role == 'Teacher & Staff' ? const Color(0xFFF3E8FF) : const Color(0xFFF1F5F9)),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      user.role,
                                      style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: user.role == 'Admin'
                                            ? const Color(0xFF0284C7)
                                            : (user.role == 'Teacher & Staff' ? const Color(0xFF9333EA) : const Color(0xFF475569)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(user.email, style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11)),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: user.isSuspended ? 'Reactivate User' : 'Suspend User',
                          icon: Icon(
                            user.isSuspended ? Icons.play_circle_outline_rounded : Icons.pause_circle_outline_rounded,
                            color: user.isSuspended ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                          ),
                          onPressed: () async {
                            final nextState = !user.isSuspended;
                            final messenger = ScaffoldMessenger.of(context);
                            await _adminService.toggleUserSuspension(user.userId, nextState);
                            messenger.showSnackBar(
                              SnackBar(content: Text('User "${user.name}" ${nextState ? "suspended" : "reactivated"}.')),
                            );
                          },
                        ),
                      ],
                    ),
                  )),
          ],
        );
      },
    );
  }
}
