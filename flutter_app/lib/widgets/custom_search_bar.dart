import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';

/// Reusable Search Bar with Filter button conforming to Figma design
class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Search items, tags, buildings...',
    this.onChanged,
    this.onFilterTap,
    this.controller,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppTheme.borderSubtle, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        style: GoogleFonts.inter(color: AppTheme.textMain, fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(color: AppTheme.textSubtle, fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textSubtle, size: 22),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller != null && controller!.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppTheme.textSubtle, size: 18),
                  onPressed: () {
                    controller!.clear();
                    if (onChanged != null) onChanged!('');
                  },
                ),
              if (onFilterTap != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: onFilterTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0F7FA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.tune_rounded, color: AppTheme.accentCyan, size: 18),
                    ),
                  ),
                ),
            ],
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
    );
  }
}


