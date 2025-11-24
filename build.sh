#!/bin/bash

# Netlify Flutter Build Script
echo "📦 Installing Flutter..."

# Clone Flutter SDK if not exists
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
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
echo "📚 Getting dependencies..."
flutter pub get

# Install function dependencies
echo "📦 Installing Netlify function dependencies..."
cd netlify/functions
npm install
cd ../..

# Build for web
echo "🏗️ Building web app..."
flutter build web --release --web-renderer html

echo "✅ Build complete!"
