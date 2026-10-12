import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

/// Splash Screen with SMUCT Branding & Tagline
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Container
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentCyan, AppTheme.primaryNavy],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentCyan.withValues(alpha: 0.35),
                      blurRadius: 24,
                      spreadRadius: 4,
                    )
                  ],
                ),
                child: const Icon(Icons.search_rounded, size: 52, color: Colors.white),
              ),
              const SizedBox(height: 28),
              const Text(
                'SMUCT Lost & Found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find it. Report it. Return it.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.accentCyan,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Shanto-Mariam University of Creative Technology',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 56),
              const CircularProgressIndicator(color: AppTheme.accentCyan, strokeWidth: 3),
            ],
          ),
        ),
      ),
    );
  }
}
