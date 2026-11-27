import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';
import '../services/auth_service.dart';

/// Navigation Drawer with App Logo header matching SMUCT Portal design
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  width: 72,
                  height: 72,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'SMUCT Lost & Found',
              style: GoogleFonts.outfit(
                color: AppTheme.textMain,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version 2.4.1 (Build 1)',
              style: GoogleFonts.inter(
                color: AppTheme.accentCyan,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Official campus lost and found recovery portal for students, faculty, and staff of Shanto-Mariam University of Creative Technology.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppTheme.textMuted,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                color: AppTheme.accentCyan,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header with Official Logo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 52, bottom: 24, left: 20, right: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentCyan.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'SMUCT Lost & Found',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Campus Recovery Portal',
                  style: GoogleFonts.inter(
                    color: AppTheme.accentCyan,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Drawer Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildDrawerTile(
                  context,
                  icon: Icons.home_outlined,
                  title: 'Home Feed',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.search_outlined,
                  title: 'Search & Filters',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.search_off_rounded,
                  title: 'Report Lost Item',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/report-item', arguments: 'Lost');
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.check_circle_outline_rounded,
                  title: 'Report Found Item',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/report-item', arguments: 'Found');
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.grid_view_outlined,
                  title: 'My Posts',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/my-posts');
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.assignment_outlined,
                  title: 'My Claims',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/my-claims');
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
                if (AuthService().isAdmin)
                  _buildDrawerTile(
                    context,
                    icon: Icons.admin_panel_settings_rounded,
                    title: 'Admin Console',
                    iconColor: AppTheme.accentCyan,
                    textColor: AppTheme.accentCyan,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin');
                    },
                  ),
                _buildDrawerTile(
                  context,
                  icon: Icons.person_outline_rounded,
                  title: 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                const Divider(height: 24, thickness: 1, indent: 16, endIndent: 16),
                _buildDrawerTile(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: 'About Portal',
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
                _buildDrawerTile(
                  context,
                  icon: Icons.logout_rounded,
                  title: 'Sign Out',
                  iconColor: Colors.redAccent,
                  textColor: Colors.redAccent,
                  onTap: () async {
                    Navigator.pop(context);
                    await AuthService().signOut();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppTheme.textMuted, size: 22),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: textColor ?? AppTheme.textMain,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      dense: true,
      onTap: onTap,
    );
  }
}

