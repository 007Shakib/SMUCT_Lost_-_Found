import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../mock/mock_data.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// Login Screen matching SMUCT Figma visual specification
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'id@smuct.edu.bd');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _selectedRole = 'Student';

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() => _isLoading = false);
        if (_emailController.text.toLowerCase().contains('admin')) {
          MockData.currentUser = MockData.users.firstWhere((u) => u.role == 'Admin');
          Navigator.pushReplacementNamed(context, '/admin');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('SMUCT ', style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Login', style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0284C7), width: 1.5),
              ),
              child: const Icon(Icons.shield_outlined, size: 16, color: Color(0xFF0284C7)),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // Main White Card Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Logo Badge
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF38BDF8), width: 1.5),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.shield_rounded, size: 28, color: Color(0xFF0284C7)),
                                  Text(
                                    'L & F',
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFF0369A1),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_circle_rounded, size: 18, color: Color(0xFF0284C7)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Tagline & Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0284C7),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'SMUCT CENTRAL REGISTRY',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF0284C7),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'SMUCT Lost & Found',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Campus Recovery Portal',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Single Sign-On Authentication Banner
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.account_balance_rounded, size: 20, color: Color(0xFF0284C7)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SMUCT Student & Staff Portal',
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFF0F172A),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Single Sign-On Authentication',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF64748B),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Role Segmented Selector: Student vs Admin
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  _selectedRole = 'Student';
                                  _emailController.text = 'student@smuct.edu.bd';
                                }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 9),
                                  decoration: BoxDecoration(
                                    color: _selectedRole == 'Student' ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: _selectedRole == 'Student'
                                        ? const [BoxShadow(color: Color(0x10000000), blurRadius: 4, offset: Offset(0, 2))]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.school_outlined, size: 15, color: _selectedRole == 'Student' ? const Color(0xFF0284C7) : const Color(0xFF64748B)),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Student Mode',
                                          style: GoogleFonts.outfit(
                                            color: _selectedRole == 'Student' ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  _selectedRole = 'Admin';
                                  _emailController.text = 'admin@smuct.edu.bd';
                                }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 9),
                                  decoration: BoxDecoration(
                                    color: _selectedRole == 'Admin' ? const Color(0xFF0284C7) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: _selectedRole == 'Admin'
                                        ? const [BoxShadow(color: Color(0x250284C7), blurRadius: 4, offset: Offset(0, 2))]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.shield_rounded, size: 15, color: _selectedRole == 'Admin' ? Colors.white : const Color(0xFF64748B)),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Admin Console',
                                          style: GoogleFonts.outfit(
                                            color: _selectedRole == 'Admin' ? Colors.white : const Color(0xFF64748B),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Email Field
                      CustomTextField(
                        label: 'University Email',
                        hint: 'id@smuct.edu.bd',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail_outline_rounded,
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Please enter your email';
                          if (!val.contains('@')) return 'Enter a valid university email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      CustomTextField(
                        label: 'Password',
                        hint: '••••••••••••',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        prefixIcon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: const Color(0xFF94A3B8),
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Please enter your password';
                          if (val.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),

                      // Forgot Password Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF0284C7),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Login Button
                      CustomButton(
                        text: 'Log In ➔',
                        isLoading: _isLoading,
                        onPressed: _handleLogin,
                      ),
                      const SizedBox(height: 10),

                      // Direct Campus Admin Console Access Button
                      OutlinedButton.icon(
                        icon: const Icon(Icons.admin_panel_settings_rounded, size: 18, color: Color(0xFF0284C7)),
                        label: Text(
                          'Quick Access: Campus Admin Console 🛡️',
                          style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFBAE6FD), width: 1.2),
                          backgroundColor: const Color(0xFFF0F9FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          minimumSize: const Size(double.infinity, 44),
                        ),
                        onPressed: () {
                          MockData.currentUser = MockData.users.firstWhere((u) => u.role == 'Admin');
                          Navigator.pushReplacementNamed(context, '/admin');
                        },
                      ),
                      const SizedBox(height: 14),

                      // Security badge footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_outline_rounded, size: 14, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 6),
                          Text(
                            'Encrypted institutional protocol',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF94A3B8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Ticker Section: LIVE CAMPUS FEED
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LIVE CAMPUS FEED',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF64748B),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    '14 Active Claims',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF0284C7),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFeedTickerCard(
                      icon: Icons.badge_outlined,
                      title: 'Student ID Ca...',
                      subtitle: 'Library Floor 3',
                    ),
                    const SizedBox(width: 12),
                    _buildFeedTickerCard(
                      icon: Icons.headphones_outlined,
                      title: 'AirPods Pro Ca...',
                      subtitle: 'Cafeteria Hub',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bottom Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New here? ',
                    style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: Text(
                      'Create Account / Sign Up',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF0284C7),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'SHANTO-MARIAM UNIVERSITY OF CREATIVE TECHNOLOGY',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: const Color(0xFF94A3B8),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedTickerCard({required IconData icon, required String title, required String subtitle}) {
    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF0284C7)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
