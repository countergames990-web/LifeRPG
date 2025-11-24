import 'dart:convert';

class CharacterProfile {
  final String id;
  String name;
  int level;
  String type; // e.g., "Warrior", "Mage", "Healer"
  String? characterImageUrl;
  Map<String, int> currentScores; // Current score values
  List<DailyScore> scoreHistory;
  DateTime lastUpdated;

  CharacterProfile({
    required this.id,
    required this.name,
    this.level = 1,
    this.type = 'Adventurer',
    this.characterImageUrl,
    Map<String, int>? currentScores,
    List<DailyScore>? scoreHistory,
    DateTime? lastUpdated,
  }) : currentScores =
           currentScores ??
           {
             'kindness': 0,
             'creativity': 0,
             'consistency': 0,
             'efficiency': 0,
             'healing': 0,
             'relationship': 0,
           },
       scoreHistory = scoreHistory ?? [],
       lastUpdated = lastUpdated ?? DateTime.now();

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'type': type,
      'characterImageUrl': characterImageUrl,
      'currentScores': currentScores,
      'scoreHistory': scoreHistory.map((s) => s.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Create from JSON
  factory CharacterProfile.fromJson(Map<String, dynamic> json) {
    return CharacterProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      level: json['level'] as int? ?? 1,
      type: json['type'] as String? ?? 'Adventurer',
      characterImageUrl: json['characterImageUrl'] as String?,
      currentScores: Map<String, int>.from(json['currentScores'] ?? {}),
      scoreHistory:
          (json['scoreHistory'] as List?)
              ?.map((s) => DailyScore.fromJson(s))
              .toList() ??
          [],
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  // Calculate level based on total score
  void calculateLevel() {
    int totalScore = currentScores.values.fold(0, (sum, score) => sum + score);
    level = (totalScore ~/ 100) + 1; // Level up every 100 points
  }

  // Get weekly scores for graph
  List<DailyScore> getWeeklyScores() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return scoreHistory.where((score) {
      return score.date.isAfter(startOfWeek.subtract(const Duration(days: 1)));
    }).toList();
  }

  String toJsonString() => json.encode(toJson());

  factory CharacterProfile.fromJsonString(String jsonString) {
    return CharacterProfile.fromJson(json.decode(jsonString));
  }
}

class DailyScore {
  final DateTime date;
  final Map<String, int> scores;

  DailyScore({required this.date, required this.scores});

  Map<String, dynamic> toJson() {
    return {'date': date.toIso8601String(), 'scores': scores};
  }

  factory DailyScore.fromJson(Map<String, dynamic> json) {
    return DailyScore(
      date: DateTime.parse(json['date'] as String),
      scores: Map<String, int>.from(json['scores']),
    );
  }
}
