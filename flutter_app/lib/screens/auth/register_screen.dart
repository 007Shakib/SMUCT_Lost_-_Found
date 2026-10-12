import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// Sign Up / Register Screen matching SMUCT Figma visual specification
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = true;
  bool _isLoading = false;

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please agree to the Campus Guidelines to continue.')),
        );
        return;
      }
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please login.'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        Navigator.pop(context);
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('SMUCT ', style: GoogleFonts.outfit(color: const Color(0xFF0284C7), fontWeight: FontWeight.bold, fontSize: 16)),
            Text('Sign Up', style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 16)),
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
                      // Top Logo Badge
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFF38BDF8), width: 1.5),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.shield_rounded, size: 26, color: Color(0xFF0284C7)),
                                  Text(
                                    'L & F',
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFF0369A1),
                                      fontSize: 9,
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
                            child: const Icon(Icons.add_circle_rounded, size: 16, color: Color(0xFF0284C7)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'OFFICIAL PORTAL',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF0284C7),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Create Account',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Join the SMUCT campus community to recover or report lost belongings',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Full Name
                      CustomTextField(
                        label: 'Full Name',
                        hint: 'e.g. Mahfuzur Rahman',
                        controller: _nameController,
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Enter your full name';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // University Email
                      CustomTextField(
                        label: 'University Email',
                        hint: 'student.id@smuct.edu.bd',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.school_outlined,
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Enter your university email';
                          if (!val.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Student / Staff ID
                      CustomTextField(
                        label: 'Student / Staff ID',
                        hint: 'e.g. 211071042',
                        controller: _idController,
                        prefixIcon: Icons.badge_outlined,
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Enter your student ID';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Password
                      CustomTextField(
                        label: 'Password',
                        hint: 'At least 8 characters',
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
                          if (val == null || val.isEmpty) return 'Enter a password';
                          if (val.length < 8) return 'Password must be at least 8 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Confirm Password
                      CustomTextField(
                        label: 'Confirm Password',
                        hint: 'Re-enter password',
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        prefixIcon: Icons.shield_outlined,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: const Color(0xFF94A3B8),
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                        validator: (val) {
                          if (val != _passwordController.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Checkbox Terms
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _agreedToTerms,
                              activeColor: const Color(0xFF0284C7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'I agree to the ',
                                style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 11),
                                children: [
                                  TextSpan(
                                    text: 'Campus Community Guidelines',
                                    style: GoogleFonts.inter(color: const Color(0xFF0284C7), fontWeight: FontWeight.bold),
                                  ),
                                  const TextSpan(text: ' and authorize student status validation.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Create Account Button
                      CustomButton(
                        text: 'Create Account ➔',
                        isLoading: _isLoading,
                        onPressed: _handleRegister,
                      ),
                      const SizedBox(height: 14),

                      // Identity Network note
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shield_outlined, size: 14, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 6),
                          Text(
                            'SMUCT Identity Network Verified Registration',
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

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Log In',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF0284C7),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
