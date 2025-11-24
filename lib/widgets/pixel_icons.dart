import 'package:flutter/material.dart';

/// Pixel art icons for RPG elements
class PixelIcons {
  // Heart icon (Kindness)
  static Widget heart({Color color = Colors.red, double size = 32}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _HeartPixelPainter(color),
    );
  }

  // Wand/Magic icon (Creativity)
  static Widget wand({Color color = Colors.purple, double size = 32}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _WandPixelPainter(color),
    );
  }

  // Shield icon (Consistency)
  static Widget shield({Color color = Colors.blue, double size = 32}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _ShieldPixelPainter(color),
    );
  }

  // Sword icon (Efficiency)
  static Widget sword({Color color = Colors.orange, double size = 32}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SwordPixelPainter(color),
    );
  }

  // Potion icon (Healing)
  static Widget potion({Color color = Colors.green, double size = 32}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PotionPixelPainter(color),
    );
  }

  // Double hearts icon (Relationship)
  static Widget doubleHearts({Color color = Colors.pink, double size = 32}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DoubleHeartsPixelPainter(color),
    );
  }

  // Trophy icon (Achievement)
  static Widget trophy({Color color = Colors.amber, double size = 32}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _TrophyPixelPainter(color),
    );
  }

  // Star icon (Level/XP)
  static Widget star({Color color = Colors.yellow, double size = 32}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _StarPixelPainter(color),
    );
  }
}

// Pixel art painters
class _HeartPixelPainter extends CustomPainter {
  final Color color;
  _HeartPixelPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 8;
    final paint = Paint()..color = color;
    final borderPaint = Paint()..color = Colors.black;

    // Heart shape in 8x8 pixel grid
    final heartPixels = [
      [0, 0, 1, 1, 0, 1, 1, 0],
      [0, 1, 1, 1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1, 1, 1],
      [0, 1, 1, 1, 1, 1, 1, 0],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [0, 0, 0, 1, 1, 0, 0, 0],
    ];

    _drawPixelArt(canvas, heartPixels, pixelSize, paint, borderPaint);
  }

  @override
  bool shouldRepaint(_HeartPixelPainter oldDelegate) => false;
}

class _WandPixelPainter extends CustomPainter {
  final Color color;
  _WandPixelPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 8;
    final paint = Paint()..color = color;
    final borderPaint = Paint()..color = Colors.black;
    final starPaint = Paint()..color = Colors.yellow;

    // Wand shape
    final wandPixels = [
      [1, 1, 1, 0, 0, 0, 0, 0],
      [1, 2, 1, 0, 0, 0, 0, 0],
      [1, 1, 1, 1, 0, 0, 0, 0],
      [0, 0, 1, 1, 1, 0, 0, 0],
      [0, 0, 0, 1, 1, 1, 0, 0],
      [0, 0, 0, 0, 1, 1, 1, 0],
      [0, 0, 0, 0, 0, 1, 1, 1],
      [0, 0, 0, 0, 0, 0, 1, 1],
    ];

    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        if (wandPixels[y][x] > 0) {
          final pixelPaint = wandPixels[y][x] == 2 ? starPaint : paint;
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
            pixelPaint,
          );
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
            borderPaint
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_WandPixelPainter oldDelegate) => false;
}

class _ShieldPixelPainter extends CustomPainter {
  final Color color;
  _ShieldPixelPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 8;
    final paint = Paint()..color = color;
    final borderPaint = Paint()..color = Colors.black;

    final shieldPixels = [
      [0, 0, 1, 1, 1, 1, 0, 0],
      [0, 1, 1, 1, 1, 1, 1, 0],
      [1, 1, 1, 1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1, 1, 1],
      [0, 1, 1, 1, 1, 1, 1, 0],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [0, 0, 0, 1, 1, 0, 0, 0],
    ];

    _drawPixelArt(canvas, shieldPixels, pixelSize, paint, borderPaint);
  }

  @override
  bool shouldRepaint(_ShieldPixelPainter oldDelegate) => false;
}

class _SwordPixelPainter extends CustomPainter {
  final Color color;
  _SwordPixelPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 8;
    final paint = Paint()..color = color;
    final borderPaint = Paint()..color = Colors.black;
    final handlePaint = Paint()..color = const Color(0xFF8B4513);

    final swordPixels = [
      [0, 0, 0, 0, 0, 1, 1, 0],
      [0, 0, 0, 0, 1, 1, 0, 0],
      [0, 0, 0, 1, 1, 0, 0, 0],
      [0, 0, 1, 1, 0, 0, 0, 0],
      [0, 1, 1, 0, 0, 0, 0, 0],
      [1, 1, 2, 2, 0, 0, 0, 0],
      [0, 2, 2, 2, 0, 0, 0, 0],
      [0, 0, 2, 0, 0, 0, 0, 0],
    ];

    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        if (swordPixels[y][x] > 0) {
          final pixelPaint = swordPixels[y][x] == 2 ? handlePaint : paint;
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
            pixelPaint,
          );
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
            borderPaint
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_SwordPixelPainter oldDelegate) => false;
}

class _PotionPixelPainter extends CustomPainter {
  final Color color;
  _PotionPixelPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 8;
    final paint = Paint()..color = color;
    final borderPaint = Paint()..color = Colors.black;
    final glassPaint = Paint()..color = Colors.white.withOpacity(0.3);

    final potionPixels = [
      [0, 0, 0, 1, 1, 0, 0, 0],
      [0, 0, 0, 1, 1, 0, 0, 0],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [0, 1, 1, 2, 2, 1, 1, 0],
      [0, 1, 1, 2, 2, 1, 1, 0],
      [0, 1, 1, 1, 1, 1, 1, 0],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [0, 0, 0, 1, 1, 0, 0, 0],
    ];

    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        if (potionPixels[y][x] > 0) {
          final pixelPaint = potionPixels[y][x] == 2 ? paint : glassPaint;
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
            pixelPaint,
          );
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
            borderPaint
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_PotionPixelPainter oldDelegate) => false;
}

class _DoubleHeartsPixelPainter extends CustomPainter {
  final Color color;
  _DoubleHeartsPixelPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 8;
    final paint = Paint()..color = color;
    final borderPaint = Paint()..color = Colors.black;

    final heartsPixels = [
      [1, 1, 0, 1, 1, 0, 0, 0],
      [1, 1, 1, 1, 1, 1, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 0],
      [0, 1, 1, 1, 1, 1, 1, 1],
      [0, 0, 1, 1, 1, 1, 1, 0],
      [0, 0, 0, 1, 1, 1, 0, 0],
      [0, 0, 0, 0, 1, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
    ];

    _drawPixelArt(canvas, heartsPixels, pixelSize, paint, borderPaint);
  }

  @override
  bool shouldRepaint(_DoubleHeartsPixelPainter oldDelegate) => false;
}

class _TrophyPixelPainter extends CustomPainter {
  final Color color;
  _TrophyPixelPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 8;
    final paint = Paint()..color = color;
    final borderPaint = Paint()..color = Colors.black;

    final trophyPixels = [
      [1, 0, 0, 1, 1, 0, 0, 1],
      [1, 1, 0, 1, 1, 0, 1, 1],
      [0, 1, 0, 1, 1, 0, 1, 0],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [0, 0, 0, 1, 1, 0, 0, 0],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [0, 1, 1, 1, 1, 1, 1, 0],
    ];

    _drawPixelArt(canvas, trophyPixels, pixelSize, paint, borderPaint);
  }

  @override
  bool shouldRepaint(_TrophyPixelPainter oldDelegate) => false;
}

class _StarPixelPainter extends CustomPainter {
  final Color color;
  _StarPixelPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 8;
    final paint = Paint()..color = color;
    final borderPaint = Paint()..color = Colors.black;

    final starPixels = [
      [0, 0, 0, 1, 1, 0, 0, 0],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 1],
      [0, 1, 1, 1, 1, 1, 1, 0],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [0, 1, 1, 0, 0, 1, 1, 0],
      [1, 1, 0, 0, 0, 0, 1, 1],
    ];

    _drawPixelArt(canvas, starPixels, pixelSize, paint, borderPaint);
  }

  @override
  bool shouldRepaint(_StarPixelPainter oldDelegate) => false;
}

// Helper function to draw pixel art
void _drawPixelArt(
  Canvas canvas,
  List<List<int>> pixels,
  double pixelSize,
  Paint paint,
  Paint borderPaint,
) {
  for (int y = 0; y < pixels.length; y++) {
    for (int x = 0; x < pixels[y].length; x++) {
      if (pixels[y][x] > 0) {
        canvas.drawRect(
          Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
          paint,
        );
        canvas.drawRect(
          Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
          borderPaint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
      }
    }
  }
}
