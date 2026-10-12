import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../mock/mock_data.dart';
import '../../models/claim_model.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_badge.dart';

/// Manage Claims Screen (Approve / Reject Requests)
class ApproveClaimsScreen extends StatefulWidget {
  const ApproveClaimsScreen({super.key});

  @override
  State<ApproveClaimsScreen> createState() => _ApproveClaimsScreenState();
}

class _ApproveClaimsScreenState extends State<ApproveClaimsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ClaimModel> _getClaimsByStatus(String status) {
    return MockData.claims.where((c) => c.status.toLowerCase() == status.toLowerCase()).toList();
  }

  void _handleAdjudicate(ClaimModel claim, bool isApprove) {
    setState(() {
      final index = MockData.claims.indexWhere((c) => c.claimId == claim.claimId);
      if (index != -1) {
        MockData.claims[index] = ClaimModel(
          claimId: claim.claimId,
          itemId: claim.itemId,
          claimantId: claim.claimantId,
          itemTitle: claim.itemTitle,
          justification: claim.justification,
          status: isApprove ? 'Approved' : 'Rejected',
          dateSubmitted: claim.dateSubmitted,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Claim for "${claim.itemTitle}" ${isApprove ? "APPROVED" : "REJECTED"}.'),
        backgroundColor: isApprove ? AppTheme.statusFound : AppTheme.statusLost,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Manage Claims'),
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentCyan,
          labelColor: AppTheme.accentCyan,
          unselectedLabelColor: const Color(0xFF94A3B8),
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
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
    final claims = _getClaimsByStatus(status);

    if (claims.isEmpty) {
      return EmptyState(
        icon: Icons.fact_check_outlined,
        title: 'No $status Claims',
        description: 'There are currently no $status claim requests in the queue.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: claims.length,
      itemBuilder: (ctx, idx) {
        final claim = claims[idx];
        final formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(claim.dateSubmitted);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatusBadge(status: claim.status),
                  Text(formattedDate, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                claim.itemTitle,
                style: const TextStyle(color: AppTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Claimant ID: ${claim.claimantId}',
                style: const TextStyle(color: AppTheme.accentCyan, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ownership Proof:', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(claim.justification, style: const TextStyle(color: Color(0xFF334155), fontSize: 12, height: 1.4)),
                  ],
                ),
              ),
              if (status == 'Pending') ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _handleAdjudicate(claim, true),
                        icon: const Icon(Icons.check_circle_rounded, size: 16),
                        label: const Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.statusFound,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _handleAdjudicate(claim, false),
                        icon: const Icon(Icons.cancel_rounded, size: 16),
                        label: const Text('Reject'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.statusLost,
                          side: const BorderSide(color: AppTheme.statusLost),
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
  }
}
