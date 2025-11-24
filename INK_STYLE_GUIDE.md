# INK-WRITTEN UI STYLE GUIDE

## Overview

The Life RPG UI has been redesigned with an authentic ink-written aesthetic, featuring handwritten fonts, rough edges, ink splatters, and paper textures that create the feeling of a hand-drawn journal or medieval manuscript.

## Design Philosophy

The ink-written style simulates:
- **Handwritten Text**: Using casual script and marker-style fonts
- **Rough Borders**: Hand-drawn edges with natural imperfections
- **Ink Effects**: Splatters, spots, and varying ink densities
- **Paper Texture**: Aged, yellowed paper with subtle grain
- **Organic Feel**: Imperfect lines and spacing for authenticity

---

## Theme Components

### Ink Theme (`lib/theme/ink_theme.dart`)

#### Color Palette

```dart
// Ink Colors
InkTheme.primaryInk      // #1a1a1a - Dark ink
InkTheme.secondaryInk    // #2d2d2d - Slightly lighter
InkTheme.fadeInk         // #666666 - Faded ink
InkTheme.blueInk         // #2c4a7c - Blue ink
InkTheme.brownInk        // #5c4033 - Brown ink

// Paper Colors
InkTheme.paper           // #F9F6F0 - Aged paper
InkTheme.paperDark       // #EBE4D5 - Darker paper
InkTheme.paperYellow     // #FFF8DC - Yellowed paper

// Effects
InkTheme.inkSpot         // #0a0a0a - Solid spot
InkTheme.inkSplatter     // #33000000 - Semi-transparent splatter
```

#### Typography Styles

All fonts use Google Fonts for handwritten aesthetics:

```dart
InkTheme.inkHeading      // Caveat, 48px, bold - Large titles
InkTheme.inkSubheading   // Caveat, 32px, w600 - Section headers
InkTheme.inkBody         // Shadows Into Light, 18px - Body text
InkTheme.inkBodySmall    // Shadows Into Light, 16px - Small text
InkTheme.inkLabel        // Permanent Marker, 14px - Labels/tags
InkTheme.inkNumber       // Caveat, 36px, bold - Numbers/stats
InkTheme.inkScript       // Dancing Script, 24px - Decorative text
```

---

## Widgets Library

### 1. InkText - Handwritten Text

Basic text widget with ink styling:

```dart
// Basic body text
InkText('Your text here')

// Heading style
InkText.heading('Chapter Title')

// Subheading style
InkText.subheading('Section Header')

// Body text
InkText.body('Regular paragraph text')

// Script style (decorative)
InkText.script('Fancy cursive text')

// Custom style
InkText(
  'Custom text',
  style: InkTheme.inkNumber,
  textAlign: TextAlign.center,
)
```

**Features:**
- Automatic handwritten font application
- Multiple pre-defined styles
- Supports all Text widget properties

---

### 2. InkContainer - Hand-Drawn Borders

Container with rough, hand-drawn border effect:

```dart
InkContainer(
  padding: EdgeInsets.all(16),
  child: InkText.body('Content here'),
)

// Without border
InkContainer(
  showBorder: false,
  backgroundColor: InkTheme.paperYellow,
  child: YourWidget(),
)

// Custom size
InkContainer(
  width: 200,
  height: 100,
  child: Center(child: InkText('Box')),
)
```

**Features:**
- Rough, imperfect borders
- Paper background color
- Subtle drop shadow
- Toggle border visibility
- Custom dimensions

**Visual Effect:**
- Border lines have slight waves/roughness (±1.5px variation)
- Corners are not perfectly square
- Simulates pen-drawn rectangle

---

### 3. InkDivider - Hand-Drawn Line

Decorative divider with ink line effect:

```dart
// Basic divider
InkDivider()

// Custom color and spacing
InkDivider(
  color: InkTheme.blueInk,
  height: 3,
  indent: 20,
  endIndent: 20,
)
```

**Features:**
- Wavy, imperfect line
- Customizable color and thickness
- Indent support for margins
- Simulates pen stroke

---

### 4. InkSplatter - Ink Spot Decoration

Decorative ink splatter/blot element:

```dart
// Basic splatter
InkSplatter()

// Custom size and color
InkSplatter(
  size: 30,
  color: InkTheme.inkSpot,
)

// Positioned splatter
Positioned(
  top: 10,
  right: 10,
  child: InkSplatter(size: 15),
)
```

**Features:**
- Main splatter blob
- Small surrounding drips
- Organic, random appearance
- Perfect for decorative accents

**Use Cases:**
- Corner decorations
- Random page elements
- Artistic accents
- Breaking up whitespace

---

## Implementation Examples

### Example 1: Ink-Styled Header

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    InkText.heading('Life RPG'),
    SizedBox(height: 8),
    InkDivider(),
    SizedBox(height: 16),
    InkText.subheading('Character Profile'),
  ],
)
```

### Example 2: Stat Box with Ink Style

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
      SizedBox(height: 8),
      InkDivider(indent: 10, endIndent: 10),
      SizedBox(height: 8),
      InkText.bodySmall('Max capacity increased!'),
    ],
  ),
)
```

### Example 3: Decorative Title with Splatters

```dart
Stack(
  children: [
    Center(
      child: InkText.heading('Chapter I'),
    ),
    Positioned(
      top: 0,
      right: 20,
      child: InkSplatter(size: 12),
    ),
    Positioned(
      bottom: 5,
      left: 30,
      child: InkSplatter(size: 8, color: InkTheme.fadeInk),
    ),
  ],
)
```

### Example 4: Story Entry

```dart
InkContainer(
  backgroundColor: InkTheme.paperYellow,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkText.script('Day 42 - The Quest Begins'),
      SizedBox(height: 12),
      InkDivider(),
      SizedBox(height: 12),
      InkText.body(
        'Today we embarked on a grand adventure...',
      ),
      SizedBox(height: 20),
      InkSplatter(size: 15),
    ],
  ),
)
```

---

## Font Requirements

The following Google Fonts are used:

1. **Caveat** - Casual handwriting for headings
2. **Shadows Into Light** - Readable handwriting for body text  
3. **Permanent Marker** - Bold marker style for labels
4. **Dancing Script** - Elegant cursive for decorative text

These are loaded via the `google_fonts` package (already in dependencies).

---

## Customization Tips

### Creating Custom Ink Text Styles

```dart
Text(
  'Custom Ink Text',
  style: GoogleFonts.caveat(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: InkTheme.blueInk,
    letterSpacing: 2.0,
  ),
)
```

### Adjusting Border Roughness

Edit `InkBorderPainter` in `ink_theme.dart`:

```dart
const roughness = 2.5; // Increase for more imperfection
```

### Changing Paper Texture

Modify background colors:

```dart
InkContainer(
  backgroundColor: InkTheme.paperYellow.withOpacity(0.8),
  // ... 
)
```

### Adding More Ink Effects

The `InkSplatterPainter` can be modified to:
- Add more drips
- Change splatter shape
- Vary opacity
- Create unique patterns

---

## Design Best Practices

### DO:
✅ Use InkText for all user-facing text  
✅ Combine containers and dividers for structure  
✅ Add occasional splatters for authenticity  
✅ Use varying text styles (heading/body/script)  
✅ Leave whitespace - don't overcrowd  

### DON'T:
❌ Mix ink styles with standard Material Design  
❌ Overuse splatters (becomes cluttered)  
❌ Make text too small (handwriting needs space)  
❌ Use perfectly straight lines (ruins the effect)  
❌ Forget about readability in favor of style  

---

## Accessibility Considerations

While the ink style is decorative:

1. **Contrast**: Ensure dark ink on light paper (passes WCAG)
2. **Font Size**: Keep minimum at 16px for readability
3. **Line Height**: Use 1.5-1.6 for comfortable reading
4. **Spacing**: Extra padding compensates for handwritten text

---

## Migration Guide

### Converting Existing Widgets

**Before (Material):**
```dart
Text('Hello', style: TextStyle(fontSize: 24))
Container(
  decoration: BoxDecoration(border: Border.all()),
  child: Text('Content'),
)
```

**After (Ink Style):**
```dart
InkText.subheading('Hello')
InkContainer(
  child: InkText.body('Content'),
)
```

### Replacing Dividers

**Before:**
```dart
Divider(color: Colors.grey)
```

**After:**
```dart
InkDivider()
```

---

## Performance Notes

- **Custom Painters**: InkBorderPainter and InkLinePainter are cached (shouldn't repaint)
- **Google Fonts**: Fonts are cached after first load
- **No Animations**: Static drawing for better performance
- **Web-Friendly**: All effects work smoothly on web platform

---

## Future Enhancements

Potential additions to the ink theme:

1. **Animated Ink Writing**: Text that appears to be written in real-time
2. **Ink Drip Effects**: Dripping animation for decorative elements
3. **Paper Curl**: 3D page curl at edges
4. **Burn Marks**: Aged paper with burnt edges
5. **Wax Seal**: Medieval stamp decorations
6. **Quill Cursor**: Custom cursor that looks like a quill pen

---

## References

- `lib/theme/ink_theme.dart` - Complete theme implementation
- `lib/pages/video_intro_page.dart` - Video integration example
- Google Fonts Documentation: https://fonts.google.com

---

## Support

The ink theme system is designed to be:
- **Modular**: Easy to add new styles
- **Extensible**: Build custom painters on the foundation
- **Reusable**: All widgets work across the app
- **Maintainable**: Centralized theme configuration

For questions or custom implementations, refer to the `InkTheme` class and custom painter implementations.
