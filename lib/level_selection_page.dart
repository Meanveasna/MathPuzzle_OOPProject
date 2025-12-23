import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_theme.dart';
import 'quick_calculation_page.dart';
import 'logical_puzzle_page.dart';
import 'player_storage.dart';
import 'models/user_model.dart';

class LevelSelectionPage extends StatefulWidget {
  final String mode; // 'quick' or 'logical'
  final String username;

  LevelSelectionPage({required this.mode, required this.username});

  @override
  _LevelSelectionPageState createState() => _LevelSelectionPageState();
}

class _LevelSelectionPageState extends State<LevelSelectionPage> {
  int unlockedLevel = 1;

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
  }

  void _loadUserProgress() async {
    User? user = await PlayerRepository().getUser(widget.username);
    if (user != null) {
      if (mounted) {
         setState(() {
           unlockedLevel = user.levels[widget.mode] ?? 1;
         });
      }
    }
  } 

  @override
  Widget build(BuildContext context) {
    String title = widget.mode == 'quick' ? 'Quick Calculation' : 'Logic Puzzle';
    Color themeColor = widget.mode == 'quick' ? AppTheme.primaryColor : AppTheme.accentColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: GoogleFonts.nunito(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Select Level",
              style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 columns
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.0,
              ),
              itemCount: 20, // 20 Levels
              itemBuilder: (context, index) {
                int level = index + 1;
                bool isLocked = level > unlockedLevel;
                
                return _buildLevelButton(level, isLocked, themeColor);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelButton(int level, bool isLocked, Color color) {
    return GestureDetector(
      onTap: () {
        if (!isLocked) {
          _navigateToLevel(level);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Level $level is locked! Complete previous levels first.")),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isLocked ? Colors.grey[300] : color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            if (!isLocked)
              BoxShadow(
                color: color.withOpacity(0.4),
                offset: Offset(0, 4),
                blurRadius: 5,
              )
          ],
        ),
        child: Center(
          child: isLocked
              ? Icon(Icons.lock, color: Colors.grey[600])
              : Text(
                  "$level",
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  void _navigateToLevel(int level) {
    Widget destination;
    if (widget.mode == 'quick') {
      destination = QuickCalculationPage(level: level);
    } else {
      destination = LogicalPuzzlePage(level: level);
    }
    
    Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
  }
}
