# Ink Theme Visual Examples

## Before & After Comparisons

### Example 1: Simple Header

#### BEFORE (Material Design)
```dart
Text(
  'Life RPG',
  style: TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
)
```

#### AFTER (Ink Style)
```dart
InkText.heading('Life RPG')
```

**Visual Result:**
- Handwritten Caveat font
- Natural, casual appearance
- Authentic ink-on-paper feel

---

### Example 2: Stat Box

#### BEFORE (Material Design)
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Strength', style: TextStyle(fontSize: 16)),
          Text('18', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
      Divider(),
      Text('Training bonus: +2', style: TextStyle(fontSize: 14)),
    ],
  ),
)
```

#### AFTER (Ink Style)
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
      InkText.bodySmall('Training bonus: +2'),
    ],
  ),
)
```

**Visual Result:**
- Hand-drawn borders with imperfections
- Handwritten text throughout
- Rough divider line
- Paper background texture

---

### Example 3: Story Entry Card

#### BEFORE (Material Design)
```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Day 42 - The Quest Begins',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Divider(),
        SizedBox(height: 8),
        Text(
          'Today we embarked on a grand adventure through the mystical forest...',
          style: TextStyle(fontSize: 16),
        ),
      ],
    ),
  ),
)
```

#### AFTER (Ink Style)
```dart
InkContainer(
  backgroundColor: InkTheme.paperYellow,
  child: Stack(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkText.script('Day 42 - The Quest Begins'),
          SizedBox(height: 12),
          InkDivider(),
          SizedBox(height: 12),
          InkText.body(
            'Today we embarked on a grand adventure through the mystical forest...',
          ),
        ],
      ),
      Positioned(
        bottom: 8,
        right: 8,
        child: InkSplatter(size: 15),
      ),
    ],
  ),
)
```

**Visual Result:**
- Yellowed paper background
- Cursive script for title (Dancing Script)
- Handwritten body text (Shadows Into Light)
- Rough hand-drawn border
- Decorative ink splatter in corner
- Organic, journal-like feel

---

### Example 4: Character Profile Header

#### BEFORE (Material Design)
```dart
Column(
  children: [
    CircleAvatar(
      radius: 50,
      child: Icon(Icons.person, size: 50),
    ),
    SizedBox(height: 16),
    Text(
      'Sir Adventurer',
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    ),
    Text(
      'Level 12 Warrior',
      style: TextStyle(fontSize: 16, color: Colors.grey),
    ),
    Divider(),
  ],
)
```

#### AFTER (Ink Style)
```dart
InkContainer(
  backgroundColor: InkTheme.paper,
  child: Column(
    children: [
      Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: InkTheme.paperDark,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, size: 50, color: InkTheme.primaryInk),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: InkSplatter(size: 12),
          ),
        ],
      ),
      SizedBox(height: 16),
      InkText.heading('Sir Adventurer'),
      InkText.bodySmall('Level 12 Warrior'),
      SizedBox(height: 12),
      InkDivider(),
    ],
  ),
)
```

**Visual Result:**
- Hand-drawn container border
- Large handwritten name (Caveat)
- Smaller handwritten level (Shadows Into Light)
- Decorative ink splatter
- Wavy divider line

---

### Example 5: Button/Action

#### BEFORE (Material Design)
```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  ),
  child: Text('Start Quest'),
)
```

#### AFTER (Ink Style)
```dart
InkContainer(
  backgroundColor: InkTheme.paperYellow,
  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  child: InkText.label('START QUEST'),
)
```

**Visual Result:**
- Hand-drawn border (clickable container)
- Bold marker-style text (Permanent Marker)
- Paper background
- Organic button appearance

---

### Example 6: List of Stats

#### BEFORE (Material Design)
```dart
Column(
  children: [
    ListTile(
      title: Text('Strength'),
      trailing: Text('18'),
    ),
    Divider(),
    ListTile(
      title: Text('Intelligence'),
      trailing: Text('14'),
    ),
    Divider(),
    ListTile(
      title: Text('Dexterity'),
      trailing: Text('16'),
    ),
  ],
)
```

#### AFTER (Ink Style)
```dart
InkContainer(
  child: Column(
    children: [
      _buildStatRow('Strength', '18'),
      InkDivider(indent: 20, endIndent: 20),
      _buildStatRow('Intelligence', '14'),
      InkDivider(indent: 20, endIndent: 20),
      _buildStatRow('Dexterity', '16'),
    ],
  ),
)

Widget _buildStatRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkText.body(label),
        InkText.number(value),
      ],
    ),
  );
}
```

**Visual Result:**
- Hand-drawn container border
- Handwritten stat names
- Bold handwritten numbers
- Rough dividers with indents
- Journal/character sheet appearance

---

## Color Usage Examples

### Paper Backgrounds

```dart
// Aged paper (default)
InkContainer(
  backgroundColor: InkTheme.paper,  // #F9F6F0
  child: YourWidget(),
)

// Yellowed paper
InkContainer(
  backgroundColor: InkTheme.paperYellow,  // #FFF8DC
  child: YourWidget(),
)

// Darker paper
InkContainer(
  backgroundColor: InkTheme.paperDark,  // #EBE4D5
  child: YourWidget(),
)
```

### Ink Colors

```dart
// Black ink (default)
InkText('Text', style: TextStyle(color: InkTheme.primaryInk))

// Blue ink
InkText('Text', style: TextStyle(color: InkTheme.blueInk))

// Brown ink
InkText('Text', style: TextStyle(color: InkTheme.brownInk))

// Faded ink
InkText('Text', style: TextStyle(color: InkTheme.fadeInk))
```

---

## Layout Patterns

### Pattern 1: Page Header with Decoration

```dart
Stack(
  children: [
    Column(
      children: [
        InkText.heading('Chapter Title'),
        InkDivider(),
        SizedBox(height: 8),
        InkText.subheading('Subtitle'),
      ],
    ),
    Positioned(
      top: 0,
      right: 20,
      child: InkSplatter(size: 15),
    ),
  ],
)
```

### Pattern 2: Info Card

```dart
InkContainer(
  padding: EdgeInsets.all(20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkText.subheading('Quest Details'),
      SizedBox(height: 12),
      InkDivider(),
      SizedBox(height: 12),
      InkText.body('Description of the quest...'),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkText.body('Reward:'),
          InkText.number('100 XP'),
        ],
      ),
    ],
  ),
)
```

### Pattern 3: Nested Containers

```dart
InkContainer(
  backgroundColor: InkTheme.paperYellow,
  child: Column(
    children: [
      InkText.heading('Inventory'),
      SizedBox(height: 16),
      InkContainer(
        backgroundColor: InkTheme.paper,
        showBorder: false,
        child: InkText.body('Sword +3'),
      ),
      SizedBox(height: 8),
      InkContainer(
        backgroundColor: InkTheme.paper,
        showBorder: false,
        child: InkText.body('Shield +2'),
      ),
    ],
  ),
)
```

---

## Typography Hierarchy

### Size Comparison

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    InkText.heading('Heading'),          // 48px, Caveat, bold
    InkText.subheading('Subheading'),    // 32px, Caveat, w600
    InkText.script('Script'),            // 24px, Dancing Script
    InkText.body('Body text'),           // 18px, Shadows Into Light
    InkText.bodySmall('Small text'),     // 16px, Shadows Into Light
  ],
)
```

---

## Combining Elements

### Full Page Example

```dart
Scaffold(
  backgroundColor: InkTheme.paper,
  body: Padding(
    padding: EdgeInsets.all(24),
    child: Column(
      children: [
        // Header
        Stack(
          children: [
            InkText.heading('Life RPG'),
            Positioned(
              right: 0,
              top: 5,
              child: InkSplatter(size: 20),
            ),
          ],
        ),
        SizedBox(height: 16),
        InkDivider(),
        SizedBox(height: 32),
        
        // Content
        InkContainer(
          child: Column(
            children: [
              InkText.subheading('Character Stats'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkText.body('Level'),
                  InkText.number('12'),
                ],
              ),
              InkDivider(indent: 20, endIndent: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkText.body('XP'),
                  InkText.number('2,450'),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        
        // Story section
        InkContainer(
          backgroundColor: InkTheme.paperYellow,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkText.script('Latest Adventure'),
              SizedBox(height: 12),
              InkDivider(),
              SizedBox(height: 12),
              InkText.body('The journey continues...'),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: InkSplatter(size: 15),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
)
```

---

## Tips for Best Results

### DO:
✅ Use heading → subheading → body hierarchy  
✅ Add whitespace between sections  
✅ Use dividers to separate content  
✅ Add occasional splatters for authenticity  
✅ Combine different paper backgrounds  
✅ Mix text styles (body + script + number)  

### DON'T:
❌ Overcrowd with too many elements  
❌ Use too many splatters (becomes messy)  
❌ Make text too small (16px minimum)  
❌ Mix with Material Design heavily  
❌ Use perfect alignment (embrace imperfection)  

---

## Responsive Considerations

```dart
// For different screen sizes, wrap in LayoutBuilder:
LayoutBuilder(
  builder: (context, constraints) {
    final isMobile = constraints.maxWidth < 600;
    
    return InkContainer(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: InkText(
        'Responsive text',
        style: InkTheme.inkHeading.copyWith(
          fontSize: isMobile ? 32 : 48,
        ),
      ),
    );
  },
)
```

---

## Animation Ideas (Future Enhancement)

```dart
// Fade in text (simulating ink appearing)
TweenAnimationBuilder(
  tween: Tween<double>(begin: 0, end: 1),
  duration: Duration(milliseconds: 800),
  builder: (context, value, child) {
    return Opacity(
      opacity: value,
      child: InkText.heading('Appearing Text'),
    );
  },
)
```

---

This visual guide shows the dramatic difference between standard Material Design and the ink-written aesthetic. The ink theme creates a unique, handcrafted feeling perfect for RPG/medieval applications!
