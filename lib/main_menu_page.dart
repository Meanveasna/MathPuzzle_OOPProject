import 'scoreboard_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_theme.dart';

import 'true_false_page.dart';
import 'level_selection_page.dart';
import 'settings_page.dart';
import 'profile_page.dart';

class MainMenuPage extends StatelessWidget {
  final String username;

  MainMenuPage({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFC3E0FF), const Color(0xFFE6D6FF)], // Sky blue to light purple
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile Link
                    GestureDetector(
                      onTap: () {
                        // Navigate to Profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage(username: username)),
                        );
                      },
                      child: Row(
                        children: [
                           CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: Icon(Icons.person, color: AppTheme.primaryColor),
                          ),
                          SizedBox(width: 8),
                          Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                username,
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5A5A5A),
                                ),
                               ),
                               Row(
                                children: [
                                  Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    "0",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
                               ),
                             ]
                          )
                        ],
                      ),
                    ),
                    
                    // Scoreboard Button
                    GestureDetector(
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => ScoreboardPage(currentUsername: username)));
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.emoji_events, size: 28, color: Colors.amber),
                      ),
                    ),
                    
                    // Settings Button
                    GestureDetector(
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.settings, size: 28, color: Color(0xFF5A5A5A)),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Title "MATH PUZZLES"
              // Using a stack/shadow for the cartoon 3D effect
              Stack(
                children: [
                  Text(
                    'MATH\nPUZZLES',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.titanOne( // Using a chunky font if available, or Nunito with extra bold
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 0.9,
                      shadows: [
                        Shadow( // Simple outline/depth effect
                          offset: Offset(0, 5),
                          blurRadius: 0,
                          color: Color(0xFF8E99F3),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'MATH\nPUZZLES',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.titanOne(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFFD54F), // Yellowish text face
                      height: 0.9,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 10),
              Text(
                "Train Your Brain, Improve Your Math Skill",
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
                      title: "Quick Calculation",
                      description: "Solve simple math problems quickly.",
                      color: AppTheme.primaryColor, // Pink
                      icon: Icons.timer_outlined,
                      destination: LevelSelectionPage(mode: 'quick', username: username),
                    ),
                    SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      title: "Logical Puzzle",
                      description: "Find the missing pattern.",
                      color: AppTheme.accentColor, // Blue
                      icon: Icons.lightbulb_outline,
                      destination: LevelSelectionPage(mode: 'logical', username: username),
                    ),
                    SizedBox(height: 16),
                    _buildCategoryCard(
                      context,
                      title: "True / False",
                      description: "Decide if the equation is correct.",
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

  Widget _buildCategoryCard(BuildContext context, {
    required String title,
    required String description,
    required Color color,
    required IconData icon,
    Widget? destination,
  }) {
    return GestureDetector(
      onTap: () {
        if (destination != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
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
            )
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
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black26, offset: Offset(1,1))],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: GoogleFonts.nunito(
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
