# Turnable Page Integration Guide

## Overview
This guide shows how to integrate the `page_flip` package with your Life RPG application for realistic 3D page turning effects.

## Package Used
- **page_flip** (^0.2.5+1): Provides realistic page curl animations with 3D perspective

## What's Been Created

### 1. TurnableBook Widget (`lib/widgets/turnable_book.dart`)
Main widget that wraps the page_flip package with medieval book styling.

**Features:**
- Realistic 3D page curl effect
- Parchment gradient backgrounds
- Medieval-themed "THE END" page
- Customizable controller for programmatic page navigation
- Book-like shadows and depth

### 2. BookSpread Widget
Creates a two-page spread (left and right pages) with:
- Parchment gradients on both pages
- Center binding shadow
- Page numbers at the bottom
- Proper margins and padding

### 3. SingleBookPage Widget
Full-width single page with:
- Parchment texture
- Optional page numbers
- Proper padding

### 4. BookBuilder Helper Class
Utility methods to build book pages easily:
- `buildSpreads()`: Create double-page spreads from lists
- `buildSinglePages()`: Create single pages with numbering

## How to Use

### Basic Usage with Single Pages

```dart
import 'package:flutter/material.dart';
import '../widgets/turnable_book.dart';
import '../widgets/book_page.dart';

class MyBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TurnableBook(
        pages: [
          SingleBookPage(
            pageNumber: 1,
            child: BookPageContent(
              title: 'Chapter 1',
              content: 'Your content here...',
            ),
          ),
          SingleBookPage(
            pageNumber: 2,
            child: BookPageContent(
              title: 'Chapter 2',
              content: 'More content...',
            ),
          ),
        ],
      ),
    );
  }
}
```

### Using Double-Page Spreads

```dart
TurnableBook(
  pages: [
    BookSpread(
      pageNumber: 1,
      leftPage: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookPageHeader(title: 'Profile'),
          // Your left page content
        ],
      ),
      rightPage: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookPageHeader(title: 'Stats'),
          // Your right page content
        ],
      ),
    ),
  ],
)
```

### Using BookBuilder Helper

```dart
// Create spreads from two lists
final pages = BookBuilder.buildSpreads(
  leftPages: [
    ProfileContent(),
    QuestsContent(),
  ],
  rightPages: [
    StatsContent(),
    AchievementsContent(),
  ],
  startPageNumber: 1,
);

TurnableBook(pages: pages)
```

### Programmatic Page Navigation

```dart
class MyBookPage extends StatefulWidget {
  @override
  State<MyBookPage> createState() => _MyBookPageState();
}

class _MyBookPageState extends State<MyBookPage> {
  final _bookController = GlobalKey<PageFlipWidgetState>();

  void nextPage() {
    _bookController.currentState?.nextPage();
  }

  void previousPage() {
    _bookController.currentState?.previousPage();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TurnableBook(
            controller: _bookController,
            pages: myPages,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: previousPage,
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: nextPage,
            ),
          ],
        ),
      ],
    );
  }
}
```

## Integrating with Existing Profile Page

To replace the current `AnimatedFrameBook` in `profile_page.dart`:

### Option 1: Replace Entire Animation System

```dart
// In profile_page.dart

class _ProfilePageState extends State<ProfilePage> {
  final _bookController = GlobalKey<PageFlipWidgetState>();
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TurnableBook(
        controller: _bookController,
        onPageChanged: () {
          setState(() {
            // Track page changes if needed
          });
        },
        pages: [
          // Profile page
          SingleBookPage(
            child: _buildProfileContent(),
          ),
          // Stats page
          SingleBookPage(
            child: _buildStatsContent(),
          ),
          // Story page
          SingleBookPage(
            child: _buildStoryContent(),
          ),
        ],
      ),
    );
  }
}
```

### Option 2: Keep Frame Animation, Add Turnable Pages for Multi-Page Sections

Use `TurnableBook` for sections with multiple pages (like Story), keep `AnimatedFrameBook` for single-page transitions:

```dart
// For story section with multiple pages
Widget _buildStoryBook() {
  final storyPages = gameState.getCurrentCharacter().stories;
  
  return TurnableBook(
    pages: storyPages.map((story) {
      return SingleBookPage(
        child: BookText(story),
      );
    }).toList(),
  );
}
```

## Features of page_flip Package

1. **Touch Gestures**: Swipe to turn pages
2. **Realistic Physics**: 3D page curl with perspective
3. **Smooth Animation**: Natural page turning motion
4. **Customizable**: Background color, duration, shadows
5. **Responsive**: Works on all screen sizes

## Customization Options

### Change Animation Duration
Modify the PageFlipWidget in turnable_book.dart:
```dart
PageFlipWidget(
  duration: Duration(milliseconds: 500), // Faster page turns
  // ... other properties
)
```

### Custom Background
```dart
PageFlipWidget(
  backgroundColor: Colors.brown[900], // Darker wood
  // ... other properties
)
```

### Custom Last Page
Replace the "THE END" page with your own widget:
```dart
TurnableBook(
  lastPage: YourCustomFinalPage(),
  pages: yourPages,
)
```

## Tips

1. **Page Count**: Keep odd numbers of pages for natural book feel (including cover + content + back)
2. **Content Size**: Use SingleChildScrollView inside pages if content might overflow
3. **Responsive Design**: Use MediaQuery to adjust text sizes for different screens
4. **Performance**: Avoid heavy widgets; page_flip renders multiple pages simultaneously
5. **Testing**: Test swipe gestures on mobile/touch devices

## Comparison with AnimatedFrameBook

| Feature | AnimatedFrameBook | TurnableBook |
|---------|------------------|--------------|
| Animation Type | Frame-by-frame PNG | 3D page curl |
| File Size | Large (10 frames) | Small (code only) |
| Realism | Pixel-perfect custom | Standard page curl |
| Customization | High (custom frames) | Medium (colors, timing) |
| Performance | Good | Better |
| Touch Gestures | No | Yes |
| Multiple Pages | No | Yes |

## When to Use Each

**Use TurnableBook when:**
- You want multiple pages in sequence
- You want touch/swipe gestures
- You want realistic page curl physics
- You want better performance

**Use AnimatedFrameBook when:**
- You need pixel-perfect custom animation
- You have specific brand-style frame animation
- Single page transitions only
- You already have frame assets

## Next Steps

1. Test the TurnableBook with simple content
2. Decide: full replacement or hybrid approach
3. Migrate profile_page.dart pages one at a time
4. Test on mobile devices for touch gestures
5. Adjust timing and colors to match your theme

## Example: Complete Profile Book

See `lib/examples/turnable_profile_example.dart` for a complete working example integrating all three profile pages with the turnable book system.
