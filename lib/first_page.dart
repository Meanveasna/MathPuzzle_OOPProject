import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'player_storage.dart';
import 'main_menu_page.dart';
import 'core/app_theme.dart';
import 'models/user_model.dart';
import 'package:flutter/services.dart';
import 'l10n/app_localizations.dart';
import 'main.dart'; 

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

    _checkExistingUser(); 
  }

  void _checkExistingUser() async {
    User? user = await PlayerRepository().getUser();
    if (user != null) {
      // User already exists -> skip FirstPage
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
    Future<bool> _checkUser(String username) async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('user_$username');
    }

    Future<void> _createUser(String username) async {
      final prefs = await SharedPreferences.getInstance();

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
    void _handleStart() async {
    String username = _usernameController.text.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.enterUsername), // Fallback or new key
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    // Length check handled by TextField maxLength

    bool isNew = await PlayerRepository().checkUser(username);

    // Navigate directly to Main Menu
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainMenuPage(username: username),
      ),
    );
  }

  Widget _buildLanguageToggle(BuildContext context, String label, Locale locale) {
    bool isSelected = Localizations.localeOf(context).languageCode == locale.languageCode;
    return InkWell(
      onTap: () {
        MyApp.setLocale(context, locale);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primaryColor, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
             color: isSelected ? Colors.white : Colors.black87,
             fontWeight: FontWeight.bold,
             fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                        l10n.appTitle, // Localized App Title
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
                      // Language Switcher Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLanguageToggle(context, 'US English', const Locale('en')),
                          SizedBox(width: 20),
                          _buildLanguageToggle(context, 'KH ខ្មែរ', const Locale('km')),
                        ],
                      ),
                      SizedBox(height: 40),
                      TextField(
                        controller: _usernameController,
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintText: l10n.enterUsername, // Localized
                          counterText: "", // Hide counter if preferred, or keep it. Default shows 0/10
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
                          child: Text(l10n.startGame), // Localized
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
