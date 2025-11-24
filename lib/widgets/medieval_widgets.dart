import 'package:flutter/material.dart';
import '../theme/medieval_theme.dart';

/// Medieval-styled container with ornate borders
class MedievalBorderBox extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double borderWidth;

  const MedievalBorderBox({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.borderWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? MedievalColors.parchmentLight,
        border: Border.all(color: MedievalColors.woodDark, width: borderWidth),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Corner decorations
          Positioned(top: 0, left: 0, child: _buildCornerDecoration()),
          Positioned(
            top: 0,
            right: 0,
            child: Transform.rotate(
              angle: 1.5708, // 90 degrees
              child: _buildCornerDecoration(),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Transform.rotate(
              angle: 3.14159, // 180 degrees
              child: _buildCornerDecoration(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Transform.rotate(
              angle: 4.71239, // 270 degrees
              child: _buildCornerDecoration(),
            ),
          ),
          // Content
          Padding(padding: padding ?? const EdgeInsets.all(16.0), child: child),
        ],
      ),
    );
  }

  Widget _buildCornerDecoration() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: MedievalColors.gold,
        border: Border.all(color: MedievalColors.darkGold, width: 1),
      ),
    );
  }
}

/// 8-bit style progress bar
class PixelProgressBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color barColor;
  final double height;

  const PixelProgressBar({
    super.key,
    required this.label,
    required this.value,
    this.maxValue = 100,
    required this.barColor,
    this.height = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (value / maxValue).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: MedievalColors.inkBlack,
              ),
            ),
            Text(
              '$value / $maxValue',
              style: TextStyle(fontSize: 12, color: MedievalColors.inkBrown),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: MedievalColors.woodDark, width: 2),
          ),
          child: Stack(
            children: [
              // Background grid pattern (8-bit style)
              Container(
                decoration: BoxDecoration(color: MedievalColors.parchmentDark),
              ),
              // Progress fill
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: barColor,
                    border: Border(
                      right: BorderSide(
                        color: barColor.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              // Pixel grid overlay
              ...List.generate(
                10,
                (index) => Positioned(
                  left: (index * 10) % 100,
                  child: Container(
                    width: 1,
                    height: height,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Medieval-styled button
class MedievalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final double? width;

  const MedievalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 48,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: const Offset(4, 4),
            blurRadius: 0, // Pixel-perfect shadow
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? MedievalColors.wood,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Sharp pixel corners
            side: BorderSide(color: MedievalColors.inkBlack, width: 4),
          ),
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Decorative header text
class MedievalHeader extends StatelessWidget {
  final String text;
  final double fontSize;

  const MedievalHeader({super.key, required this.text, this.fontSize = 32});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: MedievalColors.woodDark,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: MedievalColors.gold,
          letterSpacing: 2,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
