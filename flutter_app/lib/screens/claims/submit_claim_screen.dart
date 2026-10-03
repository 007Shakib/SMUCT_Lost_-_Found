import 'package:flutter/material.dart';
import '../../models/item_model.dart';
import '../../models/claim_model.dart';
import '../../services/firestore_service.dart';

/// Submit Claim Request Screen (UC-07 / FR-07)
class SubmitClaimScreen extends StatefulWidget {
  const SubmitClaimScreen({super.key});

  @override
  State<SubmitClaimScreen> createState() => _SubmitClaimScreenState();
}

class _SubmitClaimScreenState extends State<SubmitClaimScreen> {
  final _justificationController = TextEditingController();
  bool _isSubmitting = false;
  final _firestoreService = FirestoreService();

  void _handleSubmit(ItemModel item) async {
    if (_justificationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide ownership justification details.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final newClaim = ClaimModel(
      claimId: 'clm_${DateTime.now().millisecondsSinceEpoch}',
      itemId: item.itemId,
      claimantId: 'usr_student_01',
      itemTitle: item.title,
      justification: _justificationController.text,
      status: 'Pending',
      dateSubmitted: DateTime.now(),
    );

    await _firestoreService.submitClaimRequest(newClaim);
    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Claim request submitted for administrator review (UC-07)!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as ItemModel?;

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Submit Claim Request')),
        body: const Center(child: Text('Invalid item selected.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Submit Claim Request (UC-07)')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.inventory_2, color: Color(0xFF0284C7)),
                title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Location: ${item.location}'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Proof of Ownership Justification',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Describe unique features, markings, wallpaper, contents, or serial numbers that prove this item belongs to you.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _justificationController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter specific details (e.g. Blue silicone sleeve, scratch on top left, student ID inside)...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Submit Claim for Review'),
              onPressed: _isSubmitting ? null : () => _handleSubmit(item),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
