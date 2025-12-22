class User {
  String username;
  String email;
  String gender;
  String phoneNumber;
  String profileImagePath;

  User({
    required this.username,
    this.email = '',
    this.gender = '',
    this.phoneNumber = '',
    this.profileImagePath = '',
  });

  // Convert to CSV string: username,email,gender,phone,imagePath
  String toCsvString() {
    return '$username,$email,$gender,$phoneNumber,$profileImagePath';
  }

  // Create from CSV List
  factory User.fromCsvList(List<String> row) {
    if (row.isEmpty) return User(username: 'Unknown');
    return User(
      username: row[0],
      email: row.length > 1 ? row[1] : '',
      gender: row.length > 2 ? row[2] : '',
      phoneNumber: row.length > 3 ? row[3] : '',
      profileImagePath: row.length > 4 ? row[4] : '',
    );
  }
}
