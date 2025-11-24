import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character_profile.dart';
import '../models/story_data.dart';

class StorageService {
  static const String _character1Key = 'character_1_profile';
  static const String _character2Key = 'character_2_profile';
  static const String _storyKey = 'story_data';
  static const String _lastSyncKey = 'last_sync_timestamp';
  static const int _maxStorageSize = 4 * 1024 * 1024; // 4MB limit for localStorage

  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Character Profile Methods
  Future<void> saveCharacterProfile(
    String characterId,
    CharacterProfile profile,
  ) async {
    await _ensureInitialized();
    final key = characterId == '1' ? _character1Key : _character2Key;
    final jsonString = profile.toJsonString();
    
    // Check storage size before saving
    if (jsonString.length > _maxStorageSize) {
      // If image is too large, remove it and save without image
      profile.characterImageUrl = null;
      final reducedJsonString = profile.toJsonString();
      await _prefs!.setString(key, reducedJsonString);
      throw Exception('Character image too large. Profile saved without image. Please use a smaller image.');
    }
    
    await _prefs!.setString(key, jsonString);
    await _updateSyncTimestamp();
  }

  Future<CharacterProfile?> getCharacterProfile(String characterId) async {
    await _ensureInitialized();
    final key = characterId == '1' ? _character1Key : _character2Key;
    final jsonString = _prefs!.getString(key);

    if (jsonString == null) {
      // Return default profile if none exists
      return CharacterProfile(
        id: characterId,
        name: characterId == '1' ? 'Character 1' : 'Character 2',
      );
    }

    return CharacterProfile.fromJsonString(jsonString);
  }

  Future<List<CharacterProfile>> getAllCharacters() async {
    final char1 = await getCharacterProfile('1');
    final char2 = await getCharacterProfile('2');
    return [char1!, char2!];
  }

  Future<List<CharacterProfile>> getAllCharactersByName() async {
    final characters = await getAllCharacters();
    return characters.where((c) => c.name != 'Character 1' && c.name != 'Character 2').toList();
  }

  // Story Data Methods
  Future<void> saveStoryData(StoryData story) async {
    await _ensureInitialized();
    final jsonString = story.toJsonString();
    
    // Check storage size before saving
    if (jsonString.length > _maxStorageSize) {
      // Remove images from posts if storage is too large by creating new posts without images
      final townPostsNoImages = story.townPosts.map((post) => StoryPost(
        characterName: post.characterName,
        characterId: post.characterId,
        text: post.text,
        imageUrl: null,
        timestamp: post.timestamp,
      )).toList();
      
      final additionalPostsNoImages = story.additionalPosts.map((post) => StoryPost(
        characterName: post.characterName,
        characterId: post.characterId,
        text: post.text,
        imageUrl: null,
        timestamp: post.timestamp,
      )).toList();
      
      final reducedStory = StoryData(
        character1Story: story.character1Story,
        character2Story: story.character2Story,
        townPosts: townPostsNoImages,
        additionalPosts: additionalPostsNoImages,
      );
      
      final reducedJsonString = reducedStory.toJsonString();
      await _prefs!.setString(_storyKey, reducedJsonString);
      throw Exception('Story data too large. Images removed to save space. Consider using external image hosting.');
    }
    
    await _prefs!.setString(_storyKey, jsonString);
    await _updateSyncTimestamp();
  }

  Future<StoryData> getStoryData() async {
    await _ensureInitialized();
    final jsonString = _prefs!.getString(_storyKey);

    if (jsonString == null) {
      return StoryData();
    }

    return StoryData.fromJsonString(jsonString);
  }

  // Sync Methods
  Future<void> _updateSyncTimestamp() async {
    await _prefs!.setInt(_lastSyncKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<DateTime?> getLastSyncTimestamp() async {
    await _ensureInitialized();
    final timestamp = _prefs!.getInt(_lastSyncKey);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  // Export all data (for syncing to external storage)
  Future<Map<String, dynamic>> exportAllData() async {
    final char1 = await getCharacterProfile('1');
    final char2 = await getCharacterProfile('2');
    final story = await getStoryData();

    return {
      'character1': char1?.toJson(),
      'character2': char2?.toJson(),
      'story': story.toJson(),
      'lastSync': DateTime.now().toIso8601String(),
    };
  }

  // Import all data (from external storage)
  Future<void> importAllData(Map<String, dynamic> data) async {
    if (data['character1'] != null) {
      final char1 = CharacterProfile.fromJson(data['character1']);
      await saveCharacterProfile('1', char1);
    }

    if (data['character2'] != null) {
      final char2 = CharacterProfile.fromJson(data['character2']);
      await saveCharacterProfile('2', char2);
    }

    if (data['story'] != null) {
      final story = StoryData.fromJson(data['story']);
      await saveStoryData(story);
    }
  }

  // Clear all data (for testing)
  Future<void> clearAllData() async {
    await _ensureInitialized();
    await _prefs!.clear();
  }

  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
}
