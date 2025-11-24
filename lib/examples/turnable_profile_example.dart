import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../widgets/turnable_book.dart';
import '../widgets/book_page.dart';
import '../theme/medieval_theme.dart';

/// Example of how to use TurnableBook with your profile pages
/// This replaces the AnimatedFrameBook with realistic page turning
class TurnableProfileExample extends StatefulWidget {
  const TurnableProfileExample({super.key});

  @override
  State<TurnableProfileExample> createState() => _TurnableProfileExampleState();
}

class _TurnableProfileExampleState extends State<TurnableProfileExample> {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final character = gameState.currentCharacter;

    if (character == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: MedievalColors.woodDark,
      appBar: AppBar(
        title: Text('${character.name}\'s Chronicle'),
        backgroundColor: MedievalColors.leather,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: TurnableBook(pages: _buildPages(gameState)),
        ),
      ),
    );
  }

  List<Widget> _buildPages(GameStateProvider gameState) {
    final character = gameState.currentCharacter!;

    return [
      // Page 1: Book Cover
      _buildCoverPage(character.name),

      // Page 2-3: Profile Spread
      BookSpread(
        pageNumber: 1,
        leftPage: _buildProfileLeft(character),
        rightPage: _buildProfileRight(character),
      ),

      // Page 4-5: Stats Spread
      BookSpread(
        pageNumber: 2,
        leftPage: _buildStatsLeft(character),
        rightPage: _buildStatsRight(character),
      ),

      // Page 6-7: Story Spread
      BookSpread(
        pageNumber: 3,
        leftPage: _buildStoryLeft(character),
        rightPage: _buildStoryRight(character),
      ),
    ];
  }

  // Cover page
  Widget _buildCoverPage(String characterName) {
    return BookCover(title: characterName, subtitle: 'Life Chronicle');
  }

  // Profile - Left page
  Widget _buildProfileLeft(character) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookPageHeader(title: 'Character Profile'),
          const SizedBox(height: 24),

          // Character icon/avatar
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: MedievalColors.gold.withOpacity(0.2),
                border: Border.all(color: MedievalColors.gold, width: 3),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(Icons.person, size: 80, color: MedievalColors.gold),
            ),
          ),

          const SizedBox(height: 24),

          BookPageSection(
            title: 'Name',
            child: BookText(text: character.name),
          ),

          BookDivider(),

          BookPageSection(
            title: 'Total Score',
            child: Row(
              children: [
                Icon(Icons.stars, color: MedievalColors.gold, size: 20),
                const SizedBox(width: 8),
                BookText(
                  text:
                      '${character.currentScores.values.fold(0, (sum, value) => sum + value)} points',
                  color: MedievalColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Profile - Right page
  Widget _buildProfileRight(character) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookPageHeader(title: 'Recent Quests'),
          const SizedBox(height: 16),

          // Recent activities
          ...character.currentScores.entries.take(5).map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: MedievalColors.gold,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: BookText(text: entry.key, fontSize: 14)),
                  BookText(
                    text: '+${entry.value}',
                    color: MedievalColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            );
          }).toList(),

          if (character.currentScores.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: BookText(
                  text: 'No quests completed yet.\nBegin your journey!',
                  color: MedievalColors.inkBrown.withOpacity(0.6),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Stats - Left page
  Widget _buildStatsLeft(character) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookPageHeader(title: 'Weekly Statistics'),
          const SizedBox(height: 24),

          BookPageSection(
            title: 'Current Week',
            child: Column(
              children: [
                _buildStatBar('Mon', 0),
                _buildStatBar('Tue', 0),
                _buildStatBar('Wed', 0),
                _buildStatBar('Thu', 0),
                _buildStatBar('Fri', 0),
                _buildStatBar('Sat', 0),
                _buildStatBar('Sun', 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBar(String day, int score) {
    final percentage = (score / 100).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 40, child: BookText(text: day, fontSize: 12)),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: MedievalColors.parchmentAged,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: MedievalColors.inkBrown.withOpacity(0.3),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          MedievalColors.gold,
                          MedievalColors.gold.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: BookText(
              text: '$score',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: MedievalColors.gold,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // Stats - Right page
  Widget _buildStatsRight(character) {
    final totalWeekly = character.currentScores.values.fold(0, (a, b) => a + b);
    final dailyAverage = totalWeekly / 7;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookPageHeader(title: 'Achievements'),
          const SizedBox(height: 24),

          BookPageSection(
            title: 'This Week',
            child: Column(
              children: [
                _buildAchievementStat('Total Points', totalWeekly.toString()),
                _buildAchievementStat(
                  'Daily Average',
                  dailyAverage.toStringAsFixed(1),
                ),
                _buildAchievementStat('Best Day', 'Mon'),
                _buildAchievementStat('Streak', '0 days'),
              ],
            ),
          ),

          BookDivider(),

          BookPageSection(
            title: 'Badges Earned',
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                if (totalWeekly > 100)
                  _buildBadge('Centurion', Icons.military_tech),
                if (dailyAverage > 20)
                  _buildBadge('Consistent', Icons.show_chart),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BookText(text: label),
          BookText(
            text: value,
            fontWeight: FontWeight.bold,
            color: MedievalColors.gold,
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: MedievalColors.gold.withOpacity(0.2),
            border: Border.all(color: MedievalColors.gold, width: 2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: MedievalColors.gold, size: 30),
        ),
        const SizedBox(height: 4),
        BookText(text: label, fontSize: 10),
      ],
    );
  }

  // Story - Left page
  Widget _buildStoryLeft(character) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookPageHeader(title: 'Your Story'),
          const SizedBox(height: 24),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: BookText(
                text:
                    'Your adventure begins here...\nComplete quests to write your story.',
                color: MedievalColors.inkBrown.withOpacity(0.6),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Story - Right page
  Widget _buildStoryRight(character) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48), // Align with left page content
          const SizedBox.shrink(),
        ],
      ),
    );
  }
}
