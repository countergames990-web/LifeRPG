# INK STYLE MIGRATION CHECKLIST

## Overview

This checklist guides you through converting existing pages to use the ink-written aesthetic.

---

## Step 1: Import the Theme

Add to the top of each file you want to convert:

```dart
import '../theme/ink_theme.dart';
```

✅ Done for:
- [ ] lib/pages/profile_page.dart
- [ ] lib/pages/story_page.dart
- [ ] lib/pages/weekly_stats_page.dart
- [ ] lib/pages/character_selection_page.dart
- [ ] lib/pages/score_update_dialog.dart
- [ ] lib/widgets/book_page.dart

---

## Step 2: Replace Text Widgets

### Find & Replace Patterns

#### Pattern 1: Large Titles
```dart
// FIND:
Text(
  'Title',
  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
)

// REPLACE WITH:
InkText.heading('Title')
```

#### Pattern 2: Section Headers
```dart
// FIND:
Text(
  'Section',
  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
)

// REPLACE WITH:
InkText.subheading('Section')
```

#### Pattern 3: Body Text
```dart
// FIND:
Text('Regular text', style: TextStyle(fontSize: 18))

// REPLACE WITH:
InkText.body('Regular text')
```

#### Pattern 4: Numbers/Stats
```dart
// FIND:
Text('$value', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold))

// REPLACE WITH:
InkText.number('$value')
```

---

## Step 3: Replace Container Widgets

### Basic Container
```dart
// FIND:
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    border: Border.all(),
    color: Colors.white,
  ),
  child: YourWidget(),
)

// REPLACE WITH:
InkContainer(
  child: YourWidget(),
)
```

### Container with Color
```dart
// FIND:
Container(
  decoration: BoxDecoration(
    color: Colors.grey[100],
  ),
  child: YourWidget(),
)

// REPLACE WITH:
InkContainer(
  backgroundColor: InkTheme.paperYellow,
  child: YourWidget(),
)
```

---

## Step 4: Replace Dividers

```dart
// FIND:
Divider(color: Colors.grey)

// REPLACE WITH:
InkDivider()
```

With custom spacing:
```dart
// FIND:
Padding(
  padding: EdgeInsets.symmetric(horizontal: 20),
  child: Divider(),
)

// REPLACE WITH:
InkDivider(indent: 20, endIndent: 20)
```

---

## Step 5: Add Decorative Elements

Add ink splatters to enhance authenticity:

```dart
// In Stack layouts, add:
Positioned(
  top: 10,
  right: 10,
  child: InkSplatter(size: 15),
)
```

Common placement:
- Top-right of headers
- Bottom-right of containers
- Corners of cards
- Between sections (sparingly)

---

## Page-by-Page Guide

### 1. Profile Page (`lib/pages/profile_page.dart`)

#### Header Section
```dart
// Current: Book-style header
// Convert to:
Column(
  children: [
    InkText.heading(character.name),
    InkText.subheading('Level ${character.level} ${character.type}'),
    InkDivider(),
  ],
)
```

#### Stat Boxes
```dart
// Current: BookPageSection widgets
// Convert to:
InkContainer(
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkText.body('Attribute'),
          InkText.number('${value}'),
        ],
      ),
      InkDivider(indent: 20, endIndent: 20),
    ],
  ),
)
```

#### Checklist:
- [ ] Character name → InkText.heading()
- [ ] Level/type info → InkText.subheading()
- [ ] Stat labels → InkText.body()
- [ ] Stat values → InkText.number()
- [ ] Section dividers → InkDivider()
- [ ] Containers → InkContainer()
- [ ] Add 2-3 decorative splatters

---

### 2. Story Page (`lib/pages/story_page.dart`)

#### Story Entries
```dart
// Current: Story cards
// Convert to:
InkContainer(
  backgroundColor: InkTheme.paperYellow,
  child: Stack(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkText.script(storyTitle),
          SizedBox(height: 8),
          InkDivider(),
          SizedBox(height: 8),
          InkText.body(storyContent),
        ],
      ),
      Positioned(
        bottom: 8,
        right: 8,
        child: InkSplatter(size: 12),
      ),
    ],
  ),
)
```

#### Checklist:
- [ ] Story titles → InkText.script()
- [ ] Story content → InkText.body()
- [ ] Timestamps → InkText.bodySmall()
- [ ] Story cards → InkContainer() with paperYellow
- [ ] Add dividers between title and content
- [ ] Add ink splatter to each story card

---

### 3. Weekly Stats Page (`lib/pages/weekly_stats_page.dart`)

#### Day Headers
```dart
// Current: Day labels
// Convert to:
InkText.subheading('Monday')
InkDivider()
```

#### Score Display
```dart
// Current: Score numbers in chart
// Keep chart as-is, but add ink headers:
Column(
  children: [
    InkText.heading('Weekly Progress'),
    InkDivider(),
    SizedBox(height: 16),
    // Keep existing chart widget
    YourChartWidget(),
  ],
)
```

#### Checklist:
- [ ] Page title → InkText.heading()
- [ ] Day labels → InkText.subheading()
- [ ] Score values → InkText.number()
- [ ] Section dividers → InkDivider()
- [ ] Wrap stats in InkContainer()

---

### 4. Character Selection Page (`lib/pages/character_selection_page.dart`)

#### Title
```dart
// Current: 'LIFE RPG' with shadow
// Convert to:
Stack(
  children: [
    InkText.heading('LIFE RPG'),
    Positioned(
      right: 20,
      top: 5,
      child: InkSplatter(size: 25),
    ),
  ],
)
```

#### Character Cards
```dart
// Current: Container with border
// Convert to:
InkContainer(
  child: Column(
    children: [
      // Character icon
      InkText.subheading('Character Name'),
      InkText.body('Type'),
      // Selection button
    ],
  ),
)
```

#### Checklist:
- [ ] Page title → InkText.heading()
- [ ] "Choose Your Character" → InkText.subheading()
- [ ] Character names → InkText.subheading()
- [ ] Character types → InkText.body()
- [ ] Character cards → InkContainer()
- [ ] Add title decoration (splatter)

---

### 5. Score Update Dialog (`lib/pages/score_update_dialog.dart`)

#### Dialog Content
```dart
// Current: Dialog with text
// Convert to:
Dialog(
  backgroundColor: InkTheme.paper,
  child: InkContainer(
    showBorder: false,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkText.heading('Quest Complete!'),
        InkDivider(),
        InkText.body('You gained:'),
        InkText.number('+${score} XP'),
      ],
    ),
  ),
)
```

#### Checklist:
- [ ] Dialog title → InkText.heading()
- [ ] Labels → InkText.body()
- [ ] Score values → InkText.number()
- [ ] Add divider after title
- [ ] Paper background

---

## Step 6: Update Color Scheme

Replace these color references:

```dart
// OLD COLORS → NEW COLORS

Colors.white → InkTheme.paper
Colors.grey[100] → InkTheme.paperYellow
Colors.grey[200] → InkTheme.paperDark
Colors.black → InkTheme.primaryInk
Colors.blue → InkTheme.blueInk
Colors.brown → InkTheme.brownInk
Colors.grey → InkTheme.fadeInk
```

---

## Step 7: Background Updates

### Page Backgrounds
```dart
// In Scaffold:
Scaffold(
  backgroundColor: InkTheme.paper,  // Instead of parchment
  body: YourContent(),
)
```

### Gradient Backgrounds (Optional)
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        InkTheme.paper,
        InkTheme.paperYellow,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  ),
  child: YourContent(),
)
```

---

## Step 8: Button Updates

### From ElevatedButton
```dart
// OLD:
ElevatedButton(
  onPressed: () {},
  child: Text('Button'),
)

// NEW:
GestureDetector(
  onTap: () {},
  child: InkContainer(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    child: InkText.label('BUTTON'),
  ),
)
```

---

## Testing Checklist

After each page conversion:

- [ ] Run app and verify page loads
- [ ] Check all text is readable
- [ ] Verify borders appear correctly
- [ ] Ensure dividers are visible
- [ ] Test on different screen sizes
- [ ] Check color contrast
- [ ] Verify no layout overflow

---

## Common Issues & Fixes

### Issue: Text too small
```dart
// Fix: Increase font size
InkText(
  'Text',
  style: InkTheme.inkBody.copyWith(fontSize: 20),
)
```

### Issue: Border not showing
```dart
// Fix: Ensure showBorder is true
InkContainer(
  showBorder: true,  // Explicit
  child: Widget(),
)
```

### Issue: Too many splatters
```dart
// Fix: Use sparingly (2-3 per page max)
// Remove excessive splatters
```

### Issue: Color contrast poor
```dart
// Fix: Use darker ink on light paper
InkText(
  'Text',
  style: InkTheme.inkBody.copyWith(
    color: InkTheme.primaryInk,  // Darkest ink
  ),
)
```

---

## Priority Order (Recommended)

Convert pages in this order:

1. **Character Selection** (first impression) ⭐
2. **Profile Page** (most used) ⭐⭐
3. **Story Page** (content focus) ⭐⭐
4. **Weekly Stats** (data display)
5. **Score Dialog** (quick win)
6. **Other widgets** (as needed)

---

## Before You Start

- [ ] Read INK_STYLE_GUIDE.md
- [ ] Review INK_VISUAL_EXAMPLES.md
- [ ] Import ink_theme.dart in target file
- [ ] Create backup of original file (optional)
- [ ] Test changes incrementally

---

## After Conversion

- [ ] Remove unused imports (Material theme colors)
- [ ] Clean up commented-out old code
- [ ] Test all interactions
- [ ] Verify responsive layout
- [ ] Check accessibility (contrast)
- [ ] Get feedback on aesthetics

---

## Gradual Approach

Don't convert everything at once! Try this:

**Phase 1: Headers Only**
- Convert all headings to InkText.heading()
- Keep everything else the same
- Test and adjust

**Phase 2: Add Containers**
- Wrap major sections in InkContainer()
- Keep existing text widgets
- Test layout

**Phase 3: Full Conversion**
- Replace all text widgets
- Add dividers
- Add decorative elements
- Final polish

---

## Quick Commands

```bash
# See what needs converting
grep -r "Text(" lib/pages/

# Find containers
grep -r "Container(" lib/pages/

# Find dividers
grep -r "Divider()" lib/pages/
```

---

## Success Criteria

✅ All major text uses InkText variants  
✅ Key sections wrapped in InkContainer  
✅ Dividers replaced with InkDivider  
✅ 2-3 decorative splatters per page  
✅ Consistent color scheme (ink + paper)  
✅ Readable and authentic feel  
✅ No layout issues or overflow  
✅ Responsive across screen sizes  

---

## Final Polish

After conversion, add these finishing touches:

1. **Vary paper backgrounds** - Mix paper, paperYellow, paperDark
2. **Strategic splatters** - Top-right corners, bottom of cards
3. **Ink color variety** - Use blueInk for links, brownInk for dates
4. **Spacing adjustments** - Extra padding for handwritten text
5. **Custom text sizes** - Scale fonts for emphasis

---

**Take your time and convert one page at a time!** ✍️

Each page should take 10-20 minutes to convert. The result is a unique, handcrafted aesthetic that sets your app apart!
