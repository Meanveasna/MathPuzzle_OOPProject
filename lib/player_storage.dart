import 'models/user_model.dart';
import 'core/file_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerRepository {
  static final PlayerRepository _instance = PlayerRepository._internal();

  factory PlayerRepository() => _instance;

  PlayerRepository._internal();

  List<User> _users = [];
  User? _currentUser;
  bool _initialized = false;

  final FileStorage _storage = FileStorage();

  /// Initialize repository
  Future<void> init() async {
    if (_currentUser != null) return;
    _currentUser = await _storage.loadUser();
  }

  /// Check or create first-time user
  Future<bool> checkUser(String username) async {
    await init();
    if (_currentUser != null) return false; // user already exists
    _currentUser = User(username: username);
    await _storage.saveUser(_currentUser!);
    return true; // first-time user
  }

  /// Get current user
  Future<User?> getUser() async {
    await init();
    return _currentUser;
  }

  /// Update current user
  Future<void> updateUser(User user) async {
    _currentUser = user;
    await _storage.saveUser(user);
  }

  /// Reset repository and user data
  Future<void> resetAll() async {
    // Clear in-memory state
    _users.clear();
    _currentUser = null;
    _initialized = false;

    // Clear storage
    await _storage.deleteUser();

    // Clear any remaining SharedPreferences keys
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
