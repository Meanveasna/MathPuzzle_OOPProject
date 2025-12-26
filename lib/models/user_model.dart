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
  }) : 
    this.levels = levels ?? {'quick': 1, 'logical': 1},
    this.levelStars = levelStars ?? {'quick': {}, 'logical': {}};

  // Helper to recalculate total score from stars
  void calculateTotalScore() {
    int score = 0;
    levelStars.forEach((mode, levels) {
      levels.forEach((lvl, stars) {
        score += stars * 10;
      });
    });
    totalScore = score;
  }

  String toCsvString() {
    List<String> starEntries = [];
    levelStars.forEach((mode, levels) {
      levels.forEach((level, stars) {
        starEntries.add('$mode:$level:$stars');
      });
    });
    String starsString = starEntries.join('|');
    return '$username,$avatarId,$totalScore,${levels['quick']},${levels['logical']},$starsString';
  }

  factory User.fromCsvList(List<String> row) {
    if (row.isEmpty) return User(username: 'Unknown');

    String username = row[0];
    String avatarId = '0';
    int totalScore = 0;
    int quickLevel = 1;
    int logicalLevel = 1;
    Map<String, Map<String, int>> loadedStars = {'quick': {}, 'logical': {}};

    // Heuristic for Legacy Migration (Old format had email at index 1)
    bool isLegacy = row.length > 1 && row[1].contains('@');

    if (isLegacy) {
      // Old: username, email, phone, gender, profile_path, quick, logical, stars
      if (row.length > 4) avatarId = row[4];
      if (row.length > 5) quickLevel = int.tryParse(row[5]) ?? 1;
      if (row.length > 6) logicalLevel = int.tryParse(row[6]) ?? 1;
      // Stars at 7
      if (row.length > 7) {
         _parseStars(row[7], loadedStars);
      }
    } else {
      // New: username, avatarId, totalScore, quick, logical, stars
      if (row.length > 1) avatarId = row[1];
      if (row.length > 2) totalScore = int.tryParse(row[2]) ?? 0;
      if (row.length > 3) quickLevel = int.tryParse(row[3]) ?? 1;
      if (row.length > 4) logicalLevel = int.tryParse(row[4]) ?? 1;
      if (row.length > 5) {
         _parseStars(row[5], loadedStars);
      }
    }
    
    User u = User(
      username: username,
      avatarId: avatarId.isNotEmpty ? avatarId : '0',
      totalScore: totalScore,
      levels: {'quick': quickLevel, 'logical': logicalLevel},
      levelStars: loadedStars,
    );
    // Auto-fix score if 0 but stars exist
    if (u.totalScore == 0 && u.levelStars.isNotEmpty) {
      u.calculateTotalScore();
    }
    return u;
  }

  static void _parseStars(String starsString, Map<String, Map<String, int>> loadedStars) {
    if (starsString.isNotEmpty) {
      List<String> entries = starsString.split('|');
      for (var entry in entries) {
        var parts = entry.split(':');
        if (parts.length == 3) {
          String mode = parts[0];
          String level = parts[1];
          int stars = int.tryParse(parts[2]) ?? 0;
          if (!loadedStars.containsKey(mode)) loadedStars[mode] = {};
          loadedStars[mode]![level] = stars;
        }
      }
    }
  }
}
