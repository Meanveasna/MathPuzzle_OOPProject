class User {
  String username;
  String avatarId; // Emoji/Icon index
  int totalScore;
  Map<String, int> levels;
  Map<String, Map<String, int>> levelStars;

  User({
    required this.username,
    this.avatarId = '0',
    this.totalScore = 0,
    Map<String, int>? levels,
    Map<String, Map<String, int>>? levelStars,
  })  : levels = levels ?? {'quick': 1, 'logical': 1},
        levelStars = levelStars ?? {'quick': {}, 'logical': {}};

  // =========================
  // SCORE CALCULATION
  // =========================
  void calculateTotalScore() {
    int score = 0;
    levelStars.forEach((mode, levels) {
      levels.forEach((lvl, stars) {
        score += stars * 10;
      });
    });
    totalScore = score;
  }

  int get totalStars {
    int starsCount = 0;
    levelStars.forEach((mode, levels) {
      levels.forEach((lvl, stars) {
        starsCount += stars;
      });
    });
    return starsCount;
  }

  // =========================
  // SHARED PREFERENCES SUPPORT
  // =========================

  /// Convert User → Map (for storage)
  // Convert User to Map (for JSON)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'avatarId': avatarId,
      'totalScore': totalScore,
      'levels': levels,
      'levelStars': levelStars,
    };
  }

  // Create User from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ?? 'Unknown',
      avatarId: map['avatarId'] ?? '0',
      totalScore: map['totalScore'] ?? 0,
      levels: Map<String, int>.from(map['levels'] ?? {'quick': 1, 'logical': 1}),
      levelStars: (map['levelStars'] as Map?)?.map((k, v) => MapEntry(
            k.toString(),
            Map<String, int>.from(v as Map),
          )) ??
          {'quick': {}, 'logical': {}},
    );
  }
}
