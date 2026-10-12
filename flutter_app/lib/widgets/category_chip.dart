import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';

/// Reusable Category Selection Chip with Figma gradient highlight
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppTheme.borderSubtle,
            width: 1,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x3300D2FF),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  )
                ]
              : const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected ? Colors.white : AppTheme.textMain,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.outfit(
                color: isSelected ? Colors.white : AppTheme.textMain,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


