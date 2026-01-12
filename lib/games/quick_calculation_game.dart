import 'dart:math';
import '../core/game_engine.dart';

class QuickCalculationGame extends PuzzleGame {
  final int mode; // 1: +, 2: -, 3: *, 4: /, 5: Mix
  final Random _rand = Random();

  int a = 0;
  int b = 0;
  String operator = '+';
  int _correctAnswer = 0;

  QuickCalculationGame(this.mode);

  @override
  void start() {
    totalScore = 0;
    questionIndex = 0;
    generateQuestion();
  }

  @override
  void generateQuestion() {
    // Difficulty curve: 0-10 easy, 10-20 medium, 20+ hard
    int maxNumber = 10;
    if (totalScore > 20)
      maxNumber = 100;
    else if (totalScore > 10)
      maxNumber = 50;
    else
      maxNumber = 20;

    a = _rand.nextInt(maxNumber) + 1;
    b = _rand.nextInt(maxNumber) + 1;

    List<String> ops = ['+', '-', '*', '/'];
    if (mode == 5) {
      operator = ops[_rand.nextInt(4)];
    } else {
      switch (mode) {
        case 1:
          operator = '+';
          break;
        case 2:
          operator = '-';
          break;
        case 3:
          operator = '*';
          break;
        case 4:
          operator = '/';
          break;
      }
    }

    if (operator == '/') {
      // Ensure clean division
      b = _rand.nextInt(10) + 1; // Keep divisor small for mental math
      int multiplier = _rand.nextInt(10) + 1;
      a = b * multiplier;
      _correctAnswer = a ~/ b;
    } else if (operator == '*') {
      // Keep numbers smaller for mental multiplication
      a = _rand.nextInt(12) + 1;
      b = _rand.nextInt(12) + 1;
      _correctAnswer = a * b;
    } else if (operator == '+') {
      _correctAnswer = a + b;
    } else if (operator == '-') {
      // Allow negatives? Let's keep it simple for now, maybe only positive results?
      // No, allow negatives for "Hard" mode implicitly
      _correctAnswer = a - b;
    }
  }

  @override
  int processAnswer(dynamic input, int secondsLeft) {
    int score = 0;
    if (input != null && input.toString().isNotEmpty) {
      int? ans = int.tryParse(input.toString());
      if (ans == _correctAnswer) {
        if (secondsLeft > 15)
          score = 3;
        else if (secondsLeft > 10)
          score = 2;
        else
          score = 1;
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
