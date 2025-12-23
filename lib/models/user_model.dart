class User {
  String username;
  String email;
  String gender;
  String phoneNumber;
  String profileImagePath;
  Map<String, int> levels;

  User({
    required this.username,
    this.email = '',
    this.gender = '',
    this.phoneNumber = '',
    this.profileImagePath = '',
    Map<String, int>? levels,
  }) : this.levels = levels ?? {'quick': 1, 'logical': 1};

  // Convert to CSV string: username,email,gender,phone,imagePath,quickLevel,logicalLevel
  String toCsvString() {
    return '$username,$email,$gender,$phoneNumber,$profileImagePath,${levels['quick']},${levels['logical']}';
  }

  // Create from CSV List
  factory User.fromCsvList(List<String> row) {
    if (row.isEmpty) return User(username: 'Unknown');
    Map<String, int> loadedLevels = {'quick': 1, 'logical': 1};
    if (row.length > 5) loadedLevels['quick'] = int.tryParse(row[5]) ?? 1;
    if (row.length > 6) loadedLevels['logical'] = int.tryParse(row[6]) ?? 1;

    return User(
      username: row[0],
      email: row.length > 1 ? row[1] : '',
      gender: row.length > 2 ? row[2] : '',
      phoneNumber: row.length > 3 ? row[3] : '',
      profileImagePath: row.length > 4 ? row[4] : '',
      levels: loadedLevels,
    );
  }
}
