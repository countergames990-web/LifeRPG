# Life RPG - Medieval Life Management Application

A creative web-based RPG-style life management app built with Flutter, designed for couples to track their daily progress, maintain character profiles, and write their shared story together.

## Features

### 🎮 Character Profiles
- **8-bit Style Character Images**: Upload custom pixelated character portraits
- **Dynamic Stats**: Track 6 core attributes with beautiful progress bars
  - ❤️ Kindness
  - 🎨 Creativity
  - ⚡ Consistency
  - ⚔️ Efficiency
  - 🌿 Healing
  - 💕 Relationship
- **Level System**: Auto-level up based on total accumulated scores
- **Character Types**: Customizable character classes (Warrior, Mage, Healer, etc.)

### 📊 Score Tracking
- **Daily Score Updates**: Add scores for any date with an intuitive dialog
- **Weekly Stats Visualization**: Beautiful charts showing your weekly progress
- **Historical Data**: Keep track of all your past achievements

### 📖 Story Pages
Four dedicated story tabs to build your shared narrative:
1. **Town**: Describe your shared world
2. **Character 1**: Individual character backstory and development
3. **Character 2**: Second character's story and goals
4. **Additional Story**: Extra lore, quests, and adventures

### 🎨 Medieval Theme
- **Parchment & Wood**: Authentic medieval color palette
- **Animated Background**: Floating particles for atmospheric effect
- **8-bit Progress Bars**: Retro-gaming aesthetic for stats
- **Ornate Borders**: Decorative medieval-style UI elements

### 👥 Co-op Mode
- **Character Switching**: View and manage both characters
- **Shared Storage**: All data stored locally and synced
- **Real-time Updates**: Changes visible to both users

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- A web browser

### Installation

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

3. Run the app locally:
```bash
flutter run -d chrome
```

## Building for Production

### Build for Web

```bash
flutter build web --release
```

The output will be in the `build/web` directory.

### Deploy to Netlify

#### Option 1: Drag & Drop (Easiest)

1. Build the project (see above)
2. Go to [Netlify](https://netlify.com)
3. Drag and drop the `build/web` folder onto the Netlify dashboard

#### Option 2: GitHub Integration

1. Push your code to GitHub
2. Connect your repository to Netlify
3. Use these build settings:
   - **Build command**: `flutter build web --release`
   - **Publish directory**: `build/web`

## Usage Guide

### Daily Workflow

1. **Update Daily Scores**: Click "Update Daily Scores" button
2. **Select Date**: Choose the date for score entry
3. **Adjust Sliders**: Set scores for each attribute (0-20 points per day)
4. **Save**: Click "Save" to update your character

### Viewing Progress

1. **Weekly Stats**: Click "View Weekly Stats" to see graphs
2. **Check Level**: Your level auto-updates based on total scores
3. **Switch Characters**: Use "Switch Character" to view other profile

### Writing Your Story

1. **Open Story Page**: Click the "Story" button
2. **Choose Tab**: Select Town, Character 1, Character 2, or Additional Story
3. **Write**: Add your narrative in the text area
4. **Save**: Click "Save Story" to persist your writing

## Data Storage

All data is stored in your browser's localStorage. For sharing between devices, you'll need to access the same deployment URL from both devices.

## Customization

### Colors
Edit `lib/theme/medieval_theme.dart` to customize the color palette.

### Attributes
Modify attribute names in:
- `lib/models/character_profile.dart`
- `lib/pages/profile_page.dart`
- `lib/pages/score_update_dialog.dart`

## License

Personal project for couples. Feel free to fork and customize!
