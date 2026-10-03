import 'package:flutter/material.dart';
import '../../models/claim_model.dart';
import '../../services/firestore_service.dart';

/// Track Submitted Claims Screen (UC-07 Track / FR-07)
class MyClaimsScreen extends StatelessWidget {
  const MyClaimsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('My Claim Requests (UC-07)')),
      body: StreamBuilder<List<ClaimModel>>(
        stream: firestoreService.streamUserClaims('usr_student_01'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final claims = snapshot.data!;

          if (claims.isEmpty) {
            return const Center(child: Text('No active claim requests.'));
          }

          return ListView.builder(
            itemCount: claims.length,
            itemBuilder: (context, index) {
              final claim = claims[index];
              Color statusColor = Colors.orange;
              if (claim.status == 'Approved') statusColor = Colors.green;
              if (claim.status == 'Rejected') statusColor = Colors.red;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(claim.itemTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Justification: ${claim.justification}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      claim.status,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
