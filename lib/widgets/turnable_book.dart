import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';
import '../theme/medieval_theme.dart';

/// Interactive turnable book using page_flip package
/// Provides realistic 3D page turning effect
class TurnableBook extends StatefulWidget {
  final List<Widget> pages;
  final VoidCallback? onPageChanged;
  final GlobalKey<PageFlipWidgetState>? controller;

  const TurnableBook({
    super.key,
    required this.pages,
    this.onPageChanged,
    this.controller,
  });

  @override
  State<TurnableBook> createState() => _TurnableBookState();
}

class _TurnableBookState extends State<TurnableBook> {
  final _controller = GlobalKey<PageFlipWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: 5,
          ),
        ],
      ),
      child: PageFlipWidget(
        key: widget.controller ?? _controller,
        backgroundColor: MedievalColors.woodDark,
        lastPage: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [MedievalColors.leather, MedievalColors.woodDark],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_stories, size: 80, color: MedievalColors.gold),
                const SizedBox(height: 24),
                Text(
                  'THE END',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: MedievalColors.gold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your journey continues...',
                  style: TextStyle(
                    fontSize: 16,
                    color: MedievalColors.gold.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
        children: widget.pages.map((page) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  MedievalColors.parchment,
                  MedievalColors.parchmentAged,
                  MedievalColors.parchment,
                ],
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
              ],
            ),
            child: page,
          );
        }).toList(),
      ),
    );
  }
}

/// Pre-built double-page spread for turnable book
class BookSpread extends StatelessWidget {
  final Widget leftPage;
  final Widget rightPage;
  final int pageNumber;

  const BookSpread({
    super.key,
    required this.leftPage,
    required this.rightPage,
    this.pageNumber = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left page
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  MedievalColors.parchment,
                  MedievalColors.parchmentAged,
                  MedievalColors.parchmentLight,
                ],
              ),
              border: Border(
                right: BorderSide(color: MedievalColors.pageEdge, width: 1),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(40, 32, 24, 32),
            child: Column(
              children: [
                Expanded(child: leftPage),
                _buildPageNumber(pageNumber * 2 - 1),
              ],
            ),
          ),
        ),

        // Center binding shadow
        Container(
          width: 16,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.black.withOpacity(0.3),
              ],
            ),
          ),
        ),

        // Right page
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  MedievalColors.parchment,
                  MedievalColors.parchmentAged,
                  MedievalColors.parchmentLight,
                ],
              ),
              border: Border(
                left: BorderSide(color: MedievalColors.pageEdge, width: 1),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 32, 40, 32),
            child: Column(
              children: [
                Expanded(child: rightPage),
                _buildPageNumber(pageNumber * 2),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageNumber(int number) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        '- $number -',
        style: TextStyle(
          fontSize: 12,
          color: MedievalColors.inkBrown.withOpacity(0.5),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

/// Single page for turnable book (used when you need full-width pages)
class SingleBookPage extends StatelessWidget {
  final Widget child;
  final int? pageNumber;
  final bool showPageNumber;

  const SingleBookPage({
    super.key,
    required this.child,
    this.pageNumber,
    this.showPageNumber = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            MedievalColors.parchmentLight,
            MedievalColors.parchment,
            MedievalColors.parchmentAged,
          ],
        ),
      ),
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Expanded(child: child),
          if (showPageNumber && pageNumber != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                '- $pageNumber -',
                style: TextStyle(
                  fontSize: 12,
                  color: MedievalColors.inkBrown.withOpacity(0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Helper to build book pages easily
class BookBuilder {
  /// Create a list of BookSpread widgets from pairs of content
  static List<Widget> buildSpreads({
    required List<Widget> leftPages,
    required List<Widget> rightPages,
    int startPageNumber = 1,
  }) {
    final spreads = <Widget>[];
    final maxLength = leftPages.length > rightPages.length
        ? leftPages.length
        : rightPages.length;

    for (int i = 0; i < maxLength; i++) {
      spreads.add(
        BookSpread(
          leftPage: i < leftPages.length
              ? leftPages[i]
              : Container(), // Empty page if list is shorter
          rightPage: i < rightPages.length ? rightPages[i] : Container(),
          pageNumber: startPageNumber + i,
        ),
      );
    }

    return spreads;
  }

  /// Create single pages
  static List<Widget> buildSinglePages({
    required List<Widget> pages,
    int startPageNumber = 1,
    bool showPageNumbers = true,
  }) {
    return pages.asMap().entries.map((entry) {
      return SingleBookPage(
        pageNumber: showPageNumbers ? startPageNumber + entry.key : null,
        showPageNumber: showPageNumbers,
        child: entry.value,
      );
    }).toList();
  }
}
