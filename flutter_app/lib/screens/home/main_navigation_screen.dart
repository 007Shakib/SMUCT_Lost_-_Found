import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../feed/home_feed_screen.dart';
import '../feed/search_filter_screen.dart';
import '../items/my_posts_screen.dart';
import '../profile/profile_screen.dart';

/// Main App Navigation Shell matching Figma 5-tab design
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = const [
    HomeFeedScreen(),
    SearchFilterScreen(),
    SizedBox(), // Index 2 reserved for FAB Report action modal
    MyPostsScreen(),
    ProfileScreen(),
  ];

  void _showReportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppTheme.borderSubtle,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Report an Item',
              style: GoogleFonts.outfit(
                color: AppTheme.textMain,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Select whether you lost something or found something on campus:',
              style: GoogleFonts.inter(
                color: AppTheme.textMuted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),

            // Report Lost Item Option Card
            Material(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(context, '/report-item', arguments: 'Lost');
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE0F2FE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.search_off_rounded, color: AppTheme.statusLost, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Report Lost Item',
                              style: GoogleFonts.outfit(color: AppTheme.textMain, fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'I lost an item on campus and want to create a report',
                              style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.textSubtle, size: 16),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Report Found Item Option Card
            Material(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(context, '/report-item', arguments: 'Found');
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFDCFCE7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle_outline_rounded, color: AppTheme.statusFound, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Report Found Item',
                              style: GoogleFonts.outfit(color: AppTheme.textMain, fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'I found an item on campus and want to report it',
                              style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.textSubtle, size: 16),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: IndexedStack(
        index: _currentIndex == 2 ? 0 : _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
            _buildNavItem(1, Icons.search_outlined, Icons.search_rounded, 'Search'),
            
            // Center FAB Action: Report
            GestureDetector(
              onTap: () => _showReportOptions(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x4000D2FF),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add_rounded, color: Colors.black, size: 26),
                  ),
                  Text(
                    'Report',
                    style: GoogleFonts.outfit(
                      color: AppTheme.textMain,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            _buildNavItem(3, Icons.grid_view_outlined, Icons.grid_view_rounded, 'My Posts'),
            _buildNavItem(4, Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? AppTheme.accentCyan : AppTheme.textSubtle,
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: isSelected ? AppTheme.accentCyan : AppTheme.textSubtle,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


