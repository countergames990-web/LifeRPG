import 'dart:math';
import 'package:flutter/material.dart';

/// Custom painted medieval book background
class MedievalBookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Purple/brown background
    paint.color = const Color(0xFF8B7B8B);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Left page parchment
    final leftPageRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(40, 40, size.width / 2 - 60, size.height - 80),
      const Radius.circular(4),
    );

    // Right page parchment
    final rightPageRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width / 2 + 20,
        40,
        size.width / 2 - 60,
        size.height - 80,
      ),
      const Radius.circular(4),
    );

    // Draw parchment pages with gradient
    final parchmentGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFFFFFAF0),
        const Color(0xFFF5E6D3),
        const Color(0xFFE8D7C3),
      ],
    );

    paint.shader = parchmentGradient.createShader(leftPageRect.outerRect);
    canvas.drawRRect(leftPageRect, paint);

    paint.shader = parchmentGradient.createShader(rightPageRect.outerRect);
    canvas.drawRRect(rightPageRect, paint);

    // Draw torn edges on pages
    _drawTornEdges(canvas, leftPageRect);
    _drawTornEdges(canvas, rightPageRect);

    // Draw book spine/binding in center
    _drawBookSpine(canvas, size);

    // Draw wooden covers
    _drawWoodenCovers(canvas, size);

    // Draw decorative corners
    _drawDecorativeCorners(canvas, leftPageRect);
    _drawDecorativeCorners(canvas, rightPageRect);

    // Draw page curl shadows
    _drawPageCurlShadows(canvas, leftPageRect, rightPageRect);
  }

  void _drawTornEdges(Canvas canvas, RRect pageRect) {
    final paint = Paint()
      ..color = const Color(0xFFD2B48C).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final random = Random(42);
    final path = Path();

    // Top edge
    path.moveTo(pageRect.left, pageRect.top);
    for (double x = pageRect.left; x < pageRect.right; x += 10) {
      final offset = random.nextDouble() * 3;
      path.lineTo(x, pageRect.top + offset);
    }

    // Right edge
    for (double y = pageRect.top; y < pageRect.bottom; y += 10) {
      final offset = random.nextDouble() * 3;
      path.lineTo(pageRect.right + offset, y);
    }

    canvas.drawPath(path, paint);
  }

  void _drawBookSpine(Canvas canvas, Size size) {
    final spineRect = Rect.fromLTWH(
      size.width / 2 - 20,
      30,
      40,
      size.height - 60,
    );

    // Dark brown/purple spine
    final spineGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        const Color(0xFF5D4E37).withOpacity(0.3),
        const Color(0xFF4A3728),
        const Color(0xFF5D4E37).withOpacity(0.3),
      ],
    );

    final paint = Paint()..shader = spineGradient.createShader(spineRect);
    canvas.drawRect(spineRect, paint);

    // Draw binding rivets
    final rivetPaint = Paint()
      ..color = const Color(0xFF4A3728)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final y = 80 + (i * (size.height - 160) / 7);
      canvas.drawCircle(Offset(size.width / 2, y), 4, rivetPaint);

      // Highlight
      final highlightPaint = Paint()
        ..color = const Color(0xFF8B7653).withOpacity(0.5);
      canvas.drawCircle(Offset(size.width / 2 - 1, y - 1), 2, highlightPaint);
    }
  }

  void _drawWoodenCovers(Canvas canvas, Size size) {
    // Left cover edge
    final leftCoverRect = Rect.fromLTWH(0, 0, 50, size.height);
    final rightCoverRect = Rect.fromLTWH(size.width - 50, 0, 50, size.height);

    final woodGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF6F4E37),
        const Color(0xFF4A3728),
        const Color(0xFF6F4E37),
      ],
    );

    final paint = Paint()..shader = woodGradient.createShader(leftCoverRect);
    canvas.drawRect(leftCoverRect, paint);

    paint.shader = woodGradient.createShader(rightCoverRect);
    canvas.drawRect(rightCoverRect, paint);

    // Add wood grain texture
    _drawWoodGrain(canvas, leftCoverRect);
    _drawWoodGrain(canvas, rightCoverRect);

    // Add golden corner decorations
    _drawGoldenCorners(canvas, leftCoverRect);
    _drawGoldenCorners(canvas, rightCoverRect);
  }

  void _drawWoodGrain(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = const Color(0xFF3A2818).withOpacity(0.3)
      ..strokeWidth = 1;

    final random = Random(123);
    for (double y = rect.top; y < rect.bottom; y += 8) {
      final offset = random.nextDouble() * 5;
      canvas.drawLine(
        Offset(rect.left + offset, y),
        Offset(rect.right - offset, y),
        paint,
      );
    }
  }

  void _drawGoldenCorners(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Top corner
    canvas.drawLine(
      Offset(rect.left + 10, rect.top + 20),
      Offset(rect.left + 10, rect.top + 40),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left + 10, rect.top + 20),
      Offset(rect.right - 10, rect.top + 20),
      paint,
    );

    // Bottom corner
    canvas.drawLine(
      Offset(rect.left + 10, rect.bottom - 20),
      Offset(rect.left + 10, rect.bottom - 40),
      paint,
    );
    canvas.drawLine(
      Offset(rect.left + 10, rect.bottom - 20),
      Offset(rect.right - 10, rect.bottom - 20),
      paint,
    );
  }

  void _drawDecorativeCorners(Canvas canvas, RRect pageRect) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final cornerSize = 20.0;

    // Top-left
    canvas.drawLine(
      Offset(pageRect.left + 10, pageRect.top + 10),
      Offset(pageRect.left + 10 + cornerSize, pageRect.top + 10),
      paint,
    );
    canvas.drawLine(
      Offset(pageRect.left + 10, pageRect.top + 10),
      Offset(pageRect.left + 10, pageRect.top + 10 + cornerSize),
      paint,
    );

    // Top-right
    canvas.drawLine(
      Offset(pageRect.right - 10, pageRect.top + 10),
      Offset(pageRect.right - 10 - cornerSize, pageRect.top + 10),
      paint,
    );
    canvas.drawLine(
      Offset(pageRect.right - 10, pageRect.top + 10),
      Offset(pageRect.right - 10, pageRect.top + 10 + cornerSize),
      paint,
    );

    // Bottom corners
    canvas.drawLine(
      Offset(pageRect.left + 10, pageRect.bottom - 10),
      Offset(pageRect.left + 10 + cornerSize, pageRect.bottom - 10),
      paint,
    );
    canvas.drawLine(
      Offset(pageRect.left + 10, pageRect.bottom - 10),
      Offset(pageRect.left + 10, pageRect.bottom - 10 - cornerSize),
      paint,
    );

    canvas.drawLine(
      Offset(pageRect.right - 10, pageRect.bottom - 10),
      Offset(pageRect.right - 10 - cornerSize, pageRect.bottom - 10),
      paint,
    );
    canvas.drawLine(
      Offset(pageRect.right - 10, pageRect.bottom - 10),
      Offset(pageRect.right - 10, pageRect.bottom - 10 - cornerSize),
      paint,
    );
  }

  void _drawPageCurlShadows(Canvas canvas, RRect leftPage, RRect rightPage) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // Left page shadow (on right side)
    final leftShadowPath = Path()
      ..moveTo(leftPage.right - 5, leftPage.top)
      ..lineTo(leftPage.right + 2, leftPage.top + 10)
      ..lineTo(leftPage.right + 2, leftPage.bottom - 10)
      ..lineTo(leftPage.right - 5, leftPage.bottom)
      ..close();
    canvas.drawPath(leftShadowPath, shadowPaint);

    // Right page shadow (on left side)
    final rightShadowPath = Path()
      ..moveTo(rightPage.left + 5, rightPage.top)
      ..lineTo(rightPage.left - 2, rightPage.top + 10)
      ..lineTo(rightPage.left - 2, rightPage.bottom - 10)
      ..lineTo(rightPage.left + 5, rightPage.bottom)
      ..close();
    canvas.drawPath(rightShadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(MedievalBookPainter oldDelegate) => false;
}
