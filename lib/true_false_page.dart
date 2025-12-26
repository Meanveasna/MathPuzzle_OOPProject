import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_theme.dart';
import 'games/true_false_game.dart';

class TrueFalsePage extends StatefulWidget {
  @override
  _TrueFalsePageState createState() => _TrueFalsePageState();
}

class _TrueFalsePageState extends State<TrueFalsePage> {
  late TrueFalseGame game;
  bool isGameActive = false;

  @override
  void initState() {
    super.initState();
    game = TrueFalseGame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCountdownDialog();
    });
  }

  void _showCountdownDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CountdownDialog(onComplete: _startGame),
    );
  }

  void _startGame() {
    setState(() {
      game.start();
      isGameActive = true;
    });
  }

  void _answer(bool userChoice) {
    game.processAnswer(userChoice, 0); // Timer not critical for T/F score in this version
    
    if (game.questionIndex >= 20) {
      _endGame();
    } else {
      setState(() {
         game.generateQuestion();
      });
    }
  }

  void _endGame() {
    setState(() { isGameActive = false; });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Game Over"),
        content: Text("You scored ${game.totalScore} / 20"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close Dialog
              Navigator.pop(context); // Back to Menu
            },
            child: Text("Back to Menu"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close Dialog
              _showCountdownDialog(); // Restart
            },
            child: Text("Play Again"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isGameActive && game.questionIndex == 0) {
      return Scaffold(backgroundColor: AppTheme.backgroundColor); // Empty while waiting
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text("True / False"),
        leading: BackButton(),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text("${game.totalScore} / 20", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Question ${game.questionIndex + 1}", style: GoogleFonts.nunito(fontSize: 20, color: Colors.grey[600])),
            SizedBox(height: 40),
            
            // Question Card
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: Column(
                children: [
                   Text(
                    "${game.a} ${game.op} ${game.b}",
                    style: GoogleFonts.nunito(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Divider(height: 30, thickness: 2),
                  Text(
                    "= ${game.displayedResult}",
                    style: GoogleFonts.nunito(fontSize: 50, fontWeight: FontWeight.w900, color: AppTheme.primaryColor),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 60),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(false, Colors.redAccent, Icons.close),
                _buildButton(true, Colors.greenAccent, Icons.check),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(bool value, Color color, IconData icon) {
    return SizedBox(
      width: 100, 
      height: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 5,
        ),
        onPressed: () => _answer(value),
        child: Icon(icon, size: 50, color: Colors.white),
      ),
    );
  }
}

// Simple Countdown Dialog
class CountdownDialog extends StatefulWidget {
  final VoidCallback onComplete;
  CountdownDialog({required this.onComplete});

  @override
  _CountdownDialogState createState() => _CountdownDialogState();
}

class _CountdownDialogState extends State<CountdownDialog> {
  int count = 3;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          count--;
        });
        if (count <= 0) {
          timer.cancel();
          Navigator.pop(context);
          widget.onComplete();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Text(
          count > 0 ? "$count" : "GO!",
          style: GoogleFonts.titanOne(fontSize: 100, color: Colors.white, shadows: [Shadow(color: Colors.black45, blurRadius: 10)]),
        ),
      ),
    );
  }
}
