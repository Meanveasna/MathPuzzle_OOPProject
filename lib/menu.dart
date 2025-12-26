import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'quick_calculation_page.dart';
import 'logical_puzzle_page.dart';
import 'true_false_page.dart';
import 'core/app_theme.dart';
import 'models/game_menu_item.dart';
import 'profile_page.dart';

class MenuPage extends StatelessWidget {
  final String username;
  final bool isNewUser;

  MenuPage({required this.username, required this.isNewUser});

  List<GameMenuItem> get _menuItems => [
    GameMenuItem(
      title: 'Calculator', // Remapped for demo purposes or keep original names if logic dictates
      icon: Icons.calculate,
      color: AppTheme.primaryColor,
      routeName: '/quick',
      destination: QuickCalculationPage(),
      score: 0,
    ),
    GameMenuItem(
      title: 'Guess the sign?',
      icon: Icons.question_mark_rounded,
      color: AppTheme.primaryColor,
      routeName: '/logical',
      destination: LogicalPuzzlePage(),
      score: 0,
    ),
     GameMenuItem(
      title: 'Correct answer',
      icon: Icons.check_circle_outline,
      color: AppTheme.primaryColor,
      routeName: '/truefalse',
      destination: TrueFalsePage(),
      score: 0,
    ),
     GameMenuItem(
      title: 'Quick calculation',
      icon: Icons.flash_on_rounded,
      color: AppTheme.primaryColor,
      routeName: '/quick',
       destination: QuickCalculationPage(), // Reusing generic page for now
       score: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Or the light blue scaffold color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 32),
            SizedBox(width: 8),
            Text("0", style: GoogleFonts.nunito(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Colors.black, size: 28),
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage(username: username)));
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Header content if any, e.g. "Math Puzzle" title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                 Text(
                   "Math Puzzle",
                    style: GoogleFonts.nunito(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF4A4A4A),
                    ),
                 ),
                 SizedBox(height: 10),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 40),
                   child: Text(
                     "Each game with simple calculation with different approach.",
                     textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                   ),
                 ),
              ],
            ),
          ),
          
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(24),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 0.75, // Taller cards
              ),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                return _buildGameCard(context, _menuItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, GameMenuItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => item.destination));
      },
      child: Container(
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(24),
           boxShadow: [
            BoxShadow(
              color: item.color.withOpacity(0.4),
              offset: Offset(0, 8),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             // Icon Container
             Container(
               padding: EdgeInsets.all(12),
               decoration: BoxDecoration(
                 color: AppTheme.yellowColor, // Yellow bg for icon
                 borderRadius: BorderRadius.circular(16),
                 border: Border.all(color: Colors.black87, width: 2),
               ),
               child: Icon(item.icon, size: 40, color: Colors.black87),
             ),
             SizedBox(height: 16),
             Text(
               item.title,
               textAlign: TextAlign.center,
               style: GoogleFonts.nunito(
                 fontSize: 18,
                 fontWeight: FontWeight.bold,
                 color: Colors.black87,
               ),
             ),
             Spacer(),
             // Trophy Score
             Container(
               margin: EdgeInsets.only(bottom: 20),
               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               decoration: BoxDecoration(
                 color: AppTheme.yellowColor,
                 borderRadius: BorderRadius.circular(12),
                 border: Border.all(color: Colors.transparent), // Can add border if needed
               ),
               child: Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Icon(Icons.emoji_events_outlined, size: 18, color: Colors.brown),
                   SizedBox(width: 8),
                   Text(
                     "${item.score}",
                     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
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

