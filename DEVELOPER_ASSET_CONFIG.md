# Developer Asset Configuration Guide

## 📁 Asset Directory Structure

```
assets/
├── images/
│   └── open_book.png              # Static book background (fallback)
├── icons/
│   ├── heart.png                  # Kindness icon
│   ├── wand.png                   # Creativity icon
│   ├── shield.png                 # Consistency icon
│   ├── sword.png                  # Efficiency icon
│   ├── potion.png                 # Healing icon
│   ├── double_hearts.png          # Relationship icon
│   ├── trophy.png                 # Achievement icon
│   └── star.png                   # Level/XP icon
└── animations/
    └── book_turn/
        ├── frame_001.png          # Page turn animation frame 1
        ├── frame_002.png          # Page turn animation frame 2
        ├── frame_003.png          # Page turn animation frame 3
        └── ...                    # More frames (8-12 recommended)
```

## 🎨 Icon Configuration (Development Time)

### Step 1: Create/Get Icons
1. Create pixel art or medieval-style icons (64x64px or 128x128px recommended)
2. Use PNG format with transparency
3. Name them exactly as shown above:
   - `heart.png` → Kindness
   - `wand.png` → Creativity
   - `shield.png` → Consistency
   - `sword.png` → Efficiency
   - `potion.png` → Healing
   - `double_hearts.png` → Relationship
   - `trophy.png` → Achievement
   - `star.png` → Level/XP

### Step 2: Place Files
```bash
# Copy your icons to assets/icons/
cp heart.png assets/icons/
cp wand.png assets/icons/
# ... etc
```

### Step 3: Verify pubspec.yaml
Make sure `pubspec.yaml` includes:
```yaml
flutter:
  assets:
    - assets/icons/
```

## 📖 Book Animation Configuration

### Step 1: Create Frame-by-Frame Animation

#### Option A: After Effects
1. Create 1920x1080 composition (or your target size)
2. Import your book PNG
3. Create keyframes for page turn (8-12 frames)
4. Export as PNG sequence:
   - File → Export → Render Queue
   - Format: PNG Sequence
   - Name: frame_[####].png

#### Option B: Blender
1. Model book with pages or import 2D planes
2. Animate page turn over 8-12 keyframes
3. Render animation:
   - Output Properties → File Format: PNG
   - Output Properties → Frame Range: 1-12
   - Render → Render Animation

#### Option C: Manual Frame Creation
1. Create each frame in Photoshop/GIMP
2. Name sequentially: frame_001.png, frame_002.png, etc.
3. Export all at same resolution

### Step 2: Place Animation Frames
```bash
# Create animation directory
mkdir -p assets/animations/book_turn

# Copy frames
cp frame_001.png assets/animations/book_turn/
cp frame_002.png assets/animations/book_turn/
# ... etc
```

### Step 3: Update pubspec.yaml
```yaml
flutter:
  assets:
    - assets/animations/book_turn/
```

### Step 4: Configure in Code

Open `lib/widgets/animated_frame_book.dart` or where `AnimatedFrameBook` is used.

Update the `bookFramePaths` parameter:

```dart
AnimatedFrameBook(
  leftPage: leftPageContent,
  rightPage: rightPageContent,
  onNextPage: () => setState(() => _currentPage++),
  onPreviousPage: () => setState(() => _currentPage--),
  bookFramePaths: const [
    'assets/animations/book_turn/frame_001.png',
    'assets/animations/book_turn/frame_002.png',
    'assets/animations/book_turn/frame_003.png',
    'assets/animations/book_turn/frame_004.png',
    'assets/animations/book_turn/frame_005.png',
    'assets/animations/book_turn/frame_006.png',
    'assets/animations/book_turn/frame_007.png',
    'assets/animations/book_turn/frame_008.png',
  ],
  staticBookPath: 'assets/images/open_book.png', // Fallback
)
```

OR use a helper function:

```dart
List<String> _getBookFrames() {
  return List.generate(
    8, // Number of frames
    (index) => 'assets/animations/book_turn/frame_${(index + 1).toString().padLeft(3, '0')}.png',
  );
}

// Then use:
AnimatedFrameBook(
  bookFramePaths: _getBookFrames(),
  staticBookPath: 'assets/images/open_book.png',
  // ... other properties
)
```

## 🎬 Animation Behavior

When user clicks arrow:
1. **Fade Out** (150ms) - Content opacity goes from 1.0 → 0.0
2. **Frame Animation** (600ms) - Plays all frames sequentially
3. **Content Update** - Page content changes (happens at midpoint)
4. **Fade In** (150ms) - New content opacity goes from 0.0 → 1.0

Total time: ~900ms for complete page turn

## ⚙️ Technical Specs

### Recommended Frame Specs:
- **Resolution**: 1920x1080px or 1280x720px
- **Format**: PNG with transparency (if needed)
- **Frame Count**: 8-12 frames for smooth animation
- **File Size**: < 500KB per frame (compress with TinyPNG if needed)
- **Naming**: Sequential with zero-padding (frame_001, frame_002, etc.)

### Icon Specs:
- **Resolution**: 64x64px or 128x128px (sharp pixel art) or 256x256px (detailed art)
- **Format**: PNG with transparency
- **File Size**: < 50KB per icon
- **Style**: Consistent across all icons

## 🔧 Testing

### Test Without Animation
1. Set `bookFramePaths: null` or `bookFramePaths: []`
2. Provide only `staticBookPath: 'assets/images/open_book.png'`
3. App will display static book (no animation)

### Test With Animation
1. Provide `bookFramePaths` with your frame list
2. Click arrow buttons
3. Verify frames play smoothly
4. Check content fades out/in correctly

### Debug Frame Loading
```dart
@override
void initState() {
  super.initState();
  
  // Print to verify frame paths
  if (widget.bookFramePaths != null) {
    print('Book frames: ${widget.bookFramePaths!.length} frames');
    for (var path in widget.bookFramePaths!) {
      print('  - $path');
    }
  }
}
```

## 📊 Performance Tips

1. **Optimize Images**
   ```bash
   # Use ImageMagick to batch optimize
   mogrify -strip -quality 85 assets/animations/book_turn/*.png
   ```

2. **Preload Images** (optional)
   ```dart
   @override
   void didChangeDependencies() {
     super.didChangeDependencies();
     
     // Preload animation frames
     if (widget.bookFramePaths != null) {
       for (var path in widget.bookFramePaths!) {
         precacheImage(AssetImage(path), context);
       }
     }
   }
   ```

3. **Reduce Frame Count for Web**
   - Desktop/Mobile: 12 frames = smooth
   - Web: 8 frames = good balance

## 🎯 Quick Setup Checklist

- [ ] Created/obtained icon PNG files
- [ ] Placed icons in `assets/icons/` with correct names
- [ ] Created book animation frames (8-12 frames)
- [ ] Placed frames in `assets/animations/book_turn/`
- [ ] Updated `pubspec.yaml` with asset paths
- [ ] Configured `bookFramePaths` in code
- [ ] Tested animation by clicking arrows
- [ ] Optimized image file sizes if needed

## 💡 Example: Complete Setup

```bash
# 1. Create directories
mkdir -p assets/icons
mkdir -p assets/animations/book_turn
mkdir -p assets/images

# 2. Copy your assets
cp ~/my_icons/*.png assets/icons/
cp ~/my_animation/frame_*.png assets/animations/book_turn/
cp ~/my_book_bg.png assets/images/open_book.png

# 3. Run flutter
flutter pub get
flutter run -d chrome
```

## 🚨 Troubleshooting

### Icons not showing?
- Check file names match exactly (case-sensitive!)
- Verify paths in `pubspec.yaml`
- Run `flutter clean && flutter pub get`

### Animation not playing?
- Check `bookFramePaths` is not null
- Verify all frame files exist
- Check console for image loading errors
- Ensure frame names are in order

### Animation choppy?
- Reduce file sizes (compress PNGs)
- Use fewer frames (8 instead of 12)
- Check frame resolution (use smaller size)

---

**All assets are configured at development time - no runtime uploads needed!** 🎨✨
