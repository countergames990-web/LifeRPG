import 'package:flutter/material.dart';
import '../theme/medieval_theme.dart';

/// Frame-by-frame animated book with content fade transitions
class AnimatedFrameBook extends StatefulWidget {
  final Widget leftPage;
  final Widget rightPage;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final bool showNavigation;
  final List<String>? bookFramePaths; // Paths to animation frames
  final String? staticBookPath; // Static book background

  const AnimatedFrameBook({
    super.key,
    required this.leftPage,
    required this.rightPage,
    this.onPreviousPage,
    this.onNextPage,
    this.showNavigation = true,
    this.bookFramePaths,
    this.staticBookPath,
  });

  @override
  State<AnimatedFrameBook> createState() => _AnimatedFrameBookState();
}

class _AnimatedFrameBookState extends State<AnimatedFrameBook>
    with TickerProviderStateMixin {
  late AnimationController _frameController;
  late AnimationController _fadeController;
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _fadeInAnimation;

  int _currentFrame = 0;
  bool _isAnimating = false;

  bool _hoverLeftArrow = false;
  bool _hoverRightArrow = false;

  // Store current page content
  Widget? _displayLeftPage;
  Widget? _displayRightPage;

  @override
  void initState() {
    super.initState();

    _displayLeftPage = widget.leftPage;
    _displayRightPage = widget.rightPage;

    // Frame animation controller (for frame-by-frame)
    _frameController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Fade animation controller (for content fade)
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    _frameController.addListener(() {
      if (widget.bookFramePaths != null && widget.bookFramePaths!.isNotEmpty) {
        final totalFrames = widget.bookFramePaths!.length;
        final frameIndex = (_frameController.value * totalFrames).floor();
        if (frameIndex != _currentFrame && frameIndex < totalFrames) {
          setState(() {
            _currentFrame = frameIndex;
          });
        }
      }
    });

    _frameController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reset frame controller for next animation
        _frameController.reset();
        setState(() {
          _currentFrame = 0;
        });
      }
    });

    _fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animation complete, reset state
        _fadeController.reset();
        setState(() {
          _isAnimating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _frameController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handlePageFlip(bool isNext) async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    // Start both animations together
    _fadeController.forward();

    if (widget.bookFramePaths != null && widget.bookFramePaths!.isNotEmpty) {
      _frameController.forward();
    }

    // Wait for fade out to complete
    await Future.delayed(const Duration(milliseconds: 200));

    // Trigger the page change callback
    if (isNext && widget.onNextPage != null) {
      widget.onNextPage!();
    } else if (!isNext && widget.onPreviousPage != null) {
      widget.onPreviousPage!();
    }

    // Give a tiny delay for Flutter to rebuild with new content
    await Future.delayed(const Duration(milliseconds: 50));

    // Update displayed content after callback
    if (mounted) {
      setState(() {
        _displayLeftPage = widget.leftPage;
        _displayRightPage = widget.rightPage;
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedFrameBook oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update displayed pages when widget updates
    if (!_isAnimating) {
      setState(() {
        _displayLeftPage = widget.leftPage;
        _displayRightPage = widget.rightPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200, maxHeight: 700),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildBookWithFrames(),
            if (widget.showNavigation) ...[
              if (widget.onPreviousPage != null) _buildPixelArrow(true),
              if (widget.onNextPage != null) _buildPixelArrow(false),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookWithFrames() {
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
      child: Stack(
        children: [
          // Book background (static or animated frames)
          _buildBookBackground(),

          // Page content with fade animation
          AnimatedBuilder(
            animation: _fadeController,
            builder: (context, child) {
              final opacity = _fadeController.isAnimating
                  ? (_fadeController.value < 0.5
                        ? _fadeOutAnimation.value
                        : _fadeInAnimation.value)
                  : 1.0;

              return Opacity(opacity: opacity, child: child);
            },
            child: _buildPageContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookBackground() {
    // If we have frames and animation is running, show frames
    if (widget.bookFramePaths != null &&
        widget.bookFramePaths!.isNotEmpty &&
        _isAnimating &&
        _currentFrame < widget.bookFramePaths!.length) {
      return Image.asset(
        widget.bookFramePaths![_currentFrame],
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading frame $_currentFrame: $error');
          return _buildStaticBackground();
        },
      );
    }

    // Show static background when not animating
    return _buildStaticBackground();
  }

  Widget _buildStaticBackground() {
    // Use static background
    if (widget.staticBookPath != null) {
      return Image.asset(
        widget.staticBookPath!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading static book: $error');
          return _buildFallbackBackground();
        },
      );
    }

    return _buildFallbackBackground();
  }

  Widget _buildFallbackBackground() {
    // Fallback to custom painted background
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF8B7B8B), const Color(0xFF6B5B6B)],
        ),
      ),
    );
  }

  Widget _buildPageContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
      child: Row(
        children: [
          // Left page with book texture
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFFF7F3E8), // Parchment
                    const Color(0xFFEEE4D0),
                    const Color(0xFFF7F3E8),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(2, 0),
                    blurRadius: 4,
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(32, 24, 20, 24),
              child: _displayLeftPage ?? widget.leftPage,
            ),
          ),
          // Center binding gap
          Container(
            width: 24,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.transparent,
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
          ),
          // Right page with book texture
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    const Color(0xFFF7F3E8), // Parchment
                    const Color(0xFFEEE4D0),
                    const Color(0xFFF7F3E8),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(-2, 0),
                    blurRadius: 4,
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 24, 32, 24),
              child: _displayRightPage ?? widget.rightPage,
            ),
          ),
        ],
      ),
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
