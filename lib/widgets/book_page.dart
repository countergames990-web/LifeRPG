import 'package:flutter/material.dart';
import '../theme/medieval_theme.dart';

/// A book page with authentic parchment texture and proper book margins
class BookPage extends StatelessWidget {
  final Widget child;
  final bool isLeftPage;
  final EdgeInsets? customPadding;

  const BookPage({
    super.key,
    required this.child,
    this.isLeftPage = true,
    this.customPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Parchment background with subtle gradient for depth
        gradient: LinearGradient(
          begin: isLeftPage ? Alignment.centerLeft : Alignment.centerRight,
          end: isLeftPage ? Alignment.centerRight : Alignment.centerLeft,
          colors: [
            MedievalColors.parchment,
            MedievalColors.parchmentAged,
            MedievalColors.parchment,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        // Subtle shadow on page edge (binding side)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(isLeftPage ? 3 : -3, 0),
            blurRadius: 8,
          ),
        ],
      ),
      child: Container(
        // Inner padding - proper book margins
        padding:
            customPadding ??
            EdgeInsets.only(
              left: isLeftPage ? 40 : 24, // Wider margin on binding side
              right: isLeftPage ? 24 : 40,
              top: 32,
              bottom: 32,
            ),
        decoration: BoxDecoration(
          // Subtle paper texture using noise pattern
          border: Border(
            left: isLeftPage
                ? BorderSide.none
                : BorderSide(color: MedievalColors.pageEdge, width: 1),
            right: isLeftPage
                ? BorderSide(color: MedievalColors.pageEdge, width: 1)
                : BorderSide.none,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Book page header (chapter title style)
class BookPageHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? color;

  const BookPageHeader({super.key, required this.title, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 32, color: color ?? MedievalColors.gold),
          const SizedBox(height: 8),
        ],
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color ?? MedievalColors.inkBlack,
            letterSpacing: 2,
            height: 1.2,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Decorative line under title
        Container(
          height: 2,
          width: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color ?? MedievalColors.gold, Colors.transparent],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Book page section (like a paragraph or section in a real book)
class BookPageSection extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsets? padding;

  const BookPageSection({
    super.key,
    this.title,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: MedievalColors.inkBrown,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
          ],
          child,
        ],
      ),
    );
  }
}

/// Book-style text (paragraph)
class BookText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign textAlign;

  const BookText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? MedievalColors.inkBrown,
        height: 1.6, // Proper line spacing for readability
        letterSpacing: 0.3,
      ),
      textAlign: textAlign,
    );
  }
}

/// Decorative divider (like in old books)
class BookDivider extends StatelessWidget {
  final double width;
  final Color? color;

  const BookDivider({super.key, this.width = 100, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOrnament(),
            Container(
              width: width,
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    color ?? MedievalColors.gold,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            _buildOrnament(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrnament() {
    return Icon(
      Icons.auto_fix_high,
      size: 12,
      color: color ?? MedievalColors.gold,
    );
  }
}

/// Book cover widget
class BookCover extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const BookCover({super.key, required this.title, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // Leather texture
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              MedievalColors.leather,
              MedievalColors.woodDark,
              MedievalColors.leather,
            ],
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: MedievalColors.gold, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(8, 8),
              blurRadius: 16,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Corner decorations
            Positioned(top: 16, left: 16, child: _buildCornerDecoration()),
            Positioned(
              top: 16,
              right: 16,
              child: Transform.rotate(
                angle: 1.5708, // 90 degrees
                child: _buildCornerDecoration(),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Transform.rotate(
                angle: -1.5708, // -90 degrees
                child: _buildCornerDecoration(),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Transform.rotate(
                angle: 3.14159, // 180 degrees
                child: _buildCornerDecoration(),
              ),
            ),

            // Title
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: MedievalColors.gold,
                      letterSpacing: 4,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.7),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 16,
                        color: MedievalColors.gold.withOpacity(0.8),
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerDecoration() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: MedievalColors.gold, width: 2),
          left: BorderSide(color: MedievalColors.gold, width: 2),
        ),
      ),
    );
  }
}
