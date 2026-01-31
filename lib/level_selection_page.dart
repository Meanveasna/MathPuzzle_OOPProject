import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_theme.dart';
import 'quick_calculation_page.dart';
import 'logical_puzzle_page.dart';
import 'player_storage.dart';
import 'models/user_model.dart';
import 'main_menu_page.dart';
import 'core/sfx.dart';

import 'package:mathpuzzles/l10n/app_localizations.dart';

import 'main.dart'; // Import for routeObserver

class LevelSelectionPage extends StatefulWidget {
  final String mode; // 'quick' or 'logical'
  final String username;

  LevelSelectionPage({required this.mode, required this.username});

  @override
  _LevelSelectionPageState createState() => _LevelSelectionPageState();
}

class _LevelSelectionPageState extends State<LevelSelectionPage> with RouteAware {
  User? _currentUser;
  int unlockedLevel = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when the top route has been popped off, and the current route shows up.
    _loadUserProgress();
  }

  @override
  void initState() {
    super.initState();
    _loadUserProgress();
  }

  void _loadUserProgress() async {
    User? user = await PlayerRepository().getUser();
    if (user != null) {
      if (mounted) {
         setState(() {
           _currentUser = user;
           unlockedLevel = user.levels[widget.mode] ?? 1;
         });
      }
    }
  } 

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String title = widget.mode == 'quick' ? l10n.playQuick : l10n.playLogical;
    Color themeColor = widget.mode == 'quick' ? AppTheme.primaryColor : AppTheme.accentColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              l10n.selectLevel,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 columns
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8, // Taller to fit stars
              ),
              itemCount: widget.mode == 'logical' ? 15 : ((unlockedLevel - 1) ~/ 20 + 1) * 20,
              itemBuilder: (context, index) {
                int level = index + 1;
                bool isLocked = level > unlockedLevel;
                
                int stars = 0;
                if (_currentUser != null && _currentUser!.levelStars.containsKey(widget.mode)) {
                   stars = _currentUser!.levelStars[widget.mode]!['$level'] ?? 0;
                }
                
                return _buildLevelButton(level, isLocked, themeColor, stars, l10n);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelButton(int level, bool isLocked, Color color, int stars, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () {
        if (!isLocked) {
          _navigateToLevel(level);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.levelLocked(level))),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLocked)
               Icon(Icons.lock, color: Colors.grey[600]),
            if (!isLocked)
               Text(
                  "$level",
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
            if (!isLocked && stars > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) => Icon(
                    i < stars ? Icons.star : Icons.star_border, 
                    size: 12, 
                    color: Colors.amberAccent
                  )),
                ),
              )
          ],
        ),
      ),
    );
  }

  void _navigateToLevel(int level) {
  Widget nextPage;
  if (widget.mode == 'quick') {
    nextPage = QuickCalculationPage(level: level, username: widget.username);
  } else {
    nextPage = LogicalPuzzlePage(level: level, username: widget.username);
  }

  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => nextPage),
  ).then((_) => _loadUserProgress()); // Reload when returning
}
}
