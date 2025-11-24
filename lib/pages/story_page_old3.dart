import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../theme/rpg_theme.dart';

class StoryPage extends StatefulWidget {
  final String? viewOnlyCharacterId; // If set, page is read-only for that character
  
  const StoryPage({super.key, this.viewOnlyCharacterId});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _townController;
  late TextEditingController _char1Controller;
  late TextEditingController _char2Controller;
  late TextEditingController _additionalController;

  bool get isViewOnly => widget.viewOnlyCharacterId != null;
  String get viewingCharacterId => widget.viewOnlyCharacterId ?? '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _townController = TextEditingController();
    _char1Controller = TextEditingController();
    _char2Controller = TextEditingController();
    _additionalController = TextEditingController();

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStoryData();
    });
  }

  void _loadStoryData() {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    final story = gameState.storyData;

    if (story != null) {
      _townController.text = story.town;
      _char1Controller.text = story.character1Story;
      _char2Controller.text = story.character2Story;
      _additionalController.text = story.additionalStory;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _townController.dispose();
    _char1Controller.dispose();
    _char2Controller.dispose();
    _additionalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: RPGTheme.mediumWood,
                border: Border(
                  bottom: BorderSide(color: RPGTheme.ornateGold, width: 2),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: RPGTheme.ornateGold,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    MedievalText.title(isViewOnly ? 'View Chronicle' : 'Story Chronicle'),
                  ],
                ),
              ),
            ),
            // Tabs (only show if not view-only)
            if (!isViewOnly)
              Container(
                color: RPGTheme.mediumWood,
                child: TabBar(
                  controller: _tabController,
                  labelColor: RPGTheme.ornateGold,
                  unselectedLabelColor: RPGTheme.parchmentDark,
                  indicatorColor: RPGTheme.ornateGold,
                  tabs: const [
                    Tab(icon: Icon(Icons.location_city), text: 'Town'),
                    Tab(icon: Icon(Icons.person), text: 'Hero 1'),
                    Tab(icon: Icon(Icons.person_outline), text: 'Hero 2'),
                    Tab(icon: Icon(Icons.auto_stories), text: 'Lore'),
                  ],
                ),
              ),
            // Content
            Expanded(
              child: Consumer<GameStateProvider>(
                builder: (context, gameState, child) {
                  // Determine which tabs to show based on view mode
                  if (isViewOnly) {
                    // Show only the story for the character being viewed
                    return _buildStoryTab(
                      title: '${viewingCharacterId == '1' ? gameState.character1?.name : gameState.character2?.name}\'s Chronicle',
                      controller: viewingCharacterId == '1' ? _char1Controller : _char2Controller,
                      onSave: () {}, // No save in view-only mode
                      hint: 'This character\'s story...',
                      readOnly: true,
                    );
                  }
                  
                  // Normal editable tabs for own story
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildStoryTab(
                        title: 'Town Story',
                        controller: _townController,
                        onSave: () => gameState.updateTownStory(_townController.text),
                        hint:
                            'Describe your town, its people, landmarks, and atmosphere...',
                        readOnly: false,
                      ),
                      _buildStoryTab(
                        title:
                            '${gameState.character1?.name ?? "Character 1"}\'s Chronicle',
                        controller: _char1Controller,
                        onSave: () =>
                            gameState.updateCharacter1Story(_char1Controller.text),
                        hint:
                            'Write about this hero\'s background, goals, and adventures...',
                        readOnly: gameState.currentCharacterId != '1',
                      ),
                      _buildStoryTab(
                        title:
                            '${gameState.character2?.name ?? "Character 2"}\'s Chronicle',
                        controller: _char2Controller,
                        onSave: () =>
                            gameState.updateCharacter2Story(_char2Controller.text),
                        hint:
                            'Write about this hero\'s background, goals, and adventures...',
                        readOnly: gameState.currentCharacterId != '2',
                      ),
                      _buildStoryTab(
                        title: 'Additional Lore',
                        controller: _additionalController,
                        onSave: () =>
                            gameState.updateAdditionalStory(_additionalController.text),
                        hint:
                            'Write additional lore, side stories, or world-building details...',
                        readOnly: false,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryTab({
    required String title,
    required TextEditingController controller,
    required VoidCallback onSave,
    required String hint,
    required bool readOnly,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: MedievalText.heading(title, color: RPGTheme.parchment),
              ),
              if (readOnly)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: RPGTheme.parchmentDark.withOpacity(0.3),
                    border: Border.all(color: RPGTheme.parchmentDark, width: 2),
                  ),
                  child: MedievalText.body(
                    'VIEW ONLY',
                    color: RPGTheme.parchmentDark,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          MedievalDivider(),
          const SizedBox(height: 16),
          Expanded(
            child: ScrollContainer(
              child: TextField(
                controller: controller,
                maxLines: null,
                expands: true,
                readOnly: readOnly,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(
                  fontFamily: 'Crimson Text',
                  fontSize: 16,
                  color: Color(0xFF3D2817),
                ),
                decoration: InputDecoration(
                  hintText: readOnly ? '' : hint,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!readOnly)
            OrnateButton(
              text: 'Save Chronicle',
              icon: Icons.save,
              onPressed: () {
                onSave();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: MedievalText.body(
                      'Chronicle saved!',
                      color: RPGTheme.parchment,
                    ),
                    backgroundColor: RPGTheme.mediumWood,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
