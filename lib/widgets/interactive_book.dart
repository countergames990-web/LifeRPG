import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/medieval_theme.dart';

/// Interactive book container with realistic page flip - NO constant animations
class InteractiveBookContainer extends StatefulWidget {
  final Widget leftPage;
  final Widget rightPage;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final bool showNavigation;

  const InteractiveBookContainer({
    super.key,
    required this.leftPage,
    required this.rightPage,
    this.onPreviousPage,
    this.onNextPage,
    this.showNavigation = true,
  });

  @override
  State<InteractiveBookContainer> createState() =>
      _InteractiveBookContainerState();
}

class _InteractiveBookContainerState extends State<InteractiveBookContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFlipping = false;
  bool _flipDirection = true; // true = next, false = previous

  bool _hoverLeftArrow = false;
  bool _hoverRightArrow = false;
  bool _hoverLeftPage = false;
  bool _hoverRightPage = false;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFlipping = false;
        });
        _flipController.reset();
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  Future<void> _handlePageFlip(bool isNext) async {
    if (_isFlipping) return;

    setState(() {
      _isFlipping = true;
      _flipDirection = isNext;
    });

    _flipController.forward();

    // Delay callback to middle of animation for smoother transition
    await Future.delayed(const Duration(milliseconds: 400));

    if (isNext && widget.onNextPage != null) {
      widget.onNextPage!();
    } else if (!isNext && widget.onPreviousPage != null) {
      widget.onPreviousPage!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 700),
        child: Stack(
          children: [
            _buildWoodenFrame(),
            if (widget.showNavigation) ...[
              if (widget.onPreviousPage != null) _buildNavigationArrow(true),
              if (widget.onNextPage != null) _buildNavigationArrow(false),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWoodenFrame() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MedievalColors.woodLight,
            MedievalColors.wood,
            MedievalColors.woodDark,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: MedievalColors.shadowDark.withOpacity(0.5),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // Left page
            Expanded(
              child: AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  if (_isFlipping && !_flipDirection) {
                    // Flipping left (previous)
                    final angle = _flipAnimation.value * pi;
                    return Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(-angle),
                      alignment: Alignment.centerRight,
                      child: angle > pi / 2
                          ? Transform(
                              transform: Matrix4.identity()..rotateY(pi),
                              alignment: Alignment.center,
                              child: child,
                            )
                          : child,
                    );
                  }
                  return child!;
                },
                child: MouseRegion(
                  onEnter: (_) => setState(() => _hoverLeftPage = true),
                  onExit: (_) => setState(() => _hoverLeftPage = false),
                  child: _buildPage(widget.leftPage, isLeftPage: true),
                ),
              ),
            ),

            // Binding
            _buildBinding(),

            // Right page with flip animation
            Expanded(
              child: Stack(
                children: [
                  // Base right page
                  MouseRegion(
                    onEnter: (_) => setState(() => _hoverRightPage = true),
                    onExit: (_) => setState(() => _hoverRightPage = false),
                    child: _buildPage(widget.rightPage, isLeftPage: false),
                  ),

                  // Flipping page overlay
                  if (_isFlipping && _flipDirection)
                    AnimatedBuilder(
                      animation: _flipAnimation,
                      builder: (context, child) {
                        final angle = _flipAnimation.value * pi;

                        return Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                          alignment: Alignment.centerLeft,
                          child: angle < pi / 2
                              ? _buildPage(widget.rightPage, isLeftPage: false)
                              : Transform(
                                  transform: Matrix4.identity()..rotateY(pi),
                                  alignment: Alignment.center,
                                  child: _buildPage(
                                    widget.leftPage,
                                    isLeftPage: true,
                                  ),
                                ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBinding() {
    return Container(
      width: 30,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            MedievalColors.woodDark.withOpacity(0.3),
            MedievalColors.wood,
            MedievalColors.woodDark.withOpacity(0.3),
          ],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 6),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          8,
          (index) => Container(
            width: 4,
            height: 28,
            decoration: BoxDecoration(
              color: MedievalColors.woodDark,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(Widget content, {required bool isLeftPage}) {
    final isHovered = isLeftPage ? _hoverLeftPage : _hoverRightPage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.identity()
        ..translate(0.0, isHovered ? -2.0 : 0.0, 0.0),
      decoration: BoxDecoration(
        color: MedievalColors.parchmentLight,
        borderRadius: BorderRadius.only(
          topLeft: isLeftPage ? const Radius.circular(6) : Radius.zero,
          bottomLeft: isLeftPage ? const Radius.circular(6) : Radius.zero,
          topRight: !isLeftPage ? const Radius.circular(6) : Radius.zero,
          bottomRight: !isLeftPage ? const Radius.circular(6) : Radius.zero,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isHovered ? 0.25 : 0.15),
            blurRadius: isHovered ? 12 : 8,
            offset: Offset(isLeftPage ? -2 : 2, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: isLeftPage ? const Radius.circular(6) : Radius.zero,
          bottomLeft: isLeftPage ? const Radius.circular(6) : Radius.zero,
          topRight: !isLeftPage ? const Radius.circular(6) : Radius.zero,
          bottomRight: !isLeftPage ? const Radius.circular(6) : Radius.zero,
        ),
        child: Stack(
          children: [
            // Subtle texture
            Positioned.fill(child: CustomPaint(painter: ParchmentTexture())),
            // Content
            Padding(padding: const EdgeInsets.all(24.0), child: content),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationArrow(bool isLeft) {
    final isHovered = isLeft ? _hoverLeftArrow : _hoverRightArrow;

    return Positioned(
      left: isLeft ? -20 : null,
      right: !isLeft ? -20 : null,
      top: 0,
      bottom: 0,
      child: Center(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() {
            if (isLeft) {
              _hoverLeftArrow = true;
            } else {
              _hoverRightArrow = true;
            }
          }),
          onExit: (_) => setState(() {
            if (isLeft) {
              _hoverLeftArrow = false;
            } else {
              _hoverRightArrow = false;
            }
          }),
          child: GestureDetector(
            onTap: () => _handlePageFlip(!isLeft),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isHovered ? 60 : 52,
              height: isHovered ? 60 : 52,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: isHovered
                      ? [MedievalColors.gold, MedievalColors.darkGold]
                      : [MedievalColors.darkGold, MedievalColors.wood],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: MedievalColors.woodDark, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isHovered ? 0.4 : 0.3),
                    blurRadius: isHovered ? 15 : 10,
                    offset: Offset(0, isHovered ? 8 : 6),
                  ),
                  if (isHovered)
                    BoxShadow(
                      color: MedievalColors.gold.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Icon(
                isLeft ? Icons.chevron_left : Icons.chevron_right,
                color: MedievalColors.parchmentLight,
                size: isHovered ? 32 : 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ParchmentTexture extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MedievalColors.parchmentDark.withOpacity(0.05)
      ..strokeWidth = 0.3;

    final random = Random(42);

    // Minimal paper fibers - very subtle
    for (int i = 0; i < 80; i++) {
      final x1 = random.nextDouble() * size.width;
      final y1 = random.nextDouble() * size.height;
      final length = random.nextDouble() * 25 + 8;
      final angle = random.nextDouble() * 2 * pi;
      final x2 = x1 + cos(angle) * length;
      final y2 = y1 + sin(angle) * length;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(ParchmentTexture oldDelegate) => false;
}
