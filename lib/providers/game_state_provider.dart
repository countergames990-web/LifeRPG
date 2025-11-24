import 'package:flutter/material.dart';
import '../models/character_profile.dart';
import '../models/story_data.dart';
import '../services/storage_service.dart';

class GameStateProvider with ChangeNotifier {
  final StorageService _storage = StorageService();

  CharacterProfile? _character1;
  CharacterProfile? _character2;
  StoryData? _storyData;
  String _currentCharacterId = '1'; // Which character is currently viewing
  String? _loggedInCharacterName; // Currently logged in character

  CharacterProfile? get character1 => _character1;
  CharacterProfile? get character2 => _character2;
  StoryData? get storyData => _storyData;
  String get currentCharacterId => _currentCharacterId;
  String? get loggedInCharacterName => _loggedInCharacterName;

  CharacterProfile? get currentCharacter =>
      _currentCharacterId == '1' ? _character1 : _character2;

  CharacterProfile? get otherCharacter =>
      _currentCharacterId == '1' ? _character2 : _character1;

  bool get isLoggedIn => _loggedInCharacterName != null;

  Future<void> initialize() async {
    await _storage.init();
    await loadAllData();
  }

  Future<void> loadAllData() async {
    _character1 = await _storage.getCharacterProfile('1');
    _character2 = await _storage.getCharacterProfile('2');
    _storyData = await _storage.getStoryData();
    notifyListeners();
  }

  // Authentication Methods
  Future<bool> loginWithCharacterName(String name) async {
    final allCharacters = await _storage.getAllCharactersByName();
    final character = allCharacters.firstWhere(
      (c) => c.name.toLowerCase() == name.toLowerCase(),
      orElse: () => CharacterProfile(id: '', name: ''),
    );

    if (character.id.isNotEmpty) {
      _loggedInCharacterName = character.name;
      _currentCharacterId = character.id;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> characterNameExists(String name) async {
    final allCharacters = await _storage.getAllCharactersByName();
    return allCharacters.any(
      (c) => c.name.toLowerCase() == name.toLowerCase(),
    );
  }

  Future<void> createNewCharacter(String name, String type, {String? characterImageUrl}) async {
    // Find first available slot
    String characterId;
    if (_character1 == null || _character1!.name == 'Character 1') {
      characterId = '1';
    } else if (_character2 == null || _character2!.name == 'Character 2') {
      characterId = '2';
    } else {
      // Both slots taken, use slot 1
      characterId = '1';
    }

    final newCharacter = CharacterProfile(
      id: characterId,
      name: name,
      type: type,
      characterImageUrl: characterImageUrl,
    );

    await updateCharacterProfile(characterId, newCharacter);
    _loggedInCharacterName = name;
    _currentCharacterId = characterId;
    notifyListeners();
  }

  void logout() {
    _loggedInCharacterName = null;
    notifyListeners();
  }

  void switchCharacter() {
    _currentCharacterId = _currentCharacterId == '1' ? '2' : '1';
    notifyListeners();
  }

  void viewCharacter(String characterId) {
    _currentCharacterId = characterId;
    notifyListeners();
  }

  // Character Profile Methods
  Future<void> updateCharacterProfile(
    String characterId,
    CharacterProfile profile,
  ) async {
    profile.calculateLevel();
    await _storage.saveCharacterProfile(characterId, profile);

    if (characterId == '1') {
      _character1 = profile;
    } else {
      _character2 = profile;
    }
    notifyListeners();
  }

  Future<void> updateCharacterName(String characterId, String name) async {
    final character = characterId == '1' ? _character1 : _character2;
    if (character != null) {
      character.name = name;
      await updateCharacterProfile(characterId, character);
    }
  }

  Future<void> updateCharacterType(String characterId, String type) async {
    final character = characterId == '1' ? _character1 : _character2;
    if (character != null) {
      character.type = type;
      await updateCharacterProfile(characterId, character);
    }
  }

  Future<void> updateCharacterImage(
    String characterId,
    String? imageUrl,
  ) async {
    final character = characterId == '1' ? _character1 : _character2;
    if (character != null) {
      character.characterImageUrl = imageUrl;
      await updateCharacterProfile(characterId, character);
    }
  }

  // Score Methods
  Future<void> addDailyScore(
    String characterId,
    DateTime date,
    Map<String, int> scores,
  ) async {
    final character = characterId == '1' ? _character1 : _character2;
    if (character != null) {
      // Remove existing score for this date if any
      character.scoreHistory.removeWhere(
        (s) =>
            s.date.year == date.year &&
            s.date.month == date.month &&
            s.date.day == date.day,
      );

      // Add new score
      character.scoreHistory.add(DailyScore(date: date, scores: scores));

      // Update current scores (accumulate)
      scores.forEach((key, value) {
        character.currentScores[key] =
            (character.currentScores[key] ?? 0) + value;
      });

      await updateCharacterProfile(characterId, character);
    }
  }

  // Story Methods
  Future<void> updateStory(StoryData newStory) async {
    await _storage.saveStoryData(newStory);
    _storyData = newStory;
    notifyListeners();
  }

  Future<void> updateTownStory(String content) async {
    if (_storyData != null) {
      _storyData!.town = content;
      await updateStory(_storyData!);
    }
  }

  Future<void> updateCharacter1Story(String content) async {
    if (_storyData != null) {
      _storyData!.character1Story = content;
      await updateStory(_storyData!);
    }
  }

  Future<void> updateCharacter2Story(String content) async {
    if (_storyData != null) {
      _storyData!.character2Story = content;
      await updateStory(_storyData!);
    }
  }

  Future<void> updateAdditionalStory(String content) async {
    if (_storyData != null) {
      _storyData!.additionalStory = content;
      await updateStory(_storyData!);
    }
  }

  Future<void> addTownPost(StoryPost post) async {
    if (_storyData != null) {
      _storyData!.townPosts.add(post);
      await updateStory(_storyData!);
    }
  }

  Future<void> addAdditionalPost(StoryPost post) async {
    if (_storyData != null) {
      _storyData!.additionalPosts.add(post);
      await updateStory(_storyData!);
    }
  }

  // Sync Methods (for future external storage sync)
  Future<Map<String, dynamic>> exportData() async {
    return await _storage.exportAllData();
  }

  Future<void> importData(Map<String, dynamic> data) async {
    await _storage.importAllData(data);
    await loadAllData();
  }
}
