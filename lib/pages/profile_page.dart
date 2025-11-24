import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/character_profile.dart';
import '../theme/rpg_theme.dart';
import 'score_update_dialog.dart';
import 'weekly_stats_page.dart';
import 'story_page.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        final character = gameState.currentCharacter;
        final otherCharacter = gameState.otherCharacter;

        if (character == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: RPGTheme.darkWood,
          body: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  RPGTheme.mediumWood,
                  RPGTheme.darkWood,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header with logout
                  _buildHeader(gameState),
                  // Main content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Main character profile card
                              _buildMainProfileCard(character, gameState),
                              const SizedBox(height: 24),
                              
                              // Other character card (if exists, view-only)
                              if (otherCharacter != null && otherCharacter.name != 'Character 1' && otherCharacter.name != 'Character 2') ...[
                                _buildOtherCharacterCard(otherCharacter, gameState),
                                const SizedBox(height: 24),
                              ],
                              
                              // Action buttons
                              _buildActionButtons(character, gameState),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(GameStateProvider gameState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: RPGTheme.mediumWood,
        border: Border(
          bottom: BorderSide(color: RPGTheme.ornateGold, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.castle, color: RPGTheme.ornateGold, size: 28),
              const SizedBox(width: 8),
              MedievalText.heading(
                'Life RPG',
                color: RPGTheme.ornateGold,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            color: RPGTheme.ornateGold,
            tooltip: 'Logout',
            onPressed: () {
              gameState.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainProfileCard(CharacterProfile character, GameStateProvider gameState) {
    return Container(
      decoration: BoxDecoration(
        color: RPGTheme.scrollTan.withOpacity(0.95),
        border: Border.all(color: RPGTheme.ornateGold, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: CustomPaint(
        painter: OrnateBorderPainter(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Portrait
                  _buildPortrait(character),
                  const SizedBox(width: 20),
                  // Biography section
                  Expanded(
                    child: _buildBiographySection(character),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Stats section
              _buildStatsSection(character),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortrait(CharacterProfile character) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: RPGTheme.ornateGold, width: 3),
        color: RPGTheme.darkWood,
      ),
      child: character.characterImageUrl != null && 
             character.characterImageUrl != 'warrior' &&
             character.characterImageUrl != 'mage' &&
             character.characterImageUrl != 'rogue' &&
             character.characterImageUrl != 'healer' &&
             character.characterImageUrl != 'adventurer'
          ? Image.network(
              character.characterImageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildDefaultPortrait(character),
            )
          : _buildDefaultPortrait(character),
    );
  }

  Widget _buildDefaultPortrait(CharacterProfile character) {
    return Container(
      color: RPGTheme.mediumWood,
      child: Center(
        child: Icon(
          _getTypeIcon(character.type),
          size: 80,
          color: RPGTheme.ornateGold,
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Warrior':
        return Icons.shield;
      case 'Mage':
        return Icons.auto_fix_high;
      case 'Rogue':
        return Icons.visibility_off;
      case 'Healer':
        return Icons.favorite;
      default:
        return Icons.person;
    }
  }

  Widget _buildBiographySection(CharacterProfile character) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: RPGTheme.parchment,
            border: Border.all(color: RPGTheme.ornateGold, width: 2),
          ),
          child: MedievalText.heading(
            character.name,
            color: RPGTheme.textBrown,
          ),
        ),
        const SizedBox(height: 12),
        
        // Biography section
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: RPGTheme.parchment,
            border: Border.all(color: RPGTheme.ornateGold, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MedievalText.heading('Biography'),
              const SizedBox(height: 8),
              _buildBioItem(Icons.star, 'Level ${character.level}'),
              _buildBioItem(_getTypeIcon(character.type), character.type),
              _buildBioItem(Icons.emoji_events, '${_calculateTotalScore(character)} Total Points'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBioItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: RPGTheme.textBrown),
          const SizedBox(width: 8),
          MedievalText.body(text),
        ],
      ),
    );
  }

  int _calculateTotalScore(CharacterProfile character) {
    return character.currentScores.values.fold(0, (sum, value) => sum + value);
  }

  Widget _buildStatsSection(CharacterProfile character) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: RPGTheme.parchment,
            border: Border.all(color: RPGTheme.ornateGold, width: 2),
          ),
          child: MedievalText.heading('Attributes'),
        ),
        const SizedBox(height: 12),
        
        // Stats grid
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: RPGTheme.parchment,
            border: Border.all(color: RPGTheme.ornateGold, width: 2),
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildStatBadge('Kindness', character.currentScores['kindness'] ?? 0, RPGTheme.kindnessRed, Icons.favorite),
              _buildStatBadge('Creativity', character.currentScores['creativity'] ?? 0, RPGTheme.creativityPurple, Icons.brush),
              _buildStatBadge('Consistency', character.currentScores['consistency'] ?? 0, RPGTheme.consistencyBlue, Icons.loop),
              _buildStatBadge('Efficiency', character.currentScores['efficiency'] ?? 0, RPGTheme.efficiencyOrange, Icons.bolt),
              _buildStatBadge('Healing', character.currentScores['healing'] ?? 0, RPGTheme.healingGreen, Icons.spa),
              _buildStatBadge('Love', character.currentScores['relationship'] ?? 0, RPGTheme.loveRose, Icons.favorite_border),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatBadge(String label, int value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          MedievalText.body('$label:'),
          const SizedBox(width: 6),
          MedievalText.heading('$value', color: color),
        ],
      ),
    );
  }

  Widget _buildOtherCharacterCard(CharacterProfile character, GameStateProvider gameState) {
    return Container(
      decoration: BoxDecoration(
        color: RPGTheme.scrollTan.withOpacity(0.8),
        border: Border.all(color: RPGTheme.parchmentDark, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Small portrait
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: RPGTheme.parchmentDark, width: 2),
                color: RPGTheme.darkWood,
              ),
              child: character.characterImageUrl != null
                  ? Image.network(
                      character.characterImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildDefaultPortrait(character),
                    )
                  : _buildDefaultPortrait(character),
            ),
            const SizedBox(width: 16),
            
            // Character info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MedievalText.heading(character.name),
                  const SizedBox(height: 4),
                  MedievalText.body('${character.type} - Level ${character.level}'),
                  const SizedBox(height: 8),
                  MedievalText.body('View Only', color: RPGTheme.parchmentDark),
                ],
              ),
            ),
            
            // View story button
            OrnateButton(
              text: 'View Story',
              icon: Icons.book,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StoryPage(viewOnlyCharacterId: character.id),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(CharacterProfile character, GameStateProvider gameState) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        OrnateButton(
          text: 'Update Scores',
          icon: Icons.edit,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ScoreUpdateDialog(characterId: character.id),
            );
          },
        ),
        OrnateButton(
          text: 'View Stats',
          icon: Icons.bar_chart,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WeeklyStatsPage(character: character),
              ),
            );
          },
        ),
        OrnateButton(
          text: 'My Story',
          icon: Icons.auto_stories,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StoryPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
