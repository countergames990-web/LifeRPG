# Life RPG Animations Guide

## 🐛 **LATEST UPDATE - Nov 9, 2025**

### ✅ FIXED: Blinking/Flickering Animation Bug
**Problem**: Animation would blink repeatedly when clicking arrows
**Solution**: Removed infinite loop in fade controller listener

### ✅ FIXED: Frame Animation Not Visible  
**Problem**: Frame-by-frame animation wasn't showing
**Solution**: Synchronized frame and fade animations, fixed timing

**See bottom of this file for detailed bug fix information.**

---

## 🎭 Implemented Animations

### 1. **Book Container Animations**
The `AnimatedBookContainer` widget includes several lively animations:

#### Breathing Effect (4-second cycle)
- The entire book subtly moves up and down using a sine wave animation
- Creates a living, breathing feeling to the interface
- Offset: ±1.5 pixels vertical movement

#### Page Flip Animation (600ms)
- 3D rotation effect when navigating between pages
- Uses perspective transformation (Matrix4 with rotateY)
- Left page rotates when going forward
- Right page rotates when going backward
- Smooth cubic easing curve

#### Animated Binding Rivets
- 8 metal rivets in the book's spine
- Each rivet pulses independently with breathing effect
- Offset animation creates wave pattern
- Shadow intensity varies with animation

#### Medieval Paper Texture
- Procedurally generated paper fibers (150 random lines)
- Age spots and stains (20 random spots)
- Worn edges with organic roughness
- Page curl effect at bottom corners
- Parchment gradient (cream → beige → tan)

### 2. **Navigation Arrow Animations**
- Circular wooden buttons with gold borders
- Pulse effect synced with book breathing
- Scale animation: 0.9 to 0.95 (5% variance)
- Gold glow shadow effect
- Hover cursor changes to pointer

### 3. **Visual Effects**

#### Shadows & Depth
- Multiple layered shadows for 3D depth
- Wood frame: 2 shadow layers (40px + 15px blur)
- Pages: Inner shadow + edge shadow
- Rivets: Dynamic shadow opacity

#### Gradients
- **Wood Frame**: Radial gradient (3 brown tones)
- **Pages**: Linear gradient (3 parchment tones)
- **Binding**: Vertical gradient with opacity
- **Arrows**: Radial gradient (copper tones)

#### Custom Painters
- `ParchmentTexturePainter`: Adds paper fibers and age spots
- `MedievalPaperEdgePainter`: Creates worn, organic edges
- `PageCurlPainter`: Renders curled corner effect

## 🎨 Animation Parameters

### Timing
```dart
Page Flip: 600ms (Curves.easeInOutCubic)
Breathing: 4000ms (Curves.easeInOut, repeat)
Rivet Pulse: Synced with breathing (phase-shifted per rivet)
Arrow Scale: 300ms (continuous sine wave)
```

### Transforms
```dart
Page Rotation: ±0.15 radians (±8.6°)
Vertical Movement: ±1.5 pixels
Rivet Scale: 1.0 ± 0.03 (3% variance)
Arrow Scale: 0.9 + sin(θ) * 0.05
```

## 🔮 Future Animation Ideas

### Stat Icons (Not Yet Implemented)
- Pulse animation when tapped
- Bounce effect when score updates
- Sparkle particles on level up
- Glow effect for high scores
- Shake animation for low scores

### Page Transitions
- Dust particles during page flip
- Sound effects (page turn, quill scratch)
- Ink splatter effects
- Candle flicker animation

### Character Portrait
- Subtle idle animation (breathing)
- Blink animation
- Hover glow effect
- Level up celebration animation

### Background
- Animated particles already implemented
- Could add: flickering candles, floating dust, moving shadows

## 📝 Usage

The animated book is automatically used in `ProfilePage`:

```dart
AnimatedBookContainer(
  onPreviousPage: () { /* Navigate back */ },
  onNextPage: () { /* Navigate forward */ },
  leftPage: Widget,
  rightPage: Widget,
  showNavigation: true,
)
```

### Parameters
- `leftPage`: Widget for left page content
- `rightPage`: Widget for right page content
- `onPreviousPage`: Callback for left arrow (null to hide)
- `onNextPage`: Callback for right arrow (null to hide)
- `showNavigation`: Toggle arrow visibility (default: true)

## 🎯 Performance Notes

- Uses `TickerProviderStateMixin` for smooth 60fps animations
- `AnimatedBuilder` prevents unnecessary rebuilds
- Custom painters use `shouldRepaint: false` for static textures
- Breathing animation runs continuously with low overhead
- Page flip animation only triggers on navigation

## 🛠️ Technical Details

### Animation Controllers
```dart
_pageFlipController: Handles page turn animation
_breatheController: Continuous breathing effect
```

### Animation Types
- **Tween Animation**: Page flip rotation
- **Curve Animation**: Smooth easing functions
- **Transform Animation**: 3D perspective transforms
- **Opacity Animation**: Shadow intensity
- **Scale Animation**: Rivet pulsing

### State Management
- `StatefulWidget` with `TickerProviderStateMixin`
- Proper disposal of animation controllers
- Efficient use of `Listenable.merge` for multiple animations

---

**Pro Tip**: The breathing effect is subtle by design (±1.5px). Increase the offset in `Transform.translate` for more dramatic movement!

---

##  Bug Fixes - November 9, 2025

### Issue 1: Blinking/Flickering Animation
**Problem**: Animation would blink repeatedly when clicking arrows
**Root Cause**: Fade controller listener created infinite loop
**Solution**: Removed problematic listener, animation now runs once cleanly

### Issue 2: Frame Animation Not Visible
**Problem**: Frame-by-frame animation wasn't showing
**Root Cause**: Timing mismatch between fade and frame animations
**Solution**: Both animations start together, content updates at midpoint (300ms)

### New Animation Timing
- 0ms: Both animations start
- 0-180ms: Content fades out
- 300ms: Page content updates
- 420-600ms: Content fades in
- Frames play throughout entire 600ms

### To Enable Frame Animation
1. Add PNG frames to assets/animations/book_turn/
2. Update _getBookAnimationFrames() in profile_page.dart
3. Run flutter and click arrows to see smooth animation!
