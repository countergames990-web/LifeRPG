import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/medieval_theme.dart';
import 'medieval_book_painter.dart';

/// Pixelated game-like book with custom painted medieval background
class PixelatedBookContainer extends StatefulWidget {
  final Widget leftPage;
  final Widget rightPage;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final bool showNavigation;

  const PixelatedBookContainer({
    super.key,
    required this.leftPage,
    required this.rightPage,
    this.onPreviousPage,
    this.onNextPage,
    this.showNavigation = true,
  });

  @override
  State<PixelatedBookContainer> createState() => _PixelatedBookContainerState();
}

class _PixelatedBookContainerState extends State<PixelatedBookContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  bool _isFlipping = false;
  bool _flipToNext = true;

  bool _hoverLeftArrow = false;
  bool _hoverRightArrow = false;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOutCubic,
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

  void _handlePageFlip(bool isNext) {
    if (_isFlipping) return;

    setState(() {
      _flipToNext = isNext;
      _isFlipping = true;
    });

    // Trigger callback immediately to update content
    if (isNext && widget.onNextPage != null) {
      widget.onNextPage!();
    } else if (!isNext && widget.onPreviousPage != null) {
      widget.onPreviousPage!();
    }

    // Start animation after content update
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _flipController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 700),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildBookWithBackground(),
            if (widget.showNavigation) ...[
              if (widget.onPreviousPage != null) _buildPixelArrow(true),
              if (widget.onNextPage != null) _buildPixelArrow(false),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookWithBackground() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: CustomPaint(
        painter: MedievalBookPainter(),
        child: _buildBookPages(),
      ),
    );
  }

  Widget _buildBookPages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
      child: Row(
        children: [
          // Left page
          Expanded(
            child: _isFlipping && !_flipToNext
                ? _buildFlippingPage(false)
                : _buildStaticPage(widget.leftPage, true),
          ),
          const SizedBox(width: 40), // Center binding gap
          // Right page
          Expanded(
            child: _isFlipping && _flipToNext
                ? _buildFlippingPage(true)
                : _buildStaticPage(widget.rightPage, false),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticPage(Widget content, bool isLeft) {
    return Container(
      key: ValueKey('${isLeft}_${content.hashCode}'),
      padding: const EdgeInsets.all(20),
      child: content,
    );
  }

  Widget _buildFlippingPage(bool isRightSide) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * pi;
        final isFrontSide = angle < pi / 2;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002)
            ..rotateY(isRightSide ? angle : -angle),
          alignment: isRightSide ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: isFrontSide
                ? (isRightSide ? widget.rightPage : widget.leftPage)
                : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: isRightSide ? widget.leftPage : widget.rightPage,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildPixelArrow(bool isLeft) {
    final isHovered = isLeft ? _hoverLeftArrow : _hoverRightArrow;

    return Positioned(
      left: isLeft ? -30 : null,
      right: !isLeft ? -30 : null,
      top: 0,
      bottom: 0,
      child: Center(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() {
            if (isLeft)
              _hoverLeftArrow = true;
            else
              _hoverRightArrow = true;
          }),
          onExit: (_) => setState(() {
            if (isLeft)
              _hoverLeftArrow = false;
            else
              _hoverRightArrow = false;
          }),
          child: GestureDetector(
            onTap: () => _handlePageFlip(!isLeft),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: isHovered ? 66 : 60,
              height: isHovered ? 66 : 60,
              decoration: BoxDecoration(
                color: isHovered
                    ? MedievalColors.gold
                    : MedievalColors.darkGold,
                border: Border.all(color: MedievalColors.inkBlack, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(4, 4),
                  ),
                  if (isHovered)
                    BoxShadow(
                      color: MedievalColors.gold.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                ],
              ),
              child: Icon(
                isLeft ? Icons.chevron_left : Icons.chevron_right,
                color: MedievalColors.inkBlack,
                size: isHovered ? 36 : 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
