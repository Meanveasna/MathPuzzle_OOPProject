import 'dart:async';
import 'package:flutter/material.dart';
import 'games/quick_calculation_game.dart';
import 'core/app_theme.dart';

class QuickCalculationPage extends StatefulWidget {
  final int level;
  QuickCalculationPage({this.level = 1});

  @override
  _QuickCalculationPageState createState() => _QuickCalculationPageState();
}

class _QuickCalculationPageState extends State<QuickCalculationPage> {
  // Determine mode based on level
  // 1-5: Add (mode 1)
  // 6-10: Sub (mode 2)
  // 11-15: Mul (mode 3)
  // 16-20: Mix/Div (mode 5)
  int _getModeFromLevel() {
    if (widget.level <= 5) return 1;
    if (widget.level <= 10) return 2;
    if (widget.level <= 15) return 3;
    return 5;
  }
  
  String _getTitle() {
    int m = _getModeFromLevel();
    switch(m) {
      case 1: return "Addition (Lvl ${widget.level})";
      case 2: return "Subtraction (Lvl ${widget.level})";
      case 3: return "Multiplication (Lvl ${widget.level})";
      default: return "Review (Lvl ${widget.level})";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Directly show the game screen
    return QuickCalculationScreen(mode: _getModeFromLevel(), modeName: _getTitle(), initialLevel: widget.level);
  }
}

class QuickCalculationScreen extends StatefulWidget {
  final int mode;
  final String modeName;
  final int initialLevel;

  QuickCalculationScreen({required this.mode, required this.modeName, required this.initialLevel});

  @override
  _QuickCalculationScreenState createState() => _QuickCalculationScreenState();
}

class _QuickCalculationScreenState extends State<QuickCalculationScreen> with TickerProviderStateMixin {
  late QuickCalculationGame game;
  final TextEditingController answerController = TextEditingController();

  int secondsLeft = 20;
  bool showResult = false;
  Timer? timer;
  late AnimationController _timerAnimController;
  Color _timerColor = Colors.green;

  @override
  void initState() {
    super.initState();
    game = QuickCalculationGame(widget.mode);
    game.start();
    _timerAnimController = AnimationController(vsync: this, duration: Duration(seconds: 20));
    _timerAnimController.reverse(from: 1.0);
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    secondsLeft = 20;
    _timerAnimController.duration = Duration(seconds: 20);
    _timerAnimController.reverse(from: 1.0);
    
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          secondsLeft--;
          if (secondsLeft <= 5) _timerColor = Colors.red;
          else if (secondsLeft <= 10) _timerColor = Colors.orange;
          else _timerColor = Colors.green;
        });
      }
      if (secondsLeft <= 0) {
        t.cancel();
        processAnswer(null);
      }
    });
  }

  void processAnswer(String? input) {
    game.processAnswer(input, secondsLeft);

    if (game.questionIndex >= 10) {
      timer?.cancel();
      setState(() { showResult = true; });
    } else {
      answerController.clear();
      game.generateQuestion();
      startTimer();
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    _timerAnimController.dispose();
    answerController.dispose();
    super.dispose();
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
              Icon(Icons.emoji_events, size: 100, color: Colors.amber),
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
      appBar: AppBar(title: Text('${widget.modeName} Round')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (game.questionIndex) / 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            SizedBox(height: 10),
            Text('Question ${game.questionIndex + 1} / 10', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: secondsLeft / 20,
                    strokeWidth: 10,
                    valueColor: AlwaysStoppedAnimation<Color>(_timerColor),
                    backgroundColor: Colors.grey[200],
                  ),
                ),
                Text(
                  '$secondsLeft',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: _timerColor),
                ),
              ],
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: Text(
                '${game.a} ${game.operator} ${game.b} = ?',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: answerController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Answer',
                fillColor: Colors.white,
              ),
              onSubmitted: (value) => processAnswer(value),
              autofocus: true,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                child: Text('SUBMIT'),
                onPressed: () => processAnswer(answerController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
