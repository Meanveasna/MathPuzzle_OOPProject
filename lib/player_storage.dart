import 'models/user_model.dart';
import 'core/file_storage.dart';

class PlayerRepository {
  static final PlayerRepository _instance = PlayerRepository._internal();
  
  factory PlayerRepository() {
    return _instance;
  }

  PlayerRepository._internal();

  List<User> _users = [];
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    final rows = await FileStorage().readCsv();
    // Assuming First Row could be header, we can check or just parse
    // For simplicity, let's say NO header for now, or we check content
    _users.clear();
    for (var row in rows) {
      if (row.isNotEmpty && row[0] != 'username') { // Basic header check
         _users.add(User.fromCsvList(row));
      }
    }
    _initialized = true;
  }

  Future<bool> checkUser(String username) async {
    await _init();
    
    // Case-insensitive check
    var existingUser = _users.where((user) => user.username.toLowerCase() == username.toLowerCase());
    
    if (existingUser.isEmpty) {
      _users.add(User(username: username));
      await _save();
      return true; // isNewUser
    }
    return false; // Not new, login successful
  }

  // Get current user object
  Future<User?> getUser(String username) async {
    await _init();
    try {
      return _users.firstWhere((u) => u.username.toLowerCase() == username.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUser(User updatedUser) async {
    int index = _users.indexWhere((u) => u.username == updatedUser.username);
    if (index != -1) {
      _users[index] = updatedUser;
      await _save();
    }
  }

  Future<void> _save() async {
    List<String> lines = [];
    lines.add('username,email,gender,phone,image_path'); // Header
    lines.addAll(_users.map((u) => u.toCsvString()));
    await FileStorage().writeCsv(lines);
  }
}
