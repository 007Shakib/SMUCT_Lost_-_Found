import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../mock/mock_data.dart';
import '../../models/item_model.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_card.dart';

/// Manage Own Published Posts Screen with Tabs (All, Lost, Found)
class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> with SingleTickerProviderStateMixin {
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

  List<ItemModel> _getPostsByStatus(String status) {
    final myPosts = MockData.items.where((i) => i.userId == MockData.currentUser.uid).toList();
    if (status == 'All') return myPosts;
    return myPosts.where((i) => i.status.toLowerCase() == status.toLowerCase()).toList();
  }

  void _confirmDelete(ItemModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Post?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to delete "${item.title}"? This action cannot be undone.',
          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.statusLost),
            onPressed: () {
              setState(() {
                MockData.items.removeWhere((i) => i.itemId == item.itemId);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('"${item.title}" deleted successfully.')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('My Published Posts'),
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentCyan,
          labelColor: AppTheme.accentCyan,
          unselectedLabelColor: const Color(0xFF94A3B8),
          tabs: const [
            Tab(text: 'All Posts'),
            Tab(text: 'Lost'),
            Tab(text: 'Found'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPostList('All'),
            _buildPostList('Lost'),
            _buildPostList('Found'),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList(String status) {
    final posts = _getPostsByStatus(status);

    if (posts.isEmpty) {
      return EmptyState(
        icon: Icons.post_add_rounded,
        title: 'No $status Posts',
        description: 'You have not published any $status item reports yet.',
        buttonText: 'Report Item',
        onButtonPressed: () => Navigator.pushNamed(context, '/report-item'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: posts.length,
      itemBuilder: (ctx, idx) {
        final item = posts[idx];
        return ItemCard(
          item: item,
          onTap: () => Navigator.pushNamed(context, '/item-detail', arguments: item),
          trailingActions: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/edit-item', arguments: item),
                icon: const Icon(Icons.edit_outlined, size: 14),
                label: const Text('Edit', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.accentCyan,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _confirmDelete(item),
                icon: const Icon(Icons.delete_outline_rounded, size: 14),
                label: const Text('Delete', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.statusLost,
                  side: BorderSide(color: AppTheme.statusLost.withValues(alpha: 0.5)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
