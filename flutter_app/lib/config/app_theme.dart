import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Design System & Theme Configuration (NFR-09 Conformance)
class AppTheme {
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color cardSurface = Color(0xFF151D30);
  static const Color primaryNavy = Color(0xFF0F2B5C);
  static const Color accentCyan = Color(0xFF0284C7);
  static const Color borderSubtle = Color(0x1AFFFFFF);
  
  static const Color statusLost = Color(0xFFF43F5E);
  static const Color statusFound = Color(0xFF10B981);
  static const Color statusPending = Color(0xFFF59E0B);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: accentCyan,
        secondary: primaryNavy,
        surface: cardSurface,
        background: darkBackground,
        error: statusLost,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardTheme: CardTheme(
        color: cardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentCyan,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
