#!/bin/bash
set -e  # Exit on error

# Netlify Flutter Build Script
echo "📦 Installing Flutter..."

# Clone Flutter SDK if not exists
if [ ! -d "flutter" ]; then
  echo "Cloning Flutter SDK..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
else
  echo "Flutter SDK already exists"
fi

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Run Flutter doctor
echo "🔍 Running Flutter doctor..."
flutter doctor -v

# Enable web support
echo "🌐 Enabling web support..."
flutter config --enable-web

# Get dependencies
echo "📚 Getting Flutter dependencies..."
flutter pub get

# Install function dependencies
echo "📦 Installing Netlify function dependencies..."
if [ -d "netlify/functions" ]; then
  cd netlify/functions
  if [ -f "package.json" ]; then
    npm install
    echo "✅ Function dependencies installed"
  else
    echo "⚠️ No package.json found in netlify/functions"
  fi
  cd ../..
else
  echo "⚠️ netlify/functions directory not found"
fi

# Build for web
echo "🏗️ Building web app..."
flutter build web --release --web-renderer html

# Verify build output
if [ -d "build/web" ]; then
  echo "✅ Build complete! Output in build/web"
  ls -la build/web
else
  echo "❌ Build failed - build/web directory not created"
  exit 1
fi

