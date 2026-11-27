import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pixel-perfect Google 'G' icon painter rendered with official Google brand colors
class GoogleLogo extends StatelessWidget {
  final double size;
  const GoogleLogo({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final strokeWidth = w * 0.22;
    final radius = w * 0.46;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Red: Top arc (from 195° to 315°)
    arcPaint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, 3.14159 * 1.08, 3.14159 * 0.67, false, arcPaint);

    // Blue: Right arc (-45° to 45°)
    arcPaint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -3.14159 * 0.25, 3.14159 * 0.5, false, arcPaint);

    // Green: Bottom arc (45° to 135°)
    arcPaint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 3.14159 * 0.25, 3.14159 * 0.5, false, arcPaint);

    // Yellow: Bottom-left arc (135° to 195°)
    arcPaint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, 3.14159 * 0.75, 3.14159 * 0.35, false, arcPaint);

    // Blue horizontal bar to center
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(w * 0.44, h * 0.39, w * 0.94, h * 0.61),
        const Radius.circular(1),
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Official Branded Google Sign-In button tailored for SMUCT UI
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.text = 'Continue with Google',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Color(0xFF0284C7),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const GoogleLogo(size: 20),
                      const SizedBox(width: 12),
                      Text(
                        text,
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF0F172A),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
