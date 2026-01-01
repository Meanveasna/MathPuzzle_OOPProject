import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'player_storage.dart';
import 'main_menu_page.dart';
import 'core/app_theme.dart';
import 'models/user_model.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;


  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();

    _checkExistingUser(); // ⚡ check for saved user
  }

  void _checkExistingUser() async {
    User? user = await PlayerRepository().getUser();
    if (user != null) {
      // User already exists → skip FirstPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainMenuPage(username: user.username),
        ),
      );
    }
  }


    @override
    void dispose() {
      _animController.dispose();
      _usernameController.dispose();
      super.dispose();
    }

    /// ----------------------------
    /// SHARED PREFERENCES LOGIC
    /// ----------------------------

    Future<bool> _checkUser(String username) async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('user_$username');
    }

    Future<void> _createUser(String username) async {
      final prefs = await SharedPreferences.getInstance();

      // default user data
      final Map<String, dynamic> userData = {
        'username': username,
        'avatarId': '0',
        'totalScore': 0,
        'levels': {'quick': 1, 'logical': 1},
        'levelStars': {'quick': {}, 'logical': {}},
      };

      prefs.setString('user_$username', userData.toString());
      prefs.setString('current_user', username);
    }

    Future<void> _setCurrentUser(String username) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('current_user', username);
    }

    /// ----------------------------
    /// START BUTTON HANDLER
    /// ----------------------------

    void _handleStart() async {
    String username = _usernameController.text.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your username'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    bool isNew = await PlayerRepository().checkUser(username);

    // Navigate directly to Main Menu
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainMenuPage(username: username),
      ),
    );
  }


  /// ----------------------------
  /// UI (UNCHANGED)
  /// ----------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🧠', style: TextStyle(fontSize: 80)),
                      SizedBox(height: 20),
                      Text(
                        'MathPuzzle',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                          shadows: [
                            Shadow(
                              color: Colors.black12,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your username',
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _handleStart,
                          child: Text('START GAME'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
