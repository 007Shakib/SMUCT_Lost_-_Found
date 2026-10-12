import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../mock/mock_data.dart';
import '../../models/item_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// Report Lost or Found Item Screen matching SMUCT Figma Screenshot 4 (Left)
class ReportItemScreen extends StatefulWidget {
  const ReportItemScreen({super.key});

  @override
  State<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'Matte Navy Hydro Flask');
  final _descriptionController = TextEditingController(
    text: 'Small sticker of SMUCT Robotics club on the cap. A subtle dent on the bottom stainless rim.',
  );
  String _location = 'Central Library, 2nd Floor Quiet Zone';

  String _status = 'Lost Item'; // 'Lost Item' or 'Found Item'
  String _selectedCategory = 'Accessories';
  DateTime _selectedDate = DateTime.now();
  final List<String> _photos = [
    'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600',
    'https://images.unsplash.com/photo-1544717305-2782549b5136?w=600',
  ];
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final initialStatus = ModalRoute.of(context)?.settings.arguments as String?;
    if (initialStatus != null && (initialStatus.contains('Lost') || initialStatus.contains('Found'))) {
      _status = initialStatus.contains('Lost') ? 'Lost Item' : 'Found Item';
    }
  }

  void _addPhoto() {
    setState(() {
      _photos.add('https://images.unsplash.com/photo-1544717305-2782549b5136?w=600');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo attached successfully!')),
    );
  }

  void _handlePublish() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() => _isLoading = false);

      final isLost = _status.contains('Lost');
      final newItem = ItemModel(
        itemId: 'itm_${DateTime.now().millisecondsSinceEpoch}',
        userId: MockData.currentUser.uid,
        categoryId: _selectedCategory,
        title: _titleController.text,
        description: _descriptionController.text,
        status: isLost ? 'Lost' : 'Found',
        claimStatus: 'Available',
        imageUrl: _photos.isNotEmpty ? _photos.first : 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600',
        location: _location,
        datePosted: _selectedDate,
        authorName: MockData.currentUser.name,
      );

      MockData.items.insert(0, newItem);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Column(
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 56),
                const SizedBox(height: 12),
                Text(
                  'Item Posted Successfully',
                  style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            content: Text(
              'Your $_status report for "${_titleController.text}" is now live on the SMUCT campus network.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 13),
            ),
            actions: [
              CustomButton(
                text: 'Done',
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
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
              'Report Item',
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
              backgroundImage: NetworkImage(MockData.currentUser.avatarUrl ?? ''),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Segmented Pill Toggle (Lost Item | Found Item)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: ['Lost Item', 'Found Item'].map((st) {
                      final isSelected = _status == st;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _status = st),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [Color(0xFF00C6FF), Color(0xFF00E676)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    )
                                  : null,
                              color: isSelected ? null : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF00C6FF).withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Text(
                              st,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                color: isSelected ? Colors.white : const Color(0xFF64748B),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Photos Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.camera_alt_outlined, size: 18, color: Color(0xFF0F172A)),
                        const SizedBox(width: 6),
                        Text(
                          'Photos',
                          style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '1 photo required',
                        style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Photo List Row
                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Add Photo Box
                      GestureDetector(
                        onTap: _addPhoto,
                        child: Container(
                          width: 80,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2FE),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add_a_photo_outlined, size: 18, color: Color(0xFF0284C7)),
                              ),
                              const SizedBox(height: 6),
                              Text('Add Photo', style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Photo thumbnails
                      ..._photos.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final url = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(url, width: 90, height: 90, fit: BoxFit.cover),
                              ),
                              if (idx == 0)
                                Positioned(
                                  bottom: 4,
                                  left: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.7),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text('Main', style: GoogleFonts.outfit(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => setState(() => _photos.removeAt(idx)),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, size: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Item Title Field
                CustomTextField(
                  label: 'Item Title',
                  hint: 'e.g. Matte Navy Hydro Flask',
                  controller: _titleController,
                  suffixIcon: const Icon(Icons.edit_outlined, color: Color(0xFF94A3B8), size: 18),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Enter item title';
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Category Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Category', style: GoogleFonts.outfit(color: const Color(0xFF475569), fontSize: 13, fontWeight: FontWeight.bold)),
                    Text(
                      _selectedCategory,
                      style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ['Electronics', 'ID & Cards', 'Keys', 'Bags', 'Accessories', 'Books & Notes', 'Clothing'].map((cat) {
                      final isSel = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat, style: GoogleFonts.outfit(fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.w600)),
                          selected: isSel,
                          selectedColor: const Color(0xFF0284C7),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(color: isSel ? Colors.white : const Color(0xFF475569)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: BorderSide(color: isSel ? Colors.transparent : const Color(0xFFE2E8F0)),
                          onSelected: (val) => setState(() => _selectedCategory = cat),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 18),

                // Location on Campus
                Text('Location on Campus', style: GoogleFonts.outfit(color: const Color(0xFF475569), fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Color(0xFF0284C7), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _location,
                          style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Date & Time + Verification Cards
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF0284C7)),
                                const SizedBox(width: 6),
                                Text('Date & Time', style: GoogleFonts.outfit(color: const Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Today, 2:15 PM',
                              style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.verified_outlined, size: 14, color: Color(0xFF10B981)),
                                const SizedBox(width: 6),
                                Text('Verification', style: GoogleFonts.outfit(color: const Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Instant Match On',
                              style: GoogleFonts.inter(color: const Color(0xFF10B981), fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Distinctive details or markings
                CustomTextField(
                  label: 'Distinctive details or markings',
                  hint: 'Describe unique stickers, scratches, colors or serials...',
                  controller: _descriptionController,
                  maxLines: 3,
                ),
                const SizedBox(height: 14),

                // Privacy Shield Banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.shield_outlined, size: 16, color: Color(0xFF0284C7)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your personal contact details stay hidden until a match is confirmed by you.',
                        style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11, height: 1.3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Primary Button
                CustomButton(
                  text: '➢ Post ${_status == 'Lost Item' ? 'Lost' : 'Found'} Report',
                  isLoading: _isLoading,
                  onPressed: _handlePublish,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
