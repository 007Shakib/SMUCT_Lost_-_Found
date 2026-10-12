import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../../mock/mock_data.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// Profile Screen conforming strictly to SMUCT Figma visual design (Screenshot 5)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showEditProfileModal() {
    final nameCtrl = TextEditingController(text: MockData.currentUser.name);
    final phoneCtrl = TextEditingController(text: MockData.currentUser.phone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Edit Profile',
              style: GoogleFonts.outfit(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Full Name',
              controller: nameCtrl,
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Phone Number',
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_outlined,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Save Changes',
              onPressed: () {
                setState(() {
                  MockData.currentUser.name = nameCtrl.text;
                  MockData.currentUser.phone = phoneCtrl.text;
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SMUCT L&F',
              style: GoogleFonts.outfit(color: AppTheme.accentCyan, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8),
            ),
            Text(
              'Profile',
              style: GoogleFonts.outfit(color: AppTheme.textMain, fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.textMain),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0284C7), Color(0xFF0F2B5C)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shield_outlined, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile White Card (Figma Style)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppTheme.borderSubtle, width: 1),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0C000000), blurRadius: 16, offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 34,
                              backgroundImage: NetworkImage(user.avatarUrl ?? ''),
                              backgroundColor: const Color(0xFFE2E8F0),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.check_circle_rounded, color: AppTheme.statusFound, size: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: GoogleFonts.outfit(color: AppTheme.textMain, fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Computer Science & Engineering',
                                style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'ID: 2024-CSE-089',
                                style: GoogleFonts.inter(color: AppTheme.textSubtle, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Email & Verified Student Badges
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F9FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.email_outlined, size: 14, color: AppTheme.accentCyan),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    user.email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(color: AppTheme.textMain, fontSize: 11, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.shield_outlined, size: 14, color: AppTheme.statusFound),
                              const SizedBox(width: 6),
                              Text(
                                'Verified Student',
                                style: GoogleFonts.outfit(color: AppTheme.statusFound, fontSize: 11, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Activity Quick Stats Grid (3 Columns in Figma)
              Row(
                children: [
                  _buildStatCard('4', 'Lost Posts', Icons.search_rounded, const Color(0xFF0284C7)),
                  const SizedBox(width: 10),
                  _buildStatCard('2', 'Found Posts', Icons.assignment_outlined, const Color(0xFF10B981)),
                  const SizedBox(width: 10),
                  _buildStatCard('3', 'Resolved', Icons.check_circle_outline_rounded, const Color(0xFF10B981)),
                ],
              ),
              const SizedBox(height: 22),

              // CAMPUS ACTIVITY Section
              Text(
                'CAMPUS ACTIVITY',
                style: GoogleFonts.outfit(color: AppTheme.textSubtle, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8),
              ),
              const SizedBox(height: 10),

              _buildFigmaTile(
                icon: Icons.description_outlined,
                iconBg: const Color(0xFFF0F9FF),
                iconColor: AppTheme.accentCyan,
                title: 'My Posts',
                badgeText: '2 Active',
                badgeColor: const Color(0xFF00D2FF),
                onTap: () => Navigator.pushNamed(context, '/my-posts'),
              ),
              _buildFigmaTile(
                icon: Icons.check_box_outlined,
                iconBg: const Color(0xFFECFDF5),
                iconColor: AppTheme.statusFound,
                title: 'My Claims',
                badgeText: '1 Pending',
                badgeColor: const Color(0xFF34D399),
                onTap: () => Navigator.pushNamed(context, '/my-claims'),
              ),
              _buildFigmaTile(
                icon: Icons.bookmark_border_rounded,
                iconBg: const Color(0xFFEEF2FF),
                iconColor: const Color(0xFF4F46E5),
                title: 'Saved Items',
                onTap: () {},
              ),

              const SizedBox(height: 20),

              // CAMPUS ADMIN PORTAL Section
              Text(
                'ADMINISTRATION & GOVERNANCE',
                style: GoogleFonts.outfit(color: AppTheme.textSubtle, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8),
              ),
              const SizedBox(height: 10),

              _buildFigmaTile(
                icon: Icons.admin_panel_settings_rounded,
                iconBg: const Color(0xFFE0F2FE),
                iconColor: const Color(0xFF0284C7),
                title: 'Admin Console',
                subtitle: 'Adjudication, Flagged Moderation & Metrics',
                badgeText: 'Super Admin',
                badgeColor: const Color(0xFF0284C7),
                onTap: () {
                  MockData.currentUser = MockData.users.firstWhere((u) => u.role == 'Admin');
                  Navigator.pushNamed(context, '/admin');
                },
              ),

              const SizedBox(height: 20),

              // ACCOUNT & SAFETY Section
              Text(
                'ACCOUNT & SAFETY',
                style: GoogleFonts.outfit(color: AppTheme.textSubtle, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8),
              ),
              const SizedBox(height: 10),

              _buildFigmaTile(
                icon: Icons.badge_outlined,
                iconBg: const Color(0xFFEEF2FF),
                iconColor: const Color(0xFF4F46E5),
                title: 'Campus Safe ID',
                subtitle: 'Authenticated credentials',
                trailingWidget: const Icon(Icons.check_circle_rounded, color: AppTheme.statusFound, size: 18),
                onTap: () {},
              ),
              _buildFigmaTile(
                icon: Icons.notifications_none_rounded,
                iconBg: const Color(0xFFEEF2FF),
                iconColor: const Color(0xFF4F46E5),
                title: 'Notification Preferences',
                onTap: () => Navigator.pushNamed(context, '/notifications'),
              ),
              _buildFigmaTile(
                icon: Icons.person_outline_rounded,
                iconBg: const Color(0xFFEEF2FF),
                iconColor: const Color(0xFF4F46E5),
                title: 'Edit Profile',
                onTap: _showEditProfileModal,
              ),

              const SizedBox(height: 10),

              _buildFigmaTile(
                icon: Icons.logout_rounded,
                iconBg: const Color(0xFFFEE2E2),
                iconColor: const Color(0xFFEF4444),
                title: 'Sign Out',
                titleColor: const Color(0xFFEF4444),
                onTap: () => Navigator.pushReplacementNamed(context, '/login'),
              ),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  'SMUCT LOST & FOUND PORTAL • V2.4.1',
                  style: GoogleFonts.outfit(color: AppTheme.textSubtle, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.8),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.borderSubtle),
          boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 3))],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: GoogleFonts.outfit(color: AppTheme.textMain, fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFigmaTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    String? subtitle,
    String? badgeText,
    Color? badgeColor,
    Color? titleColor,
    Widget? trailingWidget,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSubtle),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          color: titleColor ?? AppTheme.textMain,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 1),
                        Text(subtitle, style: GoogleFonts.inter(color: AppTheme.textSubtle, fontSize: 11)),
                      ],
                    ],
                  ),
                ),
                if (badgeText != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor ?? AppTheme.accentCyan,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeText,
                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                trailingWidget ?? const Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.textSubtle, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
