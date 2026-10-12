import 'package:flutter/material.dart';
import '../config/app_theme.dart';

/// Reusable Loading State Widget
class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppTheme.accentCyan),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}
