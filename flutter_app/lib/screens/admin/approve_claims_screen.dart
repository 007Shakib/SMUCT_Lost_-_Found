import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/claim_model.dart';
import '../../services/admin_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/empty_state.dart';

/// Manage Claims Screen (SRS Requirement 4)
/// Full Firebase Firestore Integration with Pending/Approved/Rejected tabs,
/// Claimant inspection, Approve (mark Claimed & prevent conflicts), Reject, and Request Info.
class ApproveClaimsScreen extends StatefulWidget {
  const ApproveClaimsScreen({super.key});

  @override
  State<ApproveClaimsScreen> createState() => _ApproveClaimsScreenState();
}

class _ApproveClaimsScreenState extends State<ApproveClaimsScreen> with SingleTickerProviderStateMixin {
  final AdminService _adminService = AdminService.instance;
  late TabController _tabController;
  final List<String> _tabs = ['Pending', 'Approved', 'Rejected'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!AuthService().isAdmin) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Access Denied: Administrator role required.'),
            backgroundColor: Color(0xFFEF4444),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleApprove(ClaimModel claim) async {
    try {
      final success = await _adminService.approveClaim(claim.claimId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF10B981),
            content: Text('Claim for "${claim.itemTitle}" APPROVED. Item marked as Claimed & claimant notified.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: const Color(0xFFEF4444), content: Text('Approval failed: $e')),
        );
      }
    }
  }

  void _showRejectDialog(ClaimModel claim) {
    final reasonCtrl = TextEditingController(text: 'Ownership proof insufficient to verify rightful owner.');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Reject Claim?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specify why this claim cannot be verified. The claimant will be notified.', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              maxLines: 3,
              style: GoogleFonts.inter(fontSize: 13),
              decoration: InputDecoration(
                labelText: 'Rejection Reason',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: GoogleFonts.inter(color: const Color(0xFF94A3B8)))),
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
                    content: Text('Claim marked as Rejected and student notified.'),
                  ),
                );
              }
            },
            child: const Text('Reject Claim', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showRequestInfoDialog(ClaimModel claim) {
    final noteCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Request Additional Info', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Request additional proof while keeping this claim in Pending status.', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
            const SizedBox(height: 12),
            TextField(
              controller: noteCtrl,
              maxLines: 3,
              style: GoogleFonts.inter(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'e.g. Please upload photo of receipt or serial number...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: GoogleFonts.inter(color: const Color(0xFF94A3B8)))),
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
                    content: Text('Requested additional proof from claimant.'),
                  ),
                );
              }
            },
            child: const Text('Send Request', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: Text('Claim Management', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF0284C7),
          labelColor: const Color(0xFF0284C7),
          unselectedLabelColor: const Color(0xFF64748B),
          labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildClaimList('Pending'),
            _buildClaimList('Approved'),
            _buildClaimList('Rejected'),
          ],
        ),
      ),
    );
  }

  Widget _buildClaimList(String status) {
    return StreamBuilder<List<ClaimModel>>(
      stream: _adminService.streamClaims(status: status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final claims = snapshot.data ?? [];

        if (claims.isEmpty) {
          return EmptyState(
            icon: Icons.fact_check_outlined,
            title: 'No $status Claims',
            description: 'There are currently no $status claim requests in the queue.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: claims.length,
          itemBuilder: (ctx, idx) {
            final claim = claims[idx];
            final formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(claim.dateSubmitted);

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: status == 'Approved'
                              ? const Color(0xFFDCFCE7)
                              : (status == 'Rejected' ? const Color(0xFFFEE2E2) : const Color(0xFFFEF3C7)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          claim.status.toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: status == 'Approved'
                                ? const Color(0xFF047857)
                                : (status == 'Rejected' ? const Color(0xFFEF4444) : const Color(0xFFB45309)),
                          ),
                        ),
                      ),
                      Text(formattedDate, style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    claim.itemTitle,
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Claimant: ${claim.claimantName ?? claim.claimantId} ${claim.claimantStudentId != null ? "(${claim.claimantStudentId})" : ""}',
                    style: GoogleFonts.inter(color: const Color(0xFF0284C7), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ownership Proof Justification:', style: GoogleFonts.outfit(color: const Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(claim.justification, style: GoogleFonts.inter(color: const Color(0xFF334155), fontSize: 12, height: 1.4)),
                      ],
                    ),
                  ),
                  if (claim.adminNotes != null && claim.adminNotes!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Admin Note: ${claim.adminNotes}',
                        style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF92400E)),
                      ),
                    ),
                  ],
                  if (status == 'Pending') ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _handleApprove(claim),
                            icon: const Icon(Icons.check_circle_rounded, size: 16, color: Colors.white),
                            label: const Text('Approve', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showRequestInfoDialog(claim),
                            icon: const Icon(Icons.help_outline_rounded, size: 16, color: Color(0xFF0284C7)),
                            label: const Text('Ask Info', style: TextStyle(color: Color(0xFF0284C7))),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF0284C7)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showRejectDialog(claim),
                            icon: const Icon(Icons.cancel_rounded, size: 16, color: Color(0xFFEF4444)),
                            label: const Text('Reject', style: TextStyle(color: Color(0xFFEF4444))),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFEF4444)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}
