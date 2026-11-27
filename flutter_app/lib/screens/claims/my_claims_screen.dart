import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/app_theme.dart';
import '../../mock/mock_data.dart';
import '../../models/claim_model.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_badge.dart';

/// My Submitted Claims Screen
class MyClaimsScreen extends StatefulWidget {
  const MyClaimsScreen({super.key});

  @override
  State<MyClaimsScreen> createState() => _MyClaimsScreenState();
}

class _MyClaimsScreenState extends State<MyClaimsScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final currentUid = AuthService().currentUser?.userId ?? AuthService().currentFirebaseUser?.uid ?? MockData.currentUser.uid;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('My Claims'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: StreamBuilder<List<ClaimModel>>(
          stream: _firestoreService.streamUserClaims(currentUid),
          builder: (context, snapshot) {
            final myClaims = snapshot.data ?? MockData.claims.where((c) => c.claimantId == currentUid).toList();

            if (myClaims.isEmpty) {
              return EmptyState(
                icon: Icons.fact_check_outlined,
                title: "You haven't submitted any claims",
                description: 'When you claim a found item on campus, your claim status will appear here.',
                buttonText: 'Browse Found Items',
                onButtonPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: myClaims.length,
              itemBuilder: (ctx, idx) {
                final claim = myClaims[idx];
                final formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(claim.dateSubmitted);

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
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
                          Text(
                            formattedDate,
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        claim.itemTitle,
                        style: const TextStyle(color: AppTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
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
                            const Text(
                              'Ownership Justification:',
                              style: TextStyle(color: AppTheme.accentCyan, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              claim.justification,
                              style: const TextStyle(color: Color(0xFF334155), fontSize: 12, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      if (claim.adminNotes != null && claim.adminNotes!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: Text(
                            'Admin Feedback: ${claim.adminNotes}',
                            style: const TextStyle(color: Color(0xFF92400E), fontSize: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
