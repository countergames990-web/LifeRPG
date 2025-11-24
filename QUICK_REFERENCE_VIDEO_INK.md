# QUICK REFERENCE - Video & Ink Style

## Video Intro

### Add Video File
```
assets/videos/book_intro.mp4
```

### Video Specs
- **Format**: MP4 (H.264)
- **Size**: 1920x1080
- **Duration**: 3-10 sec
- **File Size**: 2-5 MB

### How It Works
```
Select Character → Video Plays → Game Loads
                      ↓
                 Skip button (optional)
```

---

## Ink Style Widgets

### Text Styles

```dart
// Large title
InkText.heading('Title')

// Section header  
InkText.subheading('Section')

// Body text
InkText.body('Paragraph text')

// Decorative cursive
InkText.script('Fancy text')
```

### Containers

```dart
// With border
InkContainer(
  child: Widget(),
)

// No border
InkContainer(
  showBorder: false,
  child: Widget(),
)
```

### Dividers

```dart
// Basic line
InkDivider()

// With spacing
InkDivider(
  indent: 20,
  endIndent: 20,
)
```

### Decorations

```dart
// Ink splatter
InkSplatter()

// Custom size
InkSplatter(size: 30)
```

---

## Colors

```dart
InkTheme.primaryInk     // #1a1a1a (dark)
InkTheme.blueInk        // #2c4a7c (blue)
InkTheme.brownInk       // #5c4033 (brown)
InkTheme.fadeInk        // #666666 (gray)
InkTheme.paper          // #F9F6F0 (aged)
InkTheme.paperYellow    // #FFF8DC (yellow)
```

---

## Fonts Used

- **Caveat** - Headings (casual handwriting)
- **Shadows Into Light** - Body text
- **Permanent Marker** - Labels (bold)
- **Dancing Script** - Decorative (cursive)

---

## Common Patterns

### Stat Box
```dart
InkContainer(
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkText.body('Strength'),
          InkText.number('18'),
        ],
      ),
      InkDivider(),
    ],
  ),
)
```

### Page Header
```dart
Column(
  children: [
    InkText.heading('Life RPG'),
    InkDivider(),
    InkText.subheading('Character'),
  ],
)
```

### Story Entry
```dart
InkContainer(
  backgroundColor: InkTheme.paperYellow,
  child: Column(
    children: [
      InkText.script('Day 42'),
      InkDivider(),
      InkText.body('Quest begins...'),
      InkSplatter(size: 15),
    ],
  ),
)
```

---

## Testing Commands

```bash
# Install packages
flutter pub get

# Run on web
flutter run -d chrome

# Run on all platforms
flutter run

# Clean build
flutter clean
flutter pub get
flutter run
```

---

## File Locations

```
lib/
├── pages/
│   └── video_intro_page.dart      # Video player
└── theme/
    └── ink_theme.dart              # Ink widgets

assets/
└── videos/
    └── book_intro.mp4              # Your video

Documentation:
├── VIDEO_INTRO_GUIDE.md            # Video details
├── INK_STYLE_GUIDE.md              # Style details
└── RECENT_UPDATES.md               # Overview
```

---

## Quick Migration

### Replace Text
```dart
// Before
Text('Hello', style: TextStyle(fontSize: 24))

// After
InkText.subheading('Hello')
```

### Replace Container
```dart
// Before
Container(
  decoration: BoxDecoration(border: Border.all()),
  child: Text('Content'),
)

// After
InkContainer(
  child: InkText.body('Content'),
)
```

### Replace Divider
```dart
// Before
Divider(color: Colors.grey)

// After
InkDivider()
```

---

## Import Statements

```dart
// For video page
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

// For ink theme
import '../theme/ink_theme.dart';

// For ink text styles
import 'package:google_fonts/google_fonts.dart';
```

---

## Troubleshooting

### Video not found?
- Check: `assets/videos/book_intro.mp4` exists
- Run: `flutter clean && flutter pub get`

### Fonts not loading?
- Check internet connection
- Restart app (fonts cache)

### Border not showing?
- Set `showBorder: true` explicitly

---

**Ready to use! 🚀**

For full documentation, see:
- VIDEO_INTRO_GUIDE.md
- INK_STYLE_GUIDE.md
