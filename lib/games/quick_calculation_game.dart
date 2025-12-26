import 'dart:math';
import '../core/game_engine.dart';

class QuickCalculationGame extends PuzzleGame {
  final int level;
  final Random _rand = Random();

  int a = 0;
  int b = 0;
  String operator = '+';
  int _correctAnswer = 0;
  
  QuickCalculationGame(this.level); // Mode derived from level

  @override
  void start() {
    totalScore = 0;
    questionIndex = 0;
    generateQuestion();
  }

  @override
  void generateQuestion() {
    // Level Logic:
    // 1: Add, 2: Sub, 3: Mul, 4: Div, 5,6,7..: Mix/Cycle or mapped
    // Requirement:
    // L1: Add (1-10)
    // L2: Sub
    // L3: Mul
    // L4: Div
    // L5: Mix
    // L6+: Repeat but harder
    
    int cycle = (level - 1) % 5; // 0=Add, 1=Sub, 2=Mul, 3=Div, 4=Mix
    int difficulty = (level - 1) ~/ 5; // Increases every 5 levels
    
    int maxNumber = 10 + (difficulty * 10); // 10, 20, 30...
    
    // Determine operator
    if (cycle == 4) {
       // Mix
       List<String> ops = ['+', '-', '*', '/'];
       operator = ops[_rand.nextInt(4)];
    } else {
       if (cycle == 0) operator = '+';
       else if (cycle == 1) operator = '-';
       else if (cycle == 2) operator = '*';
       else if (cycle == 3) operator = '/';
    }

    a = _rand.nextInt(maxNumber) + 1;
    b = _rand.nextInt(maxNumber) + 1;

    if (operator == '/') {
      // Clean division
      b = _rand.nextInt(maxNumber ~/ 2 + 1) + 1;
      if (b > 10 + difficulty * 2) b = 10; // Keep divisor reasonable
      a = b * (_rand.nextInt(10) + 1);
      _correctAnswer = a ~/ b;
    } else if (operator == '*') {
       // Smaller numbers for multiply
       int limit = (maxNumber > 12) ? 12 : maxNumber; 
       a = _rand.nextInt(limit) + 1;
       b = _rand.nextInt(limit) + 1;
      _correctAnswer = a * b;
    } else if (operator == '+') {
      _correctAnswer = a + b;
    } else if (operator == '-') {
      // Ensure positive result for early levels? User didn't specify, but safer.
      if (a < b) { int temp = a; a = b; b = temp; }
      _correctAnswer = a - b;
    }
  }

  @override
  int processAnswer(dynamic input, int secondsLeft) {
    int score = 0;
    if (input != null && input.toString().isNotEmpty) {
      int? ans = int.tryParse(input.toString());
      if (ans == _correctAnswer) {
        if (secondsLeft > 15) score = 3;
        else if (secondsLeft > 10) score = 2;
        else score = 1;
      }
    }
    totalScore += score;
    questionIndex++;
    return score;
  }

  @override
  void dispose() {
    // No specific resources to dispose in this logic-only class
  }
}
