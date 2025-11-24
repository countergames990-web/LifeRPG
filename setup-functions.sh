#!/bin/bash

echo "🚀 Setting up Netlify Functions for LifeRPG..."

# Navigate to functions directory
cd netlify/functions

# Install dependencies
echo "📦 Installing dependencies..."
npm install

echo "✅ Setup complete!"
echo ""
echo "To test locally:"
echo "  1. Install Netlify CLI: npm install -g netlify-cli"
echo "  2. Run: netlify dev"
echo ""
echo "To deploy:"
echo "  1. Connect your repo to Netlify"
echo "  2. Push to your Git repository"
echo "  3. Netlify will automatically deploy"
