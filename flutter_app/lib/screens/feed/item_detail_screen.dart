import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/item_model.dart';
import '../../widgets/custom_button.dart';

/// Item Detail & Claim Screen matching SMUCT Figma Screenshot 4 (Right)
class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  bool _isBookmarked = false;
  final _claimDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as ItemModel?;

    // Default item if null for preview
    final displayItem = item ??
        ItemModel(
          itemId: '#8842',
          userId: 'usr_1',
          categoryId: 'ELECTRONICS',
          title: 'AirPods Pro (2nd Gen)',
          description:
              'Found near the front row auditorium bench. Encased in a white silicone protective cover with an emerald-green mini carabiner attached.',
          status: 'FOUND',
          claimStatus: 'Available',
          imageUrl: 'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=600',
          location: 'Building A • Room 204',
          datePosted: DateTime.now().subtract(const Duration(hours: 2)),
          authorName: 'Campus Safety',
        );

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFFE0F2FE),
              child: const Icon(Icons.shield_rounded, size: 16, color: Color(0xFF0284C7)),
            ),
            const SizedBox(width: 8),
            Text(
              'Item Details',
              style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFFE0F2FE),
              child: const Icon(Icons.shield_outlined, size: 14, color: Color(0xFF0284C7)),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image with Overlays
              Container(
                margin: const EdgeInsets.all(16),
                height: 240,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        displayItem.imageUrl,
                        width: double.infinity,
                        height: 240,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFE2E8F0),
                          child: const Center(child: Icon(Icons.image_outlined, size: 48, color: Color(0xFF94A3B8))),
                        ),
                      ),
                    ),
                    // Top Left Status Badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Text(
                              'FOUND PROPERTY',
                              style: GoogleFonts.outfit(color: const Color(0xFF047857), fontSize: 10, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Top Right Action Buttons
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _isBookmarked = !_isBookmarked),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Icon(
                                _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                size: 18,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.ios_share, size: 16, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                    ),
                    // Bottom Overlays (Location & Time)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              displayItem.location,
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              '2h ago',
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Title and Tags Body Padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tags row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'ELECTRONICS',
                            style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, size: 10, color: Color(0xFF10B981)),
                              const SizedBox(width: 4),
                              Text(
                                'Custodian Logged',
                                style: GoogleFonts.outfit(color: const Color(0xFF047857), fontSize: 10, fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'REF ID #8842',
                          style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Title
                    Text(
                      displayItem.title,
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF0F172A),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'MagSafe Charging Case included',
                      style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 13),
                    ),
                    const SizedBox(height: 14),

                    // Field Note Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FIELD NOTE',
                            style: GoogleFonts.outfit(color: const Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            displayItem.description,
                            style: GoogleFonts.inter(color: const Color(0xFF334155), fontSize: 12, height: 1.45),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Badges Row (LOGGED BY & HELD AT)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F9FF),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFBAE6FD)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(Icons.shield_outlined, size: 16, color: Color(0xFF0284C7)),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('LOGGED BY', style: GoogleFonts.outfit(color: const Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.bold)),
                                    Text('Campus Safety', style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFBBF7D0)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(Icons.account_balance_outlined, size: 16, color: Color(0xFF10B981)),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('HELD AT', style: GoogleFonts.outfit(color: const Color(0xFF64748B), fontSize: 9, fontWeight: FontWeight.bold)),
                                    Text('Student Affairs', style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Security Verification Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.lock_outline_rounded, size: 18, color: Color(0xFF0284C7)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Identity Secured', style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontSize: 12, fontWeight: FontWeight.bold)),
                                Text('Proof of ownership required', style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                            child: Text('Level 2', style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Claim Section Container (White card)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF0F172A).withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 4)),
                        ],
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.verified_user_outlined, color: Color(0xFF0284C7), size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Claim This Property',
                                    style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontSize: 15, fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(10)),
                                child: Text('INSTANT REVIEW', style: GoogleFonts.outfit(color: const Color(0xFF047857), fontSize: 10, fontWeight: FontWeight.w800)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'To protect campus owners, specify distinctive markings, connected Apple ID initials, or provide a purchase invoice.',
                            style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11, height: 1.4),
                          ),
                          const SizedBox(height: 14),

                          // Form Field
                          Text('Ownership Description', style: GoogleFonts.outfit(color: const Color(0xFF475569), fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _claimDescriptionController,
                            maxLines: 3,
                            style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontSize: 12),
                            decoration: InputDecoration(
                              hintText: "e.g. Case has small scratch on bottom hinge, device is named 'Sam's AirPods'...",
                              hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 11),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Photo Evidence Upload Box
                          Text('Photo Evidence (Optional)', style: GoogleFonts.outfit(color: const Color(0xFF475569), fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F9FF),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFBAE6FD)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: const Color(0xFFE0F2FE), shape: BoxShape.circle),
                                  child: const Icon(Icons.add_a_photo_outlined, color: Color(0xFF0284C7), size: 20),
                                ),
                                const SizedBox(height: 6),
                                Text('+ Upload Screenshot or Serial ID', style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontSize: 12, fontWeight: FontWeight.bold)),
                                Text('PNG, JPG, or Apple Receipt up to 10MB', style: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 10)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Submit Action Row
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), shape: BoxShape.circle),
                                child: const Icon(Icons.help_outline_rounded, color: Color(0xFF64748B), size: 18),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomButton(
                                  text: 'Submit Ownership Claim ➔',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Claim submitted for administrator verification!'),
                                        backgroundColor: Color(0xFF10B981),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
