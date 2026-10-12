import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Design System & Theme Configuration matching Figma SMUCT Lost & Found Portal
class AppTheme {
  // Light Theme Color Palette (Figma Reference)
  static const Color lightBackground = Color(0xFFF4F7FB);
  static const Color darkBackground = Color(0xFFF4F7FB);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color cardSurfaceHover = Color(0xFFF8FAFC);
  static const Color primaryNavy = Color(0xFF0F172A);
  static const Color textMain = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textSubtle = Color(0xFF94A3B8);
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderBright = Color(0xFFCBD5E1);

  // Accents & Statuses
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentCyanLight = Color(0xFF22D3EE);
  static const Color accentMint = Color(0xFF10B981);
  static const Color statusLost = Color(0xFF0284C7);
  static const Color statusFound = Color(0xFF10B981);
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusClaimed = Color(0xFF3B82F6);

  // Signature Figma Cyan-to-Mint Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00D2FF), Color(0xFF38EF7D)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient heroCardGradient = primaryGradient;

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF00C6FF), Color(0xFF00E676)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient badgeGradient = LinearGradient(
    colors: [Color(0xFFE0F7FA), Color(0xFFE8F5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static BoxDecoration cardDecoration({
    double borderRadius = 20,
    Color? backgroundColor,
    BorderSide? borderSide,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? cardSurface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.fromBorderSide(
        borderSide ?? const BorderSide(color: borderSubtle, width: 1),
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 16,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        primary: accentCyan,
        secondary: primaryNavy,
        surface: cardSurface,
        error: Color(0xFFEF4444),
        onSurface: textMain,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: textMain),
        displayMedium: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.bold, color: textMain),
        titleLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, color: textMain),
        titleMedium: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: textMain),
        titleSmall: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: textMain),
        bodyLarge: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, color: textMain),
        bodyMedium: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: textMuted),
        bodySmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: textSubtle),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: textMain),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textMain,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        hintStyle: GoogleFonts.inter(color: textSubtle, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textMuted, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accentCyan, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentCyan,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // Backwards compatibility alias for darkTheme if referenced
  static ThemeData get darkTheme => lightTheme;
}


