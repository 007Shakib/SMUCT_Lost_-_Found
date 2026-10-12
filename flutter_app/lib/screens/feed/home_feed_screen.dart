import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../../mock/mock_data.dart';
import '../../models/item_model.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/item_card.dart';

/// Main Explore Feed Screen conforming to Figma design
class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  String _selectedCategory = 'All';
  String _statusFilter = 'All'; // 'All', 'Lost', 'Found'

  List<ItemModel> get _filteredItems {
    return MockData.items.where((item) {
      final matchesStatus = _statusFilter == 'All' || item.status.toLowerCase() == _statusFilter.toLowerCase();
      final matchesCategory = _selectedCategory == 'All' || item.category.toLowerCase() == _selectedCategory.toLowerCase();
      return matchesStatus && matchesCategory;
    }).toList();
  }

  int get _lostCount => MockData.items.where((i) => i.status.toUpperCase() == 'LOST').length;
  int get _foundCount => MockData.items.where((i) => i.status.toUpperCase() == 'FOUND').length;

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0284C7), Color(0xFF0F2B5C)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Color(0x330284C7), blurRadius: 8, offset: Offset(0, 3)),
                          ],
                        ),
                        child: const Icon(Icons.shield_outlined, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PORTAL',
                            style: GoogleFonts.outfit(
                              color: AppTheme.accentCyan,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            'SMUCT Lost & Found',
                            style: GoogleFonts.outfit(
                              color: AppTheme.textMain,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Admin Console',
                        icon: const Icon(Icons.admin_panel_settings_rounded, color: AppTheme.accentCyan, size: 22),
                        onPressed: () {
                          MockData.currentUser = MockData.users.firstWhere((u) => u.role == 'Admin');
                          Navigator.pushNamed(context, '/admin');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.textMain, size: 24),
                        onPressed: () => Navigator.pushNamed(context, '/notifications'),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(MockData.currentUser.avatarUrl ?? ''),
                          backgroundColor: const Color(0xFFE2E8F0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Title Block
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppTheme.statusFound,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'LIVE CAMPUS FEED',
                            style: GoogleFonts.outfit(
                              color: AppTheme.statusFound,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Explore\nFeed',
                        style: GoogleFonts.outfit(
                          color: AppTheme.textMain,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 14, color: AppTheme.statusLost),
                        const SizedBox(width: 4),
                        Text(
                          'SMUCT Campus',
                          style: GoogleFonts.outfit(
                            color: AppTheme.textMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Direct Campus Admin Console Banner
              InkWell(
                onTap: () {
                  MockData.currentUser = MockData.users.firstWhere((u) => u.role == 'Admin');
                  Navigator.pushNamed(context, '/admin');
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE0F2FE), Color(0xFFE0F7FA)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF7DD3FC)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Campus Admin Console Available',
                              style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontWeight: FontWeight.w800, fontSize: 12),
                            ),
                            Text(
                              'Tap to access Adjudication, Claims & Grid Overview',
                              style: GoogleFonts.inter(color: const Color(0xFF0369A1), fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF0284C7), size: 12),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Search Bar Trigger
              CustomSearchBar(
                hintText: 'Search items, tags, buildings...',
                readOnly: true,
                onTap: () => Navigator.pushNamed(context, '/search-filter'),
                onFilterTap: () => Navigator.pushNamed(context, '/search-filter'),
              ),
              const SizedBox(height: 16),

              // Summary Stat Cards Row (Lost items 14 | Found items 10)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F9FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFBAE6FD), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.statusLost,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Lost items',
                                style: GoogleFonts.inter(
                                  color: AppTheme.textMain,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$_lostCount',
                            style: GoogleFonts.outfit(
                              color: AppTheme.statusLost,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFA7F3D0), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.statusFound,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Found items',
                                style: GoogleFonts.inter(
                                  color: AppTheme.textMain,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$_foundCount',
                            style: GoogleFonts.outfit(
                              color: AppTheme.statusFound,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Filter Pills Row
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryChip(
                      label: 'All (${MockData.items.length})',
                      isSelected: _selectedCategory == 'All' && _statusFilter == 'All',
                      onTap: () => setState(() {
                        _selectedCategory = 'All';
                        _statusFilter = 'All';
                      }),
                    ),
                    CategoryChip(
                      label: '• Lost ($_lostCount)',
                      isSelected: _statusFilter == 'Lost',
                      onTap: () => setState(() => _statusFilter = 'Lost'),
                    ),
                    CategoryChip(
                      label: '• Found ($_foundCount)',
                      isSelected: _statusFilter == 'Found',
                      onTap: () => setState(() => _statusFilter = 'Found'),
                    ),
                    ...MockData.categories
                        .where((c) => c.name != 'All')
                        .map((c) => CategoryChip(
                              label: c.name,
                              isSelected: _selectedCategory == c.name,
                              onTap: () => setState(() => _selectedCategory = c.name),
                            )),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section Header: RECENT ACTIVITY
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RECENT ACTIVITY',
                    style: GoogleFonts.outfit(
                      color: AppTheme.textSubtle,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Sorted by latest',
                        style: GoogleFonts.inter(
                          color: AppTheme.statusLost,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppTheme.statusLost),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 2-Column Grid Listings
              if (filtered.isEmpty)
                EmptyState(
                  title: 'No Items Found',
                  description: 'No campus reports match your selected filters.',
                  buttonText: 'Reset Filters',
                  onButtonPressed: () {
                    setState(() {
                      _selectedCategory = 'All';
                      _statusFilter = 'All';
                    });
                  },
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (ctx, idx) {
                    final item = filtered[idx];
                    return ItemCard(
                      item: item,
                      isGridMode: true,
                      onTap: () => Navigator.pushNamed(context, '/item-detail', arguments: item),
                    );
                  },
                ),

              const SizedBox(height: 20),

              // Bottom Callout Card: Found something on campus?
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE0F7FA), Color(0xFFE8F5E9)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.handshake_outlined, color: AppTheme.accentCyan, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Found something on campus?',
                            style: GoogleFonts.outfit(
                              color: AppTheme.textMain,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Turn it in to help fellow students fast',
                            style: GoogleFonts.inter(
                              color: AppTheme.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.textMain,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/report-item', arguments: 'Found'),
                      child: Text('Report', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


