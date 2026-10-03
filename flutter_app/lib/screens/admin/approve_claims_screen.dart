import 'package:flutter/material.dart';
import '../../services/admin_service.dart';

/// Approve / Reject Claims Screen (UC-12 / FR-12)
class ApproveClaimsScreen extends StatefulWidget {
  const ApproveClaimsScreen({super.key});

  @override
  State<ApproveClaimsScreen> createState() => _ApproveClaimsScreenState();
}

class _ApproveClaimsScreenState extends State<ApproveClaimsScreen> {
  final _adminService = AdminService();

  final List<Map<String, String>> _pendingClaims = [
    {
      'claimId': 'clm_101',
      'itemTitle': 'Apple AirPods Pro Case',
      'claimant': 'Mahin Mia (Student ID: 241071018)',
      'justification': 'Blue silicone case with a small scratch on top left corner. Serial # A2084.',
      'date': '2026-10-02',
    },
    {
      'claimId': 'clm_102',
      'itemTitle': 'Black Leather Wallet',
      'claimant': 'Tanvir Hossain (Student ID: 241071099)',
      'justification': 'Contains student ID card and library card.',
      'date': '2026-10-03',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approve / Reject Claims (UC-12)')),
      body: _pendingClaims.isEmpty
          ? const Center(child: Text('No pending claim requests in queue.'))
          : ListView.builder(
              itemCount: _pendingClaims.length,
              itemBuilder: (context, index) {
                final claim = _pendingClaims[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              claim['itemTitle']!,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(claim['date']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('Claimant: ${claim['claimant']}'),
                        const SizedBox(height: 8),
                        Text('Justification: "${claim['justification']}"',
                            style: const TextStyle(fontStyle: FontStyle.italic)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                onPressed: () {
                                  _adminService.adjudicateClaim(
                                    claimId: claim['claimId']!,
                                    itemId: 'itm_001',
                                    approve: true,
                                  );
                                  setState(() => _pendingClaims.removeAt(index));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Claim APPROVED. FCM Notification triggered (FR-09).')),
                                  );
                                },
                                child: const Text('Approve Claim'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                                onPressed: () {
                                  _adminService.adjudicateClaim(
                                    claimId: claim['claimId']!,
                                    itemId: 'itm_001',
                                    approve: false,
                                  );
                                  setState(() => _pendingClaims.removeAt(index));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Claim REJECTED.')),
                                  );
                                },
                                child: const Text('Reject Claim'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
