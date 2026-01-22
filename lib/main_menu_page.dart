import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/sfx.dart';
import 'core/app_theme.dart';
import 'models/user_model.dart';
import 'player_storage.dart';

import 'true_false_page.dart';
import 'level_selection_page.dart';
import 'settings_page.dart';
import 'profile_page.dart';
import 'l10n/app_localizations.dart';

class MainMenuPage extends StatefulWidget {
  final String username;

  MainMenuPage({required this.username});

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
    Sfx.stopBgm(); // ⏹️ STOP WHEN MENU IS DESTROYED
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
    final l10n = AppLocalizations.of(context)!;
    // Check locale for font switching
    final locale = Localizations.localeOf(context);
    final isKhmer = locale.languageCode == 'km';

    // If user data is not loaded yet, use the username passed in and defaults
    String displayUsername = widget.username;
    String displayAvatar = '🐼'; // Default
    int displayStars = 0;

    if (_currentUser != null) {
      displayUsername = _currentUser!.username;
      displayAvatar = _currentUser!.avatarId;
      displayStars = _currentUser!.totalStars;

      if (displayAvatar == '0' || int.tryParse(displayAvatar) != null) {
        if (displayAvatar == '0') displayAvatar = '🐼';
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFC3E0FF),
              const Color(0xFFE6D6FF),
            ], // Sky blue to light purple
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Left: Profile
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.4,
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(username: widget.username),
                              ),
                            );
                            _loadUserData();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                                child: Text(
                                  displayAvatar,
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      displayUsername,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF5A5A5A),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.emoji_events,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "$displayStars",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Center: Trophy Icon (Decorative)
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        size: 28,
                        color: Colors.amber,
                      ),
                    ),

                    // Right: Settings
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsPage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.settings,
                            size: 28,
                            color: Color(0xFF5A5A5A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Title "MATH PUZZLES"
              Stack(
                children: [
                  Text(
                    l10n.mathPuzzlesTitle,
                    textAlign: TextAlign.center,
                    style: isKhmer
                        ? GoogleFonts.notoSansKhmer(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 5),
                                blurRadius: 0,
                                color: Color(0xFF8E99F3),
                              ),
                            ],
                          )
                        : GoogleFonts.titanOne(
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 5),
                                blurRadius: 0,
                                color: Color(0xFF8E99F3),
                              ),
                            ],
                          ),
                  ),
                  Text(
                    l10n.mathPuzzlesTitle,
                    textAlign: TextAlign.center,
                    style: isKhmer
                        ? GoogleFonts.notoSansKhmer(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFFD54F),
                            height: 1.2,
                          )
                        : GoogleFonts.titanOne(
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFFD54F),
                            height: 1.2,
                          ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Text(
                l10n.trainBrain,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 30),

              // Categories List
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildCategoryCard(
                      context,
                      title: l10n.playQuick,
                      description: l10n.playQuickDesc,
                      color: AppTheme.primaryColor, // Pink
                      icon: Icons.timer_outlined,
                      destination: LevelSelectionPage(
                        mode: 'quick',
                        username: widget.username,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      title: l10n.playLogical,
                      description: l10n.playLogicalDesc,
                      color: AppTheme.accentColor, // Blue
                      icon: Icons.lightbulb_outline,
                      destination: LevelSelectionPage(
                        mode: 'logical',
                        username: widget.username,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      title: l10n.playTrueFalse,
                      description: l10n.playTrueFalseDesc,
                      color: AppTheme.purpleColor, // Purple
                      icon: Icons.check_circle_outline,
                      destination: TrueFalsePage(),
                    ),
                  ],
                ),
              ),

              // Bottom Ad Placeholder or footer
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
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
    // Check locale here as well or pass it down
    final isKhmer = Localizations.localeOf(context).languageCode == 'km';

    return GestureDetector(
      onTap: () async {
        if (destination != null) {
          Sfx.stopBgm();
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
          Sfx.playMenuBgm();
          _loadUserData();
        }
      },
      child: Container(
        height: 140, // Fixed height for consistency
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 8),
              blurRadius: 0, // Solid shadow for cartoon look
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 30,
              child: Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black87, width: 2),
                ),
                child: Icon(icon, size: 40, color: Colors.black87),
              ),
            ),
            Positioned(
              right: 20,
              top: 20,
              bottom: 20,
              left: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: isKhmer
                        ? GoogleFonts.notoSansKhmer(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(1, 1),
                              ),
                            ],
                          )
                        : GoogleFonts.nunito(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: isKhmer
                        ? GoogleFonts.notoSansKhmer(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.2,
                          )
                        : GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.2,
                          ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
