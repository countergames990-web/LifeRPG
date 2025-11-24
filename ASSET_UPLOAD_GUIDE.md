# Asset Upload System - Complete Guide

## 🎨 Overview

This system allows you to upload custom PNG/ICO icons and create frame-by-frame animations for the book page turns!

## 📁 Folder Structure

```
assets/
├── images/
│   └── open_book.png          (Static book background)
└── icons/
    ├── heart.png              (Kindness icon)
    ├── wand.png               (Creativity icon)
    ├── shield.png             (Consistency icon)
    ├── sword.png              (Efficiency icon)
    ├── potion.png             (Healing icon)
    ├── double_hearts.png      (Relationship icon)
    ├── trophy.png             (Achievement icon)
    └── star.png               (Level/XP icon)
```

## 🚀 How to Use

### 1. Upload Custom Icons

1. **Open the app** and click the **Upload icon** (📁) in the top right
2. **Select icon type** from dropdown (kindness, creativity, etc.)
3. **Click "UPLOAD ICON"**
4. **Select your PNG or ICO file**
5. Icon immediately appears in all stat boxes!

### 2. Create Frame-by-Frame Book Animation

#### Step A: Prepare Your Frames

1. Create your book page turn animation in your favorite tool:
   - After Effects, Blender, Photoshop, etc.
   - Recommended: 8-12 frames at 60fps
   - Export each frame as PNG (frame_001.png, frame_002.png, etc.)

2. Frame sequence example:
   ```
   frame_001.png - Book fully open, page flat
   frame_002.png - Page starting to lift
   frame_003.png - Page at 30° angle
   frame_004.png - Page at 60° angle
   frame_005.png - Page at 90° (vertical)
   frame_006.png - Page at 120° angle
   frame_007.png - Page at 150° angle
   frame_008.png - Page turned, next page visible
   ```

#### Step B: Upload Frames

1. In Asset Manager, scroll to **"UPLOAD BOOK ANIMATION FRAMES"**
2. Click **"UPLOAD FRAME"** for each frame **IN ORDER**
3. Frame 1 → Frame 2 → Frame 3 → etc.
4. Preview thumbnails appear showing all uploaded frames

#### Step C: See It In Action!

1. Go back to the main page
2. Click the **arrow buttons** to change pages
3. Watch the magic:
   - ✨ Content fades out (300ms)
   - 📖 Book frames play in sequence (600ms)
   - ✨ New content fades in (300ms)

## 🎬 Animation Logic

```
User clicks arrow
    ↓
Content opacity: 1.0 → 0.0 (fade out)
    ↓
Callback fires (page content updates)
    ↓
Frame 1 displays
    ↓
Frame 2 displays
    ↓
... (all frames play)
    ↓
Final frame displays
    ↓
Content opacity: 0.0 → 1.0 (fade in with new content)
    ↓
Animation complete!
```

## ⚙️ Technical Details

### Icon System
- **Storage**: Icons stored in memory (AssetManager)
- **Format**: PNG or ICO files
- **Fallback**: If no custom icon, uses default from `assets/icons/`
- **Hot reload**: Icons update immediately without restart

### Frame Animation System
- **Controller**: Uses AnimationController with duration 600ms
- **Frame rate**: Calculated automatically based on number of frames
- **Playback**: Frames play forward only (no reverse)
- **Storage**: Frames stored as Uint8List in memory

### Fade Transition
- **Duration**: 300ms total (150ms out, 150ms in)
- **Curve**: EaseOut for fade out, EaseIn for fade in
- **Timing**: Content updates at midpoint (50%)

## 📊 Performance

### Recommended Specs:
- **Icons**: 64x64px to 128x128px PNG
- **Frames**: 1920x1080px or smaller
- **Frame count**: 8-12 frames (optimal)
- **Total animation**: 600ms (feels smooth and responsive)

### File Sizes:
- Icons: < 50KB each
- Frame: < 500KB each
- Total frames: < 6MB for 12 frames

## 🎨 Creating Pixel Art Icons

If you want true 8-bit style:

1. Use tools like:
   - Aseprite
   - Piskel
   - Photoshop (Pencil tool, no anti-aliasing)

2. Icon specs:
   - Size: 32x32px or 64x64px
   - Colors: Limited palette (NES/SNES style)
   - Export: PNG with transparency
   - No anti-aliasing!

3. Example palette:
   ```
   Red:    #FF0000
   Blue:   #0000FF
   Green:  #00FF00
   Yellow: #FFFF00
   White:  #FFFFFF
   Black:  #000000
   ```

## 🎞️ Creating Book Frames

### Option 1: After Effects

1. Create composition (1920x1080, 60fps)
2. Import your book image
3. Animate page turn with 3D layers
4. Export as PNG sequence
5. Upload frames in order

### Option 2: Blender

1. Model a book with pages
2. Animate page turn (8-12 keyframes)
3. Render each frame as PNG
4. Upload sequentially

### Option 3: Pre-made Sprites

1. Find sprite sheets online (OpenGameArt, itch.io)
2. Split into individual frames
3. Upload each frame

## 🔧 Troubleshooting

### Icons not appearing?
- Check file format (PNG or ICO only)
- Verify icon type matches dropdown selection
- Try refreshing the page

### Animation choppy?
- Upload more frames (12-16 instead of 8)
- Reduce frame file size
- Check internet connection

### Frames in wrong order?
- Click "CLEAR ALL FRAMES"
- Re-upload in correct sequence
- Frame order matters!

## 💡 Tips & Tricks

1. **Test with static book first**
   - Place `open_book.png` in `assets/images/`
   - App uses this if no frames uploaded

2. **Create smooth animations**
   - Use easing in your animation software
   - More frames = smoother (but larger file size)
   - Sweet spot: 10-12 frames

3. **Optimize icons**
   - Use TinyPNG to compress files
   - Keep transparent backgrounds
   - Square aspect ratio works best

4. **Preview before uploading**
   - Test frames in animation software
   - Ensure seamless loop
   - Check frame timing

## 🎯 Next Steps

1. **Add Default Icons**
   - Place PNG files in `assets/icons/`
   - Name them exactly: `heart.png`, `wand.png`, etc.
   - These show when no custom icon uploaded

2. **Add Static Book**
   - Place your book image at `assets/images/open_book.png`
   - This displays when no animation frames uploaded

3. **Upload Custom Icons**
   - Use Asset Manager in app
   - Upload your pixel art or custom icons

4. **Create Animation**
   - Make frame sequence
   - Upload via Asset Manager
   - Enjoy smooth page turns!

---

**Ready to make it magical! 🪄✨**
