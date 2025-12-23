import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_theme.dart';

class TrueFalsePage extends StatefulWidget {
  @override
  _TrueFalsePageState createState() => _TrueFalsePageState();
}

class _TrueFalsePageState extends State<TrueFalsePage> {
  final Random _rand = Random();
  int totalQuestions = 0;
  int score = 0;
  bool isGameActive = false;
  
  // Current Question Data
  int a = 0;
  int b = 0;
  String op = '+';
  int displayedResult = 0;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
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
      score = 0;
      totalQuestions = 0;
      isGameActive = true;
      _generateQuestion();
    });
  }

  void _generateQuestion() {
    if (totalQuestions >= 20) {
      _endGame();
      return;
    }

    // Generate basic max math
    int maxVal = 20 + (score * 2); // Difficulty increases slightly
    a = _rand.nextInt(maxVal) + 1;
    b = _rand.nextInt(maxVal) + 1;
    
    // Select Op
    int opType = _rand.nextInt(3); // 0: +, 1: -, 2: *
    int realResult = 0;

    switch (opType) {
      case 0: 
        op = '+';
        realResult = a + b;
        break;
      case 1:
        op = '-';
        if (a < b) { int t = a; a = b; b = t; } // Keep positive for simplicity
        realResult = a - b;
        break;
      case 2:
        op = '×';
        a = _rand.nextInt(12) + 1; // Lower max for multiplication
        b = _rand.nextInt(12) + 1;
        realResult = a * b;
        break;
    }

    // Decide if we show correct or wrong answer
    isCorrect = _rand.nextBool();
    if (isCorrect) {
      displayedResult = realResult;
    } else {
      // Generate a believable wrong answer (+- 1 to 5)
      int offset = _rand.nextInt(5) + 1;
      displayedResult = _rand.nextBool() ? realResult + offset : realResult - offset;
      if (displayedResult < 0) displayedResult = realResult + offset; // Avoid negatives if not intended
      if (displayedResult == realResult) displayedResult = realResult + 1; // Safety
    }

    totalQuestions++;
  }

  void _answer(bool userChoice) {
    if (userChoice == isCorrect) {
      score++;
    }
    setState(() {
       _generateQuestion();
    });
  }

  void _endGame() {
    setState(() { isGameActive = false; });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Game Over"),
        content: Text("You scored $score / 20"),
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
    if (!isGameActive && totalQuestions == 0) {
      return Scaffold(backgroundColor: AppTheme.backgroundColor); // Empty while waiting for dialog
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
              child: Text("$score / 20", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Question $totalQuestions", style: GoogleFonts.nunito(fontSize: 20, color: Colors.grey[600])),
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
                    "$a $op $b",
                    style: GoogleFonts.nunito(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Divider(height: 30, thickness: 2),
                  Text(
                    "= $displayedResult",
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
