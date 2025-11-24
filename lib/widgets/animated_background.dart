import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/medieval_theme.dart';

/// Animated medieval-themed background with floating particles
class MedievalAnimatedBackground extends StatefulWidget {
  final Widget child;

  const MedievalAnimatedBackground({super.key, required this.child});

  @override
  State<MedievalAnimatedBackground> createState() =>
      _MedievalAnimatedBackgroundState();
}

class _MedievalAnimatedBackgroundState extends State<MedievalAnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // Generate particles
    for (int i = 0; i < 20; i++) {
      _particles.add(
        Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 4 + 2,
          speed: _random.nextDouble() * 0.5 + 0.3,
          phase: _random.nextDouble() * 2 * pi,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MedievalColors.parchment,
                MedievalColors.parchmentLight,
                MedievalColors.parchmentDark,
              ],
            ),
          ),
        ),
        // Animated particles
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: ParticlePainter(
                particles: _particles,
                animationValue: _controller.value,
              ),
              child: Container(),
            );
          },
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double phase;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter({required this.particles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MedievalColors.gold.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      // Calculate position with sine wave movement
      final x =
          particle.x * size.width +
          sin(animationValue * 2 * pi + particle.phase) * 20;
      final y =
          ((particle.y + animationValue * particle.speed) % 1.0) * size.height;

      // Draw particle
      canvas.drawCircle(Offset(x, y), particle.size, paint);

      // Draw subtle glow
      final glowPaint = Paint()
        ..color = MedievalColors.gold.withOpacity(0.05)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(Offset(x, y), particle.size * 2, glowPaint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

/// Parchment texture overlay
class ParchmentTexture extends StatelessWidget {
  final Widget child;

  const ParchmentTexture({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: ParchmentTexturePainter()),
          ),
        ),
      ],
    );
  }
}

class ParchmentTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MedievalColors.woodDark.withOpacity(0.02)
      ..strokeWidth = 1;

    final random = Random(42); // Fixed seed for consistent pattern

    // Draw subtle texture lines
    for (int i = 0; i < 50; i++) {
      final x1 = random.nextDouble() * size.width;
      final y1 = random.nextDouble() * size.height;
      final x2 = x1 + (random.nextDouble() - 0.5) * 20;
      final y2 = y1 + (random.nextDouble() - 0.5) * 20;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(ParchmentTexturePainter oldDelegate) => false;
}
