import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class FileStorage {
  static final FileStorage _instance = FileStorage._internal();
  factory FileStorage() => _instance;
  FileStorage._internal();

  static const String _keyUser = 'current_user';

  /// Save user to SharedPreferences
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(user.toMap());
    await prefs.setString(_keyUser, jsonString);
  }

  /// Load user from SharedPreferences
  Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_keyUser);
    if (jsonString == null) return null;
    try {
      Map<String, dynamic> map = jsonDecode(jsonString);
      return User.fromMap(map);
    } catch (e) {
      print("Error decoding user JSON: $e");
      return null;
    }
  }

  /// Check if a user already exists
  Future<bool> hasUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyUser);
  }

  /// Delete user (optional)
  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }
}
