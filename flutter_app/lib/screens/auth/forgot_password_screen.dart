import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// Forgot Password Screen matching SMUCT Figma visual specification
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'rashid.2104@smuct.edu.bd');
  bool _isLoading = false;
  bool _isSent = false;

  void _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSent = true;
        });
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
            Text('Forgot Password', style: GoogleFonts.outfit(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 16)),
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
                      // Top Logo Badge with Refresh Icon
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
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Color(0xFF0284C7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.autorenew_rounded, size: 14, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Reset Password',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Enter your university email to receive recovery instructions.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email Field
                      CustomTextField(
                        label: 'University Email',
                        hint: 'rashid.2104@smuct.edu.bd',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail_outline_rounded,
                        suffixIcon: const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 20),
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Please enter your email';
                          if (!val.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Info callout box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFBAE6FD)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.mark_email_read_outlined, size: 18, color: Color(0xFF0284C7)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _isSent
                                    ? 'Instant recovery link sent to ${_emailController.text}. Check your student portal if needed.'
                                    : 'Instant recovery link sent to registered SMUCT inbox. Check your student portal if needed.',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF0369A1),
                                  fontSize: 11,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Reset Button
                      CustomButton(
                        text: _isSent ? 'Resend Link ➔' : 'Send Reset Link ➔',
                        isLoading: _isLoading,
                        onPressed: _handleResetPassword,
                      ),
                      const SizedBox(height: 16),

                      // Back to login link
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF64748B)),
                        label: Text(
                          'Back to Log In',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF0F172A),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield_outlined, size: 14, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 6),
                  Text(
                    'SMUCT Central Authentication & Security',
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
    );
  }
}
