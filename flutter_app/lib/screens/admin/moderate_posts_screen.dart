import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/item_model.dart';
import '../../services/admin_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/empty_state.dart';

/// Admin Post Moderation Screen (SRS Requirement 3)
/// Connected to Cloud Firestore items collection with filtering,
/// image inspection, report resolution, and removal confirmation.
class ModeratePostsScreen extends StatefulWidget {
  const ModeratePostsScreen({super.key});

  @override
  State<ModeratePostsScreen> createState() => _ModeratePostsScreenState();
}

class _ModeratePostsScreenState extends State<ModeratePostsScreen> with SingleTickerProviderStateMixin {
  final AdminService _adminService = AdminService.instance;
  late TabController _tabController;
  final List<String> _tabs = ['All', 'Lost', 'Found', 'Flagged', 'Approved', 'Removed'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    // Enforce role authorization
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

  void _showItemDetailModal(ItemModel item) {
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
        child: SingleChildScrollView(
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

              // Title and Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.status == 'Lost' ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.status.toUpperCase(),
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: item.status == 'Lost' ? const Color(0xFFEF4444) : const Color(0xFF047857),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Hero Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  item.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: const Color(0xFFF1F5F9),
                    child: const Center(child: Icon(Icons.image_not_supported_rounded, size: 40, color: Color(0xFF94A3B8))),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text('FULL DESCRIPTION', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF64748B), letterSpacing: 0.6)),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  item.description,
                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF334155), height: 1.4),
                ),
              ),
              const SizedBox(height: 14),

              // Metadata Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Author: ${item.authorName}', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                  Text('Location: ${item.location}', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF0284C7), fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Posted: ${DateFormat('MMM d, yyyy • h:mm a').format(item.datePosted)}',
                style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
              ),

              if (item.isFlagged || item.flagReason != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.flag_rounded, color: Color(0xFFEF4444), size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Flag Reason: ${item.flagReason ?? "Flagged for moderation"}',
                          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF991B1B)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 22),

              // Action Buttons: Approve (Dismiss Flag) | Remove Listing
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF10B981),
                        side: const BorderSide(color: Color(0xFF10B981)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await _adminService.approvePost(item.itemId);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Listing "${item.title}" approved / restored to active feed.')),
                          );
                        }
                      },
                      icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                      label: Text('Approve Post', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showConfirmRemoveDialog(item);
                      },
                      icon: const Icon(Icons.remove_circle_outline_rounded, size: 18, color: Colors.white),
                      label: Text('Remove Listing', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
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

  void _showConfirmRemoveDialog(ItemModel item) {
    final reasonCtrl = TextEditingController(text: 'Violates campus lost and found integrity guidelines.');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Confirm Post Removal', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to remove "${item.title}"? The post author will receive a notification with your specified reason.',
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF475569)),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: reasonCtrl,
              maxLines: 2,
              style: GoogleFonts.inter(fontSize: 13),
              decoration: InputDecoration(
                labelText: 'Removal Reason',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.inter(color: const Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await _adminService.removePost(item.itemId, reasonCtrl.text.trim());
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Color(0xFFEF4444),
                    content: Text('Post removed from portal and author notified.'),
                  ),
                );
              }
            },
            child: const Text('Confirm Remove', style: TextStyle(color: Colors.white)),
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
        title: Text('Moderate Posts', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
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
          children: _tabs.map((t) => _buildPostList(t)).toList(),
        ),
      ),
    );
  }

  Widget _buildPostList(String filterTab) {
    return StreamBuilder<List<ItemModel>>(
      stream: _adminService.streamAllPosts(filterStatus: filterTab),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return EmptyState(
            icon: Icons.fact_check_outlined,
            title: 'No $filterTab Posts',
            description: 'There are currently no items under the $filterTab tab.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (ctx, idx) {
            final item = posts[idx];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: item.isFlagged ? const Color(0xFFFECACA) : const Color(0xFFE2E8F0),
                  width: item.isFlagged ? 1.5 : 1.0,
                ),
                boxShadow: const [BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2))],
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => _showItemDetailModal(item),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              color: const Color(0xFFF1F5F9),
                              child: const Icon(Icons.image_not_supported_rounded, color: Color(0xFF94A3B8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF0F172A)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
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
                              const SizedBox(height: 3),
                              Text('By ${item.authorName} • Location: ${item.location}', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                              const SizedBox(height: 2),
                              Text(
                                item.description,
                                style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMM d • h:mm a').format(item.datePosted),
                        style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
                      ),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _showItemDetailModal(item),
                            icon: const Icon(Icons.visibility_outlined, size: 14),
                            label: const Text('Inspect', style: TextStyle(fontSize: 11)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF0284C7),
                              side: const BorderSide(color: Color(0xFFBAE6FD)),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () => _showConfirmRemoveDialog(item),
                            icon: const Icon(Icons.delete_outline_rounded, size: 14),
                            label: const Text('Remove', style: TextStyle(fontSize: 11)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFEF4444),
                              side: const BorderSide(color: Color(0xFFEF4444)),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
