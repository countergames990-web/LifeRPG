# VIDEO INTRO INTEGRATION GUIDE

## Overview

The Life RPG app now features a video intro that plays after character selection, showing a cinematic camera pan to the book before transitioning to the main game interface.

---

## Flow Diagram

```
Character Selection → Video Intro → Profile Page (Book UI)
       ↓                   ↓              ↓
  Select Player     Camera Pan to Book   Game Interface
```

---

## Implementation Details

### 1. Video Player Setup

**Packages Added:**
- `video_player: ^2.9.2` - Core video playback functionality
- `chewie: ^1.8.5` - Video player UI wrapper with controls

**Installation:**
```bash
flutter pub get
```

### 2. File Structure

```
lib/pages/
  ├── character_selection_page.dart   # Modified to route to video
  ├── video_intro_page.dart           # NEW - Video player page
  └── profile_page.dart                # Game interface (unchanged)

assets/videos/
  ├── book_intro.mp4                   # Your video file goes here
  └── README.md                        # Video specifications
```

### 3. Navigation Flow

#### Before:
```dart
CharacterSelectionPage → ProfilePage
```

#### After:
```dart
CharacterSelectionPage → VideoIntroPage → ProfilePage
```

---

## VideoIntroPage Component

### Location
`lib/pages/video_intro_page.dart`

### Features

1. **Auto-Play**: Video starts immediately upon page load
2. **No Controls**: Clean, cinematic experience
3. **Auto-Transition**: Navigates to ProfilePage when video completes
4. **Skip Button**: User can skip intro (bottom-right)
5. **Error Handling**: Graceful fallback if video is missing
6. **Loading State**: Shows spinner while video initializes

### Constructor

```dart
VideoIntroPage({
  required String characterId,
})
```

**Parameters:**
- `characterId`: The selected character ID to pass to ProfilePage

### State Management

```dart
_videoController      // VideoPlayerController for playback
_chewieController     // Chewie wrapper for UI
_isLoading           // Loading state
_hasError            // Error state
```

### Lifecycle

```dart
initState()
  └─> _initializeVideo()
      ├─> Load video asset
      ├─> Initialize controllers
      ├─> Listen for completion
      └─> Handle errors

Video Completes → _navigateToProfile()
User Taps Skip  → _navigateToProfile()
Error Occurs    → Show message → Wait 2s → _navigateToProfile()

dispose()
  ├─> Dispose video controller
  └─> Dispose chewie controller
```

---

## Video Asset Specifications

### Required File
- **Name**: `book_intro.mp4`
- **Location**: `assets/videos/book_intro.mp4`

### Recommended Settings

| Property | Value |
|----------|-------|
| Format | MP4 (H.264) |
| Resolution | 1920x1080 (Full HD) |
| Frame Rate | 30fps or 60fps |
| Duration | 3-10 seconds |
| File Size | 2-5 MB (max 10 MB) |
| Audio | Optional |
| Aspect Ratio | 16:9 |

### Content Guidelines

The video should:
1. Start with camera far from the book
2. Smoothly pan/zoom toward the book
3. End with book filling most of the screen
4. Use warm, medieval lighting
5. Have a dark or muted background
6. Create smooth transition to book UI

---

## Code Examples

### Modifying Navigation (Already Implemented)

**character_selection_page.dart:**
```dart
// Old:
Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (_) => ProfilePage()),
);

// New:
Navigator.of(context).pushReplacement(
  MaterialPageRoute(
    builder: (_) => VideoIntroPage(characterId: characterId),
  ),
);
```

### Video Controller Setup

```dart
_videoController = VideoPlayerController.asset(
  'assets/videos/book_intro.mp4',
);

await _videoController.initialize();

_chewieController = ChewieController(
  videoPlayerController: _videoController,
  autoPlay: true,           // Start immediately
  looping: false,           // Play once
  showControls: false,      // Hide UI controls
  allowFullScreen: false,   // No fullscreen
  allowMuting: false,       // No mute button
  aspectRatio: _videoController.value.aspectRatio,
);
```

### Completion Listener

```dart
_videoController.addListener(() {
  if (_videoController.value.position >= _videoController.value.duration) {
    _navigateToProfile();
  }
});
```

### Error Handling

```dart
try {
  await _videoController.initialize();
  // Success
} catch (e) {
  setState(() {
    _hasError = true;
  });
  // Show error message for 2 seconds
  Future.delayed(Duration(seconds: 2), () {
    if (mounted) _navigateToProfile();
  });
}
```

---

## UI Components

### Loading State

```dart
if (_isLoading)
  Center(
    child: CircularProgressIndicator(
      color: Color(0xFFD4AF37), // Gold color
    ),
  )
```

### Error State

```dart
if (_hasError)
  Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 64),
        Text('Video not found'),
        Text('Continuing to game...'),
      ],
    ),
  )
```

### Skip Button

```dart
Positioned(
  bottom: 32,
  right: 32,
  child: TextButton(
    onPressed: _navigateToProfile,
    child: Text('Skip'),
  ),
)
```

### Video Display

```dart
if (!_isLoading && !_hasError && _chewieController != null)
  Center(
    child: Chewie(controller: _chewieController!),
  )
```

---

## Testing Scenarios

### 1. With Video File

**Setup:**
- Place `book_intro.mp4` in `assets/videos/`
- Run `flutter pub get`
- Run app

**Expected:**
- Video plays automatically
- Skip button appears
- Transitions to ProfilePage when done

### 2. Without Video File

**Setup:**
- Don't add video file (or rename it)
- Run app

**Expected:**
- Loading spinner appears briefly
- Error message displays: "Video not found"
- Message: "Continuing to game..."
- Auto-navigates to ProfilePage after 2 seconds

### 3. Skip Functionality

**Action:**
- Click "Skip" button during video playback

**Expected:**
- Video stops immediately
- Navigates to ProfilePage

### 4. Multiple Characters

**Action:**
- Select Character 1 → Watch video → Back button → Select Character 2

**Expected:**
- Video plays again for Character 2
- Correct character data loads in ProfilePage

---

## Troubleshooting

### Issue: Video Doesn't Play

**Possible Causes:**
1. File not in correct location
2. File name mismatch
3. Asset not declared in pubspec.yaml

**Solution:**
```yaml
# In pubspec.yaml
flutter:
  assets:
    - assets/videos/
```

Then run:
```bash
flutter clean
flutter pub get
```

### Issue: Black Screen

**Cause:** Video format not supported

**Solution:** Convert video to H.264 MP4:
```bash
ffmpeg -i input.mov -c:v libx264 -c:a aac book_intro.mp4
```

### Issue: Video Too Large (Slow Loading)

**Cause:** Large file size

**Solution:** Compress video:
```bash
ffmpeg -i book_intro.mp4 -vcodec h264 -b:v 1000k -acodec aac -b:a 128k book_intro_compressed.mp4
```

### Issue: Video Doesn't Auto-Advance

**Cause:** Listener not firing

**Solution:** Check video controller listener is properly set:
```dart
_videoController.addListener(() {
  if (_videoController.value.position >= _videoController.value.duration) {
    _navigateToProfile();
  }
});
```

---

## Platform Support

### ✅ Supported
- **Web** (Chrome, Firefox, Edge, Safari)
- **Android** (API 21+)
- **iOS** (iOS 12+)
- **macOS**
- **Windows**
- **Linux**

### Browser Compatibility

| Browser | H.264 Support | Notes |
|---------|---------------|-------|
| Chrome | ✅ | Full support |
| Firefox | ✅ | Full support |
| Safari | ✅ | Full support |
| Edge | ✅ | Full support |

---

## Performance Optimization

### Video Compression

For web deployment, keep video under 5MB:

```bash
# High quality (2-5 MB)
ffmpeg -i input.mp4 -vcodec h264 -b:v 1500k -acodec aac -b:a 128k output.mp4

# Medium quality (1-2 MB)
ffmpeg -i input.mp4 -vcodec h264 -b:v 800k -acodec aac -b:a 96k output.mp4

# Low quality (< 1 MB)
ffmpeg -i input.mp4 -vcodec h264 -b:v 500k -acodec aac -b:a 64k output.mp4
```

### Preloading

Video starts loading immediately on page navigation:
```dart
initState() {
  super.initState();
  _initializeVideo(); // Starts loading instantly
}
```

### Cleanup

Controllers are properly disposed:
```dart
@override
void dispose() {
  _videoController.dispose();
  _chewieController?.dispose();
  super.dispose();
}
```

---

## Customization Options

### Change Skip Button Position

```dart
Positioned(
  top: 32,        // Move to top
  left: 32,       // Move to left
  child: TextButton(
    onPressed: _navigateToProfile,
    child: Text('Skip'),
  ),
)
```

### Add Loading Text

```dart
if (_isLoading)
  Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Loading intro...'),
      ],
    ),
  )
```

### Change Background Color

```dart
Scaffold(
  backgroundColor: Colors.brown[900], // Dark brown instead of black
  // ...
)
```

### Add Fade Transition

```dart
// Wrap video in AnimatedOpacity
AnimatedOpacity(
  opacity: _isLoading ? 0.0 : 1.0,
  duration: Duration(milliseconds: 500),
  child: Chewie(controller: _chewieController!),
)
```

---

## Advanced Features

### Progress Bar (Optional)

```dart
// In ChewieController:
ChewieController(
  // ... other params
  showControls: true,           // Show controls
  customControls: LinearProgressIndicator(), // Custom progress
)
```

### Auto-Replay Button

```dart
// After video ends, show replay option
if (_videoEnded && !_navigated)
  Center(
    child: ElevatedButton(
      onPressed: () {
        _videoController.seekTo(Duration.zero);
        _videoController.play();
      },
      child: Text('Watch Again'),
    ),
  )
```

### Sound Toggle

```dart
IconButton(
  icon: Icon(_videoController.value.volume > 0 ? Icons.volume_up : Icons.volume_off),
  onPressed: () {
    setState(() {
      _videoController.setVolume(
        _videoController.value.volume > 0 ? 0.0 : 1.0,
      );
    });
  },
)
```

---

## Deployment Checklist

- [ ] Video file added to `assets/videos/book_intro.mp4`
- [ ] Video file size < 10 MB (preferably < 5 MB)
- [ ] Video format is MP4 H.264
- [ ] `assets/videos/` declared in `pubspec.yaml`
- [ ] `flutter pub get` executed
- [ ] Tested on web browser
- [ ] Tested skip functionality
- [ ] Tested error handling (remove video temporarily)
- [ ] Tested auto-transition to ProfilePage
- [ ] Verified correct character data passes through

---

## Future Enhancements

Potential additions:

1. **Multiple Videos**: Different intros per character type
2. **Interactive Elements**: Tap to reveal details during video
3. **Subtitles**: Add text overlay during video
4. **Custom Transitions**: Fade/dissolve effects between video and game
5. **Sound Effects**: Additional audio layer for ambiance
6. **Cached Videos**: Pre-load for faster subsequent plays

---

## Code References

### Main Files
- `lib/pages/video_intro_page.dart` - Video player implementation
- `lib/pages/character_selection_page.dart` - Modified navigation
- `pubspec.yaml` - Package dependencies and asset declarations

### Key Dependencies
```yaml
dependencies:
  video_player: ^2.9.2
  chewie: ^1.8.5
```

### Asset Declaration
```yaml
flutter:
  assets:
    - assets/videos/
```

---

## Support Resources

- **video_player docs**: https://pub.dev/packages/video_player
- **chewie docs**: https://pub.dev/packages/chewie
- **FFmpeg Guide**: https://ffmpeg.org/ffmpeg.html
- **H.264 Info**: https://en.wikipedia.org/wiki/H.264/MPEG-4_AVC

---

## Summary

The video intro adds a professional, cinematic touch to the Life RPG experience. With proper error handling, skip functionality, and graceful fallbacks, it enhances the user experience without becoming a barrier to gameplay.

Place your `book_intro.mp4` in `assets/videos/` and the system will automatically play it after character selection, creating a smooth transition into the game world.
