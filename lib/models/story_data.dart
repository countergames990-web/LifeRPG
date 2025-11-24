import 'dart:convert';

class StoryPost {
  final String characterName;
  final String characterId;
  final String text;
  final String? imageUrl;
  final DateTime timestamp;

  StoryPost({
    required this.characterName,
    required this.characterId,
    required this.text,
    this.imageUrl,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'characterName': characterName,
      'characterId': characterId,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory StoryPost.fromJson(Map<String, dynamic> json) {
    return StoryPost(
      characterName: json['characterName'] as String,
      characterId: json['characterId'] as String,
      text: json['text'] as String,
      imageUrl: json['imageUrl'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class StoryData {
  String town;
  String character1Story;
  String character2Story;
  String additionalStory;
  List<StoryPost> townPosts;
  List<StoryPost> additionalPosts;
  DateTime lastUpdated;

  StoryData({
    this.town = '',
    this.character1Story = '',
    this.character2Story = '',
    this.additionalStory = '',
    List<StoryPost>? townPosts,
    List<StoryPost>? additionalPosts,
    DateTime? lastUpdated,
  }) : townPosts = townPosts ?? [],
       additionalPosts = additionalPosts ?? [],
       lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'town': town,
      'character1Story': character1Story,
      'character2Story': character2Story,
      'additionalStory': additionalStory,
      'townPosts': townPosts.map((p) => p.toJson()).toList(),
      'additionalPosts': additionalPosts.map((p) => p.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory StoryData.fromJson(Map<String, dynamic> json) {
    return StoryData(
      town: json['town'] as String? ?? '',
      character1Story: json['character1Story'] as String? ?? '',
      character2Story: json['character2Story'] as String? ?? '',
      additionalStory: json['additionalStory'] as String? ?? '',
      townPosts: (json['townPosts'] as List<dynamic>?)
          ?.map((p) => StoryPost.fromJson(p as Map<String, dynamic>))
          .toList(),
      additionalPosts: (json['additionalPosts'] as List<dynamic>?)
          ?.map((p) => StoryPost.fromJson(p as Map<String, dynamic>))
          .toList(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }

  String toJsonString() => json.encode(toJson());

  factory StoryData.fromJsonString(String jsonString) {
    return StoryData.fromJson(json.decode(jsonString));
  }
}
