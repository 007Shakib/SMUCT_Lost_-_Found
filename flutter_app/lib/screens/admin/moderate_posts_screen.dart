import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../mock/mock_data.dart';
import '../../models/item_model.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_card.dart';

/// Admin Post Moderation Screen
class ModeratePostsScreen extends StatefulWidget {
  const ModeratePostsScreen({super.key});

  @override
  State<ModeratePostsScreen> createState() => _ModeratePostsScreenState();
}

class _ModeratePostsScreenState extends State<ModeratePostsScreen> with SingleTickerProviderStateMixin {
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

  void _handlePostAction(ItemModel item, String action) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('$action Post?', style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to $action post "${item.title}"?', style: const TextStyle(color: AppTheme.textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: action == 'Approve' ? AppTheme.statusFound : AppTheme.statusLost,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Post "${item.title}" $action action completed.')),
              );
            },
            child: Text(action),
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
        title: const Text('Moderate Posts'),
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentCyan,
          labelColor: AppTheme.accentCyan,
          unselectedLabelColor: const Color(0xFF94A3B8),
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Removed'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPostList('Pending'),
            _buildPostList('Approved'),
            _buildPostList('Removed'),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList(String tabType) {
    final posts = MockData.items;

    if (tabType == 'Removed') {
      return const EmptyState(
        icon: Icons.gavel_rounded,
        title: 'No Removed Posts',
        description: 'There are currently no reported or removed posts.',
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
                onPressed: () => _handlePostAction(item, 'Approve'),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 14),
                label: const Text('Approve', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.statusFound,
                  side: BorderSide(color: AppTheme.statusFound.withValues(alpha: 0.5)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  minimumSize: Size.zero,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _handlePostAction(item, 'Remove'),
                icon: const Icon(Icons.remove_circle_outline_rounded, size: 14),
                label: const Text('Remove', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.statusLost,
                  side: BorderSide(color: AppTheme.statusLost.withValues(alpha: 0.5)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  minimumSize: Size.zero,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
