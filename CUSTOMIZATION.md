# 🎨 Customization Guide

## Making Life RPG Truly Yours

This guide will help you customize various aspects of the app to match your preferences.

---

## 🎨 Changing Colors

### Location: `lib/theme/medieval_theme.dart`

### Default Color Palette:
```dart
// Parchment/Paper tones
parchment = #F4E8D0
parchmentDark = #E8D4B0
parchmentLight = #FFF8E7

// Wood tones
wood = #8B6F47
woodDark = #5D4E37
woodLight = #A68A64

// Accent colors
gold = #FFD700
darkGold = #B8860B
crimson = #DC143C
royalBlue = #4169E1
forestGreen = #228B22
```

### To Change Theme:

**Option 1: Darker Medieval**
```dart
static const Color parchment = Color(0xFF8B7355); // Darker brown
static const Color wood = Color(0xFF4A3728); // Almost black wood
static const Color gold = Color(0xFFB8860B); // Darker gold
```

**Option 2: Fantasy Blue**
```dart
static const Color parchment = Color(0xFFE0E8F0); // Light blue
static const Color wood = Color(0xFF2C3E50); // Navy blue
static const Color gold = Color(0xFF3498DB); // Bright blue accent
```

**Option 3: Pastel/Soft**
```dart
static const Color parchment = Color(0xFFFFF5EE); // Seashell
static const Color wood = Color(0xFFC8A882); // Light brown
static const Color gold = Color(0xFFFFDAB9); // Peach puff
```

### Changing Attribute Colors:

Find these lines and modify:
```dart
static const Color kindness = Color(0xFFFFB6C1); // Light pink
static const Color creativity = Color(0xFF9370DB); // Purple
static const Color consistency = Color(0xFF4682B4); // Steel blue
static const Color efficiency = Color(0xFF32CD32); // Lime green
static const Color healing = Color(0xFF98FB98); // Pale green
static const Color relationship = Color(0xFFFF69B4); // Hot pink
```

---

## ✏️ Changing Fonts

### Location: `lib/main.dart`

### Current Font:
```dart
theme: MedievalTheme.theme.copyWith(
  textTheme: GoogleFonts.medievalSharpTextTheme(
    Theme.of(context).textTheme,
  ),
),
```

### Alternative Medieval Fonts:

**Option 1: Cinzel (Classic)**
```dart
import 'package:google_fonts/google_fonts.dart';

textTheme: GoogleFonts.cinzelTextTheme(
  Theme.of(context).textTheme,
),
```

**Option 2: Almendra (Handwritten)**
```dart
textTheme: GoogleFonts.almendraTextTheme(
  Theme.of(context).textTheme,
),
```

**Option 3: UnifrakturMaguntia (Gothic)**
```dart
textTheme: GoogleFonts.unifrakturMaguntiaTextTheme(
  Theme.of(context).textTheme,
),
```

**Option 4: Caesar Dressing (Playful)**
```dart
textTheme: GoogleFonts.caesarDressingTextTheme(
  Theme.of(context).textTheme,
),
```

### Custom Font (from file):

1. Add font files to `assets/fonts/`
2. Update `pubspec.yaml`:
```yaml
flutter:
  fonts:
    - family: MyCustomFont
      fonts:
        - asset: assets/fonts/MyFont-Regular.ttf
        - asset: assets/fonts/MyFont-Bold.ttf
          weight: 700
```
3. Use in theme:
```dart
theme: MedievalTheme.theme.copyWith(
  fontFamily: 'MyCustomFont',
),
```

---

## 📊 Customizing Attributes

### Renaming Attributes

#### Location 1: `lib/models/character_profile.dart`
```dart
currentScores = currentScores ?? {
  'kindness': 0,
  'creativity': 0,
  'consistency': 0,
  'efficiency': 0,
  'healing': 0,
  'relationship': 0,
}
```

Change to your preferred names:
```dart
currentScores = currentScores ?? {
  'compassion': 0,
  'imagination': 0,
  'discipline': 0,
  'productivity': 0,
  'wellness': 0,
  'love': 0,
}
```

#### Location 2: `lib/pages/profile_page.dart`
Update the display (around line 190):
```dart
PixelProgressBar(
  label: '❤️ Compassion', // Changed
  value: character.currentScores['compassion'] ?? 0, // Changed key
  maxValue: 100,
  barColor: MedievalColors.kindness,
),
```

#### Location 3: `lib/pages/score_update_dialog.dart`
Update the sliders (around line 20):
```dart
final Map<String, int> _scores = {
  'compassion': 0, // Changed
  'imagination': 0, // Changed
  // ... etc
};
```

And update the slider labels (around line 100):
```dart
_buildScoreSlider('❤️ Compassion', 'compassion', MedievalColors.kindness),
```

### Adding New Attributes

1. **Add to model** (`character_profile.dart`):
```dart
currentScores = currentScores ?? {
  // existing...
  'courage': 0, // NEW
};
```

2. **Add color** (`medieval_theme.dart`):
```dart
static const Color courage = Color(0xFFFF6347); // Tomato red
```

3. **Add to profile display** (`profile_page.dart`):
```dart
PixelProgressBar(
  label: '🦁 Courage',
  value: character.currentScores['courage'] ?? 0,
  maxValue: 100,
  barColor: MedievalColors.courage,
),
```

4. **Add to score dialog** (`score_update_dialog.dart`):
```dart
final Map<String, int> _scores = {
  // existing...
  'courage': 0,
};

// And in the build method:
_buildScoreSlider('🦁 Courage', 'courage', MedievalColors.courage),
```

5. **Add to weekly stats** (`weekly_stats_page.dart`):
```dart
_buildAttributeChart(
  '🦁 Courage',
  'courage',
  MedievalColors.courage,
  weeklyScores,
),
```

---

## 🎯 Adjusting Level Calculation

### Location: `lib/models/character_profile.dart`

### Current System (Level up every 100 points):
```dart
void calculateLevel() {
  int totalScore = currentScores.values.fold(0, (sum, score) => sum + score);
  level = (totalScore ~/ 100) + 1;
}
```

### Alternative Systems:

**Faster Progression (Level up every 50 points):**
```dart
level = (totalScore ~/ 50) + 1;
```

**Exponential (Harder as you level):**
```dart
void calculateLevel() {
  int totalScore = currentScores.values.fold(0, (sum, score) => sum + score);
  level = (sqrt(totalScore / 10)).floor() + 1;
}
```
*(Don't forget to `import 'dart:math';` at the top)*

**Tiered System:**
```dart
void calculateLevel() {
  int totalScore = currentScores.values.fold(0, (sum, score) => sum + score);
  if (totalScore < 100) level = 1;
  else if (totalScore < 250) level = 2;
  else if (totalScore < 500) level = 3;
  else if (totalScore < 1000) level = 4;
  else level = 5;
}
```

---

## 🌟 Customizing Animations

### Particle Count

**Location:** `lib/widgets/animated_background.dart`

Find this line (around line 30):
```dart
for (int i = 0; i < 20; i++) { // Change 20 to more or less
```

- **Fewer particles (better performance):** 10
- **More particles (more atmosphere):** 50
- **Subtle:** 5
- **Extreme:** 100

### Particle Speed

Same file, around line 35:
```dart
speed: _random.nextDouble() * 0.5 + 0.3,
```

- **Slower:** `* 0.2 + 0.1`
- **Faster:** `* 1.0 + 0.5`

### Particle Size

Same file, around line 34:
```dart
size: _random.nextDouble() * 4 + 2,
```

- **Smaller:** `* 2 + 1`
- **Larger:** `* 8 + 4`

### Disable Animations

In `lib/pages/profile_page.dart`, remove the MedievalAnimatedBackground wrapper:

Change from:
```dart
body: MedievalAnimatedBackground(
  child: SingleChildScrollView(
    // ...
  ),
),
```

To:
```dart
body: SingleChildScrollView(
  // ...
),
```

---

## 📱 Adjusting Layout

### Progress Bar Max Values

**Location:** `lib/pages/profile_page.dart` and `lib/widgets/medieval_widgets.dart`

Default is 100. To change:
```dart
PixelProgressBar(
  label: '❤️ Kindness',
  value: character.currentScores['kindness'] ?? 0,
  maxValue: 200, // Changed from 100
  barColor: MedievalColors.kindness,
),
```

### Daily Score Slider Range

**Location:** `lib/pages/score_update_dialog.dart`

Find (around line 120):
```dart
Slider(
  value: _scores[key]!.toDouble(),
  min: 0,
  max: 20, // Change maximum daily points
  divisions: 20, // Should match max
  // ...
)
```

Common alternatives:
- **0-10:** Easy mode, max: 10, divisions: 10
- **0-50:** High achiever mode, max: 50, divisions: 50
- **0-100:** Percentage mode, max: 100, divisions: 100

### Character Image Size

**Location:** `lib/pages/profile_page.dart`

Find (around line 90):
```dart
Container(
  width: 200, // Change width
  height: 200, // Change height
  decoration: BoxDecoration(
```

Suggestions:
- **Smaller:** 150x150
- **Larger:** 300x300
- **Portrait:** 200x250
- **Square:** Keep equal

---

## 🎭 Custom Character Types

### Predefined Type Dropdown

**Location:** `lib/pages/profile_page.dart`

Replace the edit type dialog (around line 420) with:
```dart
void _showEditTypeDialog(
  BuildContext context,
  CharacterProfile character,
  GameStateProvider gameState,
) {
  String selectedType = character.type;
  final types = [
    'Warrior',
    'Mage',
    'Rogue',
    'Healer',
    'Paladin',
    'Ranger',
    'Bard',
    'Monk',
  ];
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Select Type'),
      content: DropdownButton<String>(
        value: selectedType,
        items: types.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            selectedType = value;
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            gameState.updateCharacterType(character.id, selectedType);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
```

---

## 📝 Story Tab Names

**Location:** `lib/pages/story_page.dart`

Find the TabBar (around line 60):
```dart
tabs: const [
  Tab(icon: Icon(Icons.location_city), text: 'Town'),
  Tab(icon: Icon(Icons.person), text: 'Character 1'),
  Tab(icon: Icon(Icons.person_outline), text: 'Character 2'),
  Tab(icon: Icon(Icons.auto_stories), text: 'Additional Story'),
],
```

Change text and icons to your preference:
```dart
tabs: const [
  Tab(icon: Icon(Icons.castle), text: 'Kingdom'),
  Tab(icon: Icon(Icons.shield), text: 'Hero'),
  Tab(icon: Icon(Icons.favorite), text: 'Partner'),
  Tab(icon: Icon(Icons.book), text: 'Quests'),
],
```

---

## 🔧 Performance Tuning

### Reduce Animation Overhead

In `lib/main.dart`, add:
```dart
MaterialApp(
  debugShowCheckedModeBanner: false,
  showPerformanceOverlay: true, // Shows FPS
  // ...
)
```

If FPS is low:
1. Reduce particle count (see above)
2. Increase animation duration (slower = less CPU)
3. Disable shadows on boxes

### Optimize for Mobile

Add to `pubspec.yaml`:
```yaml
flutter:
  uses-material-design: true
  
  # Add these:
  generate: true
  
  web:
    auto-detect-targets: true
```

---

## 🎨 Quick Theme Presets

### Dark Mode

In `medieval_theme.dart`:
```dart
static const Color parchment = Color(0xFF1A1A1A); // Dark gray
static const Color parchmentDark = Color(0xFF0D0D0D); // Almost black
static const Color parchmentLight = Color(0xFF2A2A2A); // Lighter dark
static const Color wood = Color(0xFF3D3D3D); // Dark wood
static const Color gold = Color(0xFFFFD700); // Keep gold bright
static const Color inkBlack = Color(0xFFE0E0E0); // Light text for dark bg
```

### Pastel/Cute Mode

```dart
static const Color parchment = Color(0xFFFFF0F5); // Lavender blush
static const Color wood = Color(0xFFDDB5C3); // Pink wood
static const Color gold = Color(0xFFFFB6C1); // Light pink
static const Color kindness = Color(0xFFFFDAB9); // Peach
static const Color creativity = Color(0xFFE6E6FA); // Lavender
```

### Cyberpunk Mode

```dart
static const Color parchment = Color(0xFF0A0E27); // Dark blue
static const Color wood = Color(0xFF1B2845); // Navy
static const Color gold = Color(0xFF00FFFF); // Cyan
static const Color crimson = Color(0xFFFF006E); // Neon pink
```

---

## 💾 Save Your Changes

After any customization:

```bash
# Save all files
# Test locally
flutter run -d chrome

# If it looks good, build for production
flutter build web --release

# Deploy to Netlify
```

---

**Remember:** You can always revert changes by checking the original code in this guide or using git!

Happy customizing! 🎨✨
