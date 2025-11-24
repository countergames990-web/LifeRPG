import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import '../models/character_profile.dart';
import '../theme/rpg_theme.dart';
import 'profile_page.dart';

class CharacterSelectionPage extends StatefulWidget {
  const CharacterSelectionPage({super.key});

  @override
  State<CharacterSelectionPage> createState() => _CharacterSelectionPageState();
}

class _CharacterSelectionPageState extends State<CharacterSelectionPage> {
  final _char1NameController = TextEditingController();
  final _char2NameController = TextEditingController();

  String _char1Type = 'Warrior';
  String _char2Type = 'Mage';

  final List<String> _characterTypes = [
    'Warrior',
    'Mage',
    'Healer',
    'Rogue',
    'Paladin',
    'Ranger',
    'Bard',
    'Adventurer',
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingCharacters();
  }

  Future<void> _loadExistingCharacters() async {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);

    if (gameState.character1 != null) {
      _char1NameController.text = gameState.character1!.name;
      _char1Type = gameState.character1!.type;
    }

    if (gameState.character2 != null) {
      _char2NameController.text = gameState.character2!.name;
      _char2Type = gameState.character2!.type;
    }

    setState(() {});
  }

  Future<void> _selectCharacter(String characterId) async {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);

    // Create characters if they don't exist
    if (gameState.character1 == null) {
      final char1 = CharacterProfile(
        id: '1',
        name: _char1NameController.text.isEmpty
            ? 'Character 1'
            : _char1NameController.text,
        type: _char1Type,
      );
      await gameState.updateCharacterProfile('1', char1);
    }

    if (gameState.character2 == null) {
      final char2 = CharacterProfile(
        id: '2',
        name: _char2NameController.text.isEmpty
            ? 'Character 2'
            : _char2NameController.text,
        type: _char2Type,
      );
      await gameState.updateCharacterProfile('2', char2);
    }

    // Set the selected character
    gameState.viewCharacter(characterId);

    // Navigate directly to profile page
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const ProfilePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateProvider>(context);
    final bool charactersExist =
        gameState.character1 != null && gameState.character2 != null;

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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Icon(Icons.shield, size: 80, color: RPGTheme.ornateGold),
                  const SizedBox(height: 16),
                  MedievalText.title(
                    charactersExist
                        ? 'Choose Your Hero'
                        : 'Create Your Heroes',
                  ),
                  const SizedBox(height: 8),
                  MedievalDivider(),
                  const SizedBox(height: 32),

                  // Character Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildCharacterCard(
                          characterId: '1',
                          nameController: _char1NameController,
                          selectedType: _char1Type,
                          onTypeChanged: (type) =>
                              setState(() => _char1Type = type!),
                          characterExists: gameState.character1 != null,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildCharacterCard(
                          characterId: '2',
                          nameController: _char2NameController,
                          selectedType: _char2Type,
                          onTypeChanged: (type) =>
                              setState(() => _char2Type = type!),
                          characterExists: gameState.character2 != null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterCard({
    required String characterId,
    required TextEditingController nameController,
    required String selectedType,
    required void Function(String?) onTypeChanged,
    required bool characterExists,
  }) {
    return ScrollContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Character Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: RPGTheme.scrollTan,
              border: Border.all(color: RPGTheme.ornateGold, width: 3),
            ),
            child: Icon(
              _getTypeIcon(selectedType),
              size: 50,
              color: RPGTheme.darkWood,
            ),
          ),
          const SizedBox(height: 24),

          // Name Input
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: RPGTheme.textBrown, width: 2),
              color: characterExists ? RPGTheme.parchmentDark : Colors.white,
            ),
            child: TextField(
              controller: nameController,
              enabled: !characterExists,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Crimson Text',
                fontSize: 16,
                color: Color(0xFF3D2817),
              ),
              decoration: InputDecoration(
                hintText: 'Character Name',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Type Dropdown
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: RPGTheme.textBrown, width: 2),
              color: characterExists ? RPGTheme.parchmentDark : Colors.white,
            ),
            child: DropdownButtonFormField<String>(
              value: selectedType,
              onChanged: characterExists ? null : onTypeChanged,
              decoration: const InputDecoration(
                labelText: 'Class',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
              ),
              items: _characterTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Icon(_getTypeIcon(type), size: 20, color: RPGTheme.textBrown),
                      const SizedBox(width: 8),
                      Text(
                        type,
                        style: const TextStyle(
                          fontFamily: 'Crimson Text',
                          fontSize: 16,
                          color: Color(0xFF3D2817),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Select Button
          SizedBox(
            width: double.infinity,
            child: OrnateButton(
              text: 'SELECT',
              onPressed: () => _selectCharacter(characterId),
              icon: Icons.check_circle,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Warrior':
        return Icons.shield;
      case 'Mage':
        return Icons.auto_fix_high;
      case 'Healer':
        return Icons.healing;
      case 'Rogue':
        return Icons.visibility_off;
      case 'Paladin':
        return Icons.wb_sunny;
      case 'Ranger':
        return Icons.nature;
      case 'Bard':
        return Icons.music_note;
      default:
        return Icons.person;
    }
  }

  @override
  void dispose() {
    _char1NameController.dispose();
    _char2NameController.dispose();
    super.dispose();
  }
}
