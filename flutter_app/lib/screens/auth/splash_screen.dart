import 'package:flutter/material.dart';

/// Splash Screen with SMUCT Branding
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
      backgroundColor: const Color(0xFF0B0F19),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0284C7), Color(0xFF0F2B5C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0284C7).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: const Icon(Icons.search_off_rounded, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'SMUCT Lost & Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Shanto-Mariam University of Creative Technology',
              style: TextStyle(fontSize: 12, color: Colors.slateCustom),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: Color(0xFF0284C7)),
          ],
        ),
      ),
    );
  }
}

extension on TextStyle {
  Color get slateCustom => const Color(0xFF94A3B8);
}
