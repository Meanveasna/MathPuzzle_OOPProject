import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_theme.dart';
import 'games/logical_puzzle_game.dart';

class LogicalPuzzlePage extends StatefulWidget {
  final int level;

  LogicalPuzzlePage({this.level = 1});

  @override
  _LogicalPuzzlePageState createState() => _LogicalPuzzlePageState();
}

class _LogicalPuzzlePageState extends State<LogicalPuzzlePage> {
  late LogicalPuzzleGame game;
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    game = LogicalPuzzleGame();
    game.start();
  }

  void _processAnswer(String answer) {
    int points = game.processAnswer(answer, 0);
    
    // Show feedback or just move to next
    if (game.questionIndex >= 5) { // 5 Questions per round for Logic
      setState(() {
        showResult = true;
      });
    } else {
      setState(() {
        game.generateQuestion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showResult) {
       return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(title: Text('Round Complete')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.psychology, size: 100, color: AppTheme.purpleColor),
              SizedBox(height: 20),
              Text('Total Score', style: TextStyle(fontSize: 24, color: Colors.grey)),
              Text('${game.totalScore}', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
              SizedBox(height: 40),
              ElevatedButton(
                child: Text('Back to Menu'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Logic Puzzle (Lvl ${widget.level})'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
           children: [
             LinearProgressIndicator(
              value: (game.questionIndex) / 5,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0,5))]
                ),
                child: Center(
                  child: Text(
                    game.questionText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              flex: 3,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.5,
                ),
                itemCount: game.options.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () => _processAnswer(game.options[index]),
                    child: Text(
                      game.options[index],
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
           ],
        ),
      ),
    );
  }
}
