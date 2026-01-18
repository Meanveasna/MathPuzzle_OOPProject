import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_theme.dart';
import 'models/user_model.dart';
import 'player_storage.dart';

import 'true_false_page.dart';
import 'level_selection_page.dart';
import 'settings_page.dart';
import 'profile_page.dart';

import 'package:mathpuzzlesoop/l10n/app_localizations.dart';
import 'core/sfx.dart'; // 🔊 SOUND

class MainMenuPage extends StatefulWidget {
  final String username;

  const MainMenuPage({super.key, required this.username});

  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    Sfx.playMenuBgm(); // 🎵 START MENU MUSIC
  }

  @override
  void dispose() {
    Sfx.stopBgm(); // ⏹ STOP WHEN MENU IS DESTROYED
    super.dispose();
  }

  void _loadUserData() async {
    User? user = await PlayerRepository().getUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayUsername = widget.username;
    String displayAvatar = '🐼';
    int displayStars = 0;

    if (_currentUser != null) {
      displayUsername = _currentUser!.username;
      displayAvatar = _currentUser!.avatarId;
      displayStars = _currentUser!.totalStars;

      if (displayAvatar == '0' || int.tryParse(displayAvatar) != null) {
        displayAvatar = '🐼';
      }
    }

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFC3E0FF), Color(0xFFE6D6FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context, displayUsername, displayAvatar, displayStars),
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 10),
              Text(
                l10n.trainBrain,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildCategoryCard(
                      context,
                      title: l10n.playQuick,
                      description: l10n.playQuickDesc,
                      color: AppTheme.primaryColor,
                      icon: Icons.timer_outlined,
                      destination: LevelSelectionPage(
                        mode: 'quick',
                        username: widget.username,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      title: l10n.playLogical,
                      description: l10n.playLogicalDesc,
                      color: AppTheme.accentColor,
                      icon: Icons.lightbulb_outline,
                      destination: LevelSelectionPage(
                        mode: 'logical',
                        username: widget.username,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      title: l10n.playTrueFalse,
                      description: l10n.playTrueFalseDesc,
                      color: AppTheme.purpleColor,
                      icon: Icons.check_circle_outline,
                      destination: const TrueFalsePage(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== UI HELPERS =====================

  Widget _buildTopBar(
    BuildContext context,
    String username,
    String avatar,
    int stars,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () async {
                Sfx.click();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProfilePage(username: widget.username),
                  ),
                );
                // Music continues playing
                _loadUserData();
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Text(avatar, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(username,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.emoji_events,
                              color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text('$stars',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // SCOREBOARD
          // SCOREBOARD (Icon only, no click)
          const CircleAvatar(
            backgroundColor: Colors.white70,
            child: Icon(Icons.emoji_events, color: Colors.amber),
          ),

          // SETTINGS
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Sfx.click();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsPage()),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white70,
                child: Icon(Icons.settings),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Text(
          l10n.mathPuzzlesTitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.titanOne(
            fontSize: 50,
            color: Colors.white,
            shadows: const [
              Shadow(offset: Offset(0, 5), color: Color(0xFF8E99F3)),
            ],
          ),
        ),
        Text(
          l10n.mathPuzzlesTitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.titanOne(
            fontSize: 50,
            color: Color(0xFFFFD54F),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String description,
    required Color color,
    required IconData icon,
    Widget? destination,
  }) {
    return GestureDetector(
      onTap: () async {
        if (destination != null) {
          Sfx.click();
          Sfx.stopBgm();
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
          Sfx.playMenuBgm();
          _loadUserData();
        }
      },
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(offset: Offset(0, 8), color: Colors.black12),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, size: 40, color: Colors.white),
          title: Text(title,
              style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          subtitle: Text(description,
              style: GoogleFonts.nunito(color: Colors.white70)),
        ),
      ),
    );
  }
}
