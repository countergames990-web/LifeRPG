import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Ink-written aesthetic theme for handwritten, rough-edged UI elements
class InkTheme {
  // Ink colors
  static const Color primaryInk = Color(0xFF1a1a1a); // Dark ink
  static const Color secondaryInk = Color(0xFF2d2d2d); // Slightly lighter
  static const Color fadeInk = Color(0xFF666666); // Faded ink
  static const Color blueInk = Color(0xFF2c4a7c); // Blue ink
  static const Color brownInk = Color(0xFF5c4033); // Brown ink

  // Paper colors
  static const Color paper = Color(0xFFF9F6F0); // Aged paper
  static const Color paperDark = Color(0xFFEBE4D5); // Darker paper
  static const Color paperYellow = Color(0xFFFFF8DC); // Yellowed paper

  // Ink spot/splatter colors
  static const Color inkSpot = Color(0xFF0a0a0a);
  static const Color inkSplatter = Color(0x33000000);

  // Text styles with handwritten fonts
  static TextStyle get inkHeading => GoogleFonts.caveat(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: primaryInk,
    height: 1.2,
    letterSpacing: 1.5,
  );

  static TextStyle get inkSubheading => GoogleFonts.caveat(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: primaryInk,
    height: 1.3,
  );

  static TextStyle get inkBody => GoogleFonts.shadowsIntoLight(
    fontSize: 18,
    color: primaryInk,
    height: 1.6,
    letterSpacing: 0.5,
  );

  static TextStyle get inkBodySmall =>
      GoogleFonts.shadowsIntoLight(fontSize: 16, color: fadeInk, height: 1.5);

  static TextStyle get inkLabel => GoogleFonts.permanentMarker(
    fontSize: 14,
    color: secondaryInk,
    letterSpacing: 1.0,
  );

  static TextStyle get inkNumber => GoogleFonts.caveat(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: primaryInk,
  );

  static TextStyle get inkScript => GoogleFonts.dancingScript(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: blueInk,
    height: 1.4,
  );
}

/// Widget that applies ink-written text style
class InkText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? _variantStyle;

  const InkText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : _variantStyle = null;

  InkText.heading(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = null,
       _variantStyle = InkTheme.inkHeading;

  InkText.subheading(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = null,
       _variantStyle = InkTheme.inkSubheading;

  InkText.body(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = null,
       _variantStyle = InkTheme.inkBody;

  InkText.script(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = null,
       _variantStyle = InkTheme.inkScript;

  InkText.label(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : style = null,
       _variantStyle = InkTheme.inkLabel;

  @override
  Widget build(BuildContext context) {
    TextStyle effectiveStyle = style ?? _variantStyle ?? InkTheme.inkBody;

    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Container with ink-drawn rough border effect
class InkContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final bool showBorder;

  const InkContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.width,
    this.height,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: showBorder ? InkBorderPainter() : null,
      child: Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? InkTheme.paper,
          // Slight texture effect
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// Custom painter for rough, hand-drawn border effect
class InkBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = InkTheme.primaryInk
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Create a rough, hand-drawn rectangle with slight imperfections
    const roughness = 1.5;

    // Top line
    path.moveTo(0, roughness);
    for (double x = 0; x < size.width; x += 10) {
      path.lineTo(
        x + (x % 20 == 0 ? roughness : -roughness * 0.5),
        (x % 30 == 0 ? roughness : -roughness * 0.3),
      );
    }
    path.lineTo(size.width, 0);

    // Right line
    for (double y = 0; y < size.height; y += 10) {
      path.lineTo(
        size.width + (y % 20 == 0 ? -roughness : roughness * 0.5),
        y + (y % 30 == 0 ? roughness : -roughness * 0.3),
      );
    }
    path.lineTo(size.width, size.height);

    // Bottom line
    for (double x = size.width; x > 0; x -= 10) {
      path.lineTo(
        x + (x % 20 == 0 ? -roughness : roughness * 0.5),
        size.height + (x % 30 == 0 ? -roughness : roughness * 0.3),
      );
    }
    path.lineTo(0, size.height);

    // Left line
    for (double y = size.height; y > 0; y -= 10) {
      path.lineTo(
        (y % 20 == 0 ? roughness : -roughness * 0.5),
        y + (y % 30 == 0 ? -roughness : roughness * 0.3),
      );
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Decorative ink divider line with imperfections
class InkDivider extends StatelessWidget {
  final double height;
  final Color? color;
  final double indent;
  final double endIndent;

  const InkDivider({
    super.key,
    this.height = 2.0,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: InkLinePainter(
        color: color ?? InkTheme.primaryInk,
        indent: indent,
        endIndent: endIndent,
      ),
    );
  }
}

/// Custom painter for rough, hand-drawn line
class InkLinePainter extends CustomPainter {
  final Color color;
  final double indent;
  final double endIndent;

  InkLinePainter({
    required this.color,
    required this.indent,
    required this.endIndent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(indent, size.height / 2);

    // Draw line with slight waves/imperfections
    for (double x = indent; x < size.width - endIndent; x += 8) {
      final yOffset = (x % 16 == 0 ? 0.5 : -0.5);
      path.lineTo(x, size.height / 2 + yOffset);
    }
    path.lineTo(size.width - endIndent, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Ink splatter/spot decoration widget
class InkSplatter extends StatelessWidget {
  final double size;
  final Color? color;

  const InkSplatter({super.key, this.size = 20, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: InkSplatterPainter(color: color ?? InkTheme.inkSplatter),
    );
  }
}

/// Custom painter for ink splatter effect
class InkSplatterPainter extends CustomPainter {
  final Color color;

  InkSplatterPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    // Main splatter
    canvas.drawCircle(center, size.width / 3, paint);

    // Small drips
    canvas.drawCircle(
      Offset(center.dx + size.width / 4, center.dy - size.height / 4),
      size.width / 8,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx - size.width / 5, center.dy + size.height / 5),
      size.width / 10,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx + size.width / 6, center.dy + size.height / 3),
      size.width / 12,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
