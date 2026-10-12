import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable status chip/badge with dot indicator conforming to Figma SMUCT design system
class StatusBadge extends StatelessWidget {
  final String status;
  final bool isSmall;

  const StatusBadge({
    super.key,
    required this.status,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toUpperCase()) {
      case 'LOST':
        bg = const Color(0xFFE0F2FE); // Soft cyan blue
        fg = const Color(0xFF0284C7);
        break;
      case 'FOUND':
      case 'APPROVED':
      case 'ACTIVE':
        bg = const Color(0xFFDCFCE7); // Soft mint green
        fg = const Color(0xFF10B981);
        break;
      case 'REJECTED':
      case 'SUSPENDED':
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFEF4444);
        break;
      case 'PENDING':
      case 'AVAILABLE':
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFD97706);
        break;
      case 'CLAIMED':
      case 'RESOLVED':
        bg = const Color(0xFFE0E7FF);
        fg = const Color(0xFF4F46E5);
        break;
      default:
        bg = const Color(0xFFF1F5F9);
        fg = const Color(0xFF64748B);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 9 : 12,
        vertical: isSmall ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: isSmall ? 6 : 7,
            height: isSmall ? 6 : 7,
            decoration: BoxDecoration(
              color: fg,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: isSmall ? 5 : 6),
          Text(
            status.toUpperCase(),
            style: GoogleFonts.outfit(
              color: fg,
              fontSize: isSmall ? 10 : 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}


