# Video Assets

## Required Video

Place your intro video file here with the following name:
- **book_intro.mp4**

## Video Specifications

### Recommended Settings:
- **Format**: MP4 (H.264 codec)
- **Resolution**: 1920x1080 (Full HD) or higher
- **Frame Rate**: 30fps or 60fps
- **Duration**: 3-10 seconds recommended
- **Audio**: Optional (will play if included)

### Content:
The video should show:
- Camera panning/zooming toward a book
- Smooth transition effect
- Ends with book taking up most of the screen
- Sets up the visual transition to the book UI

### File Location:
```
assets/
  └── videos/
      └── book_intro.mp4  ← Place your video here
```

## Video Playback Behavior

- **Auto-play**: Video starts automatically after character selection
- **No controls**: Clean, seamless experience
- **Skip button**: User can skip the intro (bottom-right corner)
- **Auto-transition**: After video completes, automatically navigates to the book profile page
- **Fallback**: If video is not found or fails to load, app shows error message for 2 seconds then continues to the game

## Testing Without Video

If you don't have the video file yet, the app will:
1. Show a loading indicator briefly
2. Display "Video not found" message
3. Show "Continuing to game..." text
4. Automatically navigate to the profile page after 2 seconds

This allows you to test the app while preparing your video asset.

## Creating Your Video

### Tips for Creating the Intro:
1. **Scene Setup**: Position camera far from book
2. **Movement**: Smooth dolly/zoom toward the book
3. **Lighting**: Soft, warm lighting for medieval atmosphere
4. **Background**: Dark or muted background to highlight the book
5. **End Frame**: Book should fill most of the screen at the end
6. **Duration**: Keep it short (3-7 seconds) for best UX

### Suggested Tools:
- Video editing software (DaVinci Resolve, Premiere Pro, iMovie)
- 3D software (Blender) for camera animations
- After Effects for motion graphics
- Mobile apps for quick captures

## File Size Considerations

For web deployment:
- **Optimal**: 2-5 MB
- **Maximum**: 10 MB
- Use video compression tools if needed (HandBrake, Adobe Media Encoder)

## Formats Supported

While MP4 is recommended, these formats are also supported:
- `.mp4` (H.264) - **Recommended**
- `.webm` - Good for web
- `.mov` - Works but larger file size

**Note**: Always test on web browsers (Chrome, Firefox, Safari, Edge) to ensure compatibility.
