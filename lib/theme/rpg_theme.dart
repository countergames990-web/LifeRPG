import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// RPG Medieval Theme inspired by fantasy game UI
class RPGTheme {
  // Core Colors - Rich browns and golds
  static const Color darkWood = Color(0xFF2B1810);
  static const Color mediumWood = Color(0xFF4A2511);
  static const Color lightWood = Color(0xFF8B4513);
  static const Color ornateGold = Color(0xFFD4AF37);
  static const Color darkGold = Color(0xFFB8860B);
  
  // Parchment Colors
  static const Color parchment = Color(0xFFF4E8D0);
  static const Color parchmentDark = Color(0xFFE8D7B5);
  static const Color scrollTan = Color(0xFFD2B48C);
  
  // Accent Colors
  static const Color burgundyRed = Color(0xFF8B0000);
  static const Color deepBlue = Color(0xFF1B3A6B);
  static const Color forestGreen = Color(0xFF2D5016);
  static const Color royalPurple = Color(0xFF4B0082);
  
  // Text Colors
  static const Color inkBlack = Color(0xFF1A0F0A);
  static const Color textBrown = Color(0xFF3E2723);
  
  // Attribute Colors (softer, more medieval)
  static const Color kindnessRed = Color(0xFFD32F2F);
  static const Color creativityPurple = Color(0xFF7B1FA2);
  static const Color consistencyBlue = Color(0xFF1976D2);
  static const Color efficiencyOrange = Color(0xFFE65100);
  static const Color healingGreen = Color(0xFF388E3C);
  static const Color loveRose = Color(0xFFC2185B);

  static ThemeData get theme {
    return ThemeData(
      primaryColor: mediumWood,
      scaffoldBackgroundColor: darkWood,
      fontFamily: GoogleFonts.cinzel().fontFamily,
      colorScheme: const ColorScheme.dark(
        primary: ornateGold,
        secondary: darkGold,
        surface: mediumWood,
        background: darkWood,
        onPrimary: inkBlack,
        onSecondary: parchment,
        onSurface: parchment,
        onBackground: parchment,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cinzelDecorative(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: ornateGold,
        ),
        displayMedium: GoogleFonts.cinzelDecorative(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ornateGold,
        ),
        titleLarge: GoogleFonts.cinzel(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: parchment,
        ),
        bodyLarge: GoogleFonts.crimsonText(
          fontSize: 16,
          color: inkBlack,
        ),
        bodyMedium: GoogleFonts.crimsonText(
          fontSize: 14,
          color: textBrown,
        ),
      ),
    );
  }
}

/// Ornate border painter for RPG-style containers
class OrnateBorderPainter extends CustomPainter {
  final Color borderColor;
  final Color? cornerColor;
  
  OrnateBorderPainter({
    this.borderColor = RPGTheme.ornateGold,
    this.cornerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Main border
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Inner border
    canvas.drawRect(
      Rect.fromLTWH(4, 4, size.width - 8, size.height - 8),
      paint..strokeWidth = 1,
    );

    // Corner decorations
    final cornerPaint = Paint()
      ..color = cornerColor ?? borderColor
      ..style = PaintingStyle.fill;

    final cornerSize = 12.0;
    
    // Top-left corner
    _drawCorner(canvas, cornerPaint, Offset.zero, cornerSize, 0);
    // Top-right corner
    _drawCorner(canvas, cornerPaint, Offset(size.width, 0), cornerSize, 1);
    // Bottom-right corner
    _drawCorner(canvas, cornerPaint, Offset(size.width, size.height), cornerSize, 2);
    // Bottom-left corner
    _drawCorner(canvas, cornerPaint, Offset(0, size.height), cornerSize, 3);
  }

  void _drawCorner(Canvas canvas, Paint paint, Offset position, double size, int rotation) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotation * 3.14159 / 2);
    
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size, 0)
      ..lineTo(size, 2)
      ..lineTo(2, 2)
      ..lineTo(2, size)
      ..lineTo(0, size)
      ..close();
    
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Scroll/Parchment container widget
class ScrollContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool showBorder;

  const ScrollContainer({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: showBorder ? OrnateBorderPainter() : null,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? RPGTheme.parchment,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// Medieval text styles
class MedievalText extends StatelessWidget {
  final String text;
  final MedievalTextStyle style;
  final TextAlign? textAlign;
  final Color? color;

  const MedievalText({
    super.key,
    required this.text,
    this.style = MedievalTextStyle.body,
    this.textAlign,
    this.color,
  });

  const MedievalText.title(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
  }) : style = MedievalTextStyle.title;

  const MedievalText.heading(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
  }) : style = MedievalTextStyle.heading;

  const MedievalText.body(
    this.text, {
    super.key,
    this.textAlign,
    this.color,
  }) : style = MedievalTextStyle.body;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;
    
    switch (style) {
      case MedievalTextStyle.title:
        textStyle = GoogleFonts.cinzelDecorative(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: color ?? RPGTheme.ornateGold,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        );
        break;
      case MedievalTextStyle.heading:
        textStyle = GoogleFonts.cinzel(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: color ?? RPGTheme.textBrown,
        );
        break;
      case MedievalTextStyle.body:
        textStyle = GoogleFonts.crimsonText(
          fontSize: 16,
          color: color ?? RPGTheme.inkBlack,
          height: 1.5,
        );
        break;
    }

    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
    );
  }
}

enum MedievalTextStyle {
  title,
  heading,
  body,
}

/// Ornate button widget with hover animations
class OrnateButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const OrnateButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  State<OrnateButton> createState() => _OrnateButtonState();
}

class _OrnateButtonState extends State<OrnateButton> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? RPGTheme.mediumWood;
    final txtColor = widget.textColor ?? RPGTheme.ornateGold;
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            border: Border.all(
              color: _isHovered ? txtColor : RPGTheme.ornateGold,
              width: _isHovered ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _isHovered
                  ? [bgColor, bgColor.withValues(alpha: 0.9)]
                  : [bgColor, bgColor.withValues(alpha: 0.8)],
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? RPGTheme.ornateGold.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.4),
                blurRadius: _isHovered ? 10 : 6,
                offset: Offset(0, _isHovered ? 4 : 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: _isHovered ? RPGTheme.parchment : txtColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      style: GoogleFonts.cinzel(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isHovered ? RPGTheme.parchment : txtColor,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Decorative divider
class MedievalDivider extends StatelessWidget {
  final Color? color;
  
  const MedievalDivider({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  color ?? RPGTheme.ornateGold,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
