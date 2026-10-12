import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../mock/mock_data.dart';
import '../../models/claim_model.dart';
import '../../models/item_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// Submit Claim Request Screen
class SubmitClaimScreen extends StatefulWidget {
  const SubmitClaimScreen({super.key});

  @override
  State<SubmitClaimScreen> createState() => _SubmitClaimScreenState();
}

class _SubmitClaimScreenState extends State<SubmitClaimScreen> {
  final _justificationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  void _handleSubmit(ItemModel item) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() => _isSubmitting = false);

      final newClaim = ClaimModel(
        claimId: 'clm_${DateTime.now().millisecondsSinceEpoch}',
        itemId: item.itemId,
        claimantId: MockData.currentUser.uid,
        itemTitle: item.title,
        justification: _justificationController.text,
        status: 'Pending',
        dateSubmitted: DateTime.now(),
      );

      MockData.claims.insert(0, newClaim);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppTheme.cardSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Column(
              children: const [
                Icon(Icons.hourglass_top_rounded, color: AppTheme.statusPending, size: 52),
                SizedBox(height: 12),
                Text(
                  'Claim Submitted',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: const Text(
              'Your claim is waiting for administrator review. You will receive a notification once verified.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
            ),
            actions: [
              CustomButton(
                text: 'View My Claims',
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  Navigator.pushReplacementNamed(context, '/my-claims');
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as ItemModel?;

    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Submit Claim')),
        body: const Center(child: Text('Invalid item selected.', style: TextStyle(color: Colors.white))),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Submit Claim Request'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Found Item Summary Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item.imageUrl,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 64,
                            height: 64,
                            color: const Color(0xFF1E293B),
                            child: const Icon(Icons.image_not_supported_rounded, color: Colors.white38),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Found at: ${item.location}',
                              style: const TextStyle(color: AppTheme.accentCyan, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Question Prompt
                const Text(
                  'Why do you believe this item belongs to you?',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Describe unique identifiers, markings, lock codes, contents, or serial numbers that prove ownership.',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Proof of Ownership Justification',
                  hint: 'e.g. My student ID card (213014002) is inside the wallet, along with a blue key fob...',
                  controller: _justificationController,
                  maxLines: 5,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please provide ownership justification details';
                    }
                    if (val.trim().length < 15) {
                      return 'Please enter at least 15 characters describing ownership proof';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                CustomButton(
                  text: 'Submit Claim',
                  icon: Icons.send_rounded,
                  isLoading: _isSubmitting,
                  onPressed: () => _handleSubmit(item),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
