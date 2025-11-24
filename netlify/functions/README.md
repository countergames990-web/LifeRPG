# Netlify Image Compression Setup

This directory contains Netlify Functions for server-side image compression.

## Setup

### 1. Install Dependencies

Navigate to the functions directory and install packages:

```bash
cd netlify/functions
npm install
```

### 2. Local Development

To test functions locally, install Netlify CLI:

```bash
npm install -g netlify-cli
```

Run the development server:

```bash
netlify dev
```

This will start:
- Flutter app on `http://localhost:8080`
- Netlify functions on `http://localhost:8888/.netlify/functions`

### 3. Deploy to Netlify

When you deploy to Netlify, the functions will be automatically deployed.

Make sure your `netlify.toml` has:

```toml
[build]
  command = "flutter build web"
  publish = "build/web"
  
[functions]
  directory = "netlify/functions"
```

### 4. Environment Variables

For production, set the API_URL in your Flutter build:

```bash
flutter build web --dart-define=API_URL=https://your-site.netlify.app/.netlify/functions
```

## How It Works

1. User uploads image in Flutter app
2. Image is sent to `/upload-image` Netlify function
3. Function uses Sharp library to:
   - Resize character images to 150x150px
   - Resize story images to max 800px width
   - Compress to JPEG with quality settings
4. Compressed image is returned as base64
5. Flutter app stores the compressed version

## Benefits

- ✅ No storage quota issues
- ✅ Images up to 5MB supported
- ✅ Automatic compression (typically 60-90% size reduction)
- ✅ Server-side processing (no client performance impact)
- ✅ Works seamlessly with Netlify hosting
