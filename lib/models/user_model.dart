class User {
  final String username;

  // progress for levels (quick, logical, truefalse)
  Map<String, int> levels;

  // stars per level:  levelStars['quick']['1'] = 3
  Map<String, Map<String, int>> levelStars;

  // profile
  String avatarId;

  // total score across modes
  int totalScore;

  User({
    required this.username,
    Map<String, int>? levels,
    Map<String, Map<String, int>>? levelStars,
    this.avatarId = '',
    this.totalScore = 0,
  })  : levels = levels ?? {'quick': 1, 'logical': 1, 'truefalse': 1},
        levelStars = levelStars ?? {'quick': {}, 'logical': {}, 'truefalse': {}};

  void calculateTotalScore() {
    int sum = 0;
    for (final mode in levelStars.keys) {
      for (final stars in levelStars[mode]!.values) {
        sum += stars;
      }
    }
    totalScore = sum;
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'levels': levels,
    'levelStars': levelStars,
    'avatarId': avatarId,
    'totalScore': totalScore,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    // levels
    final levels = <String, int>{};
    final lv = json['levels'];
    if (lv is Map) {
      lv.forEach((k, v) => levels['$k'] = (v as num).toInt());
    }

    // levelStars
    final stars = <String, Map<String, int>>{};
    final ls = json['levelStars'];
    if (ls is Map) {
      ls.forEach((mode, map) {
        final m = <String, int>{};
        if (map is Map) {
          map.forEach((level, v) => m['$level'] = (v as num).toInt());
        }
        stars['$mode'] = m;
      });
    }

    return User(
      username: json['username'] ?? '',
      levels: levels.isEmpty ? null : levels,
      levelStars: stars.isEmpty ? null : stars,
      avatarId: json['avatarId'] ?? '',
      totalScore: (json['totalScore'] is num) ? (json['totalScore'] as num).toInt() : 0,
    );
  }
}
