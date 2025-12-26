import 'dart:math';
import '../core/game_engine.dart';

class TrueFalseGame extends PuzzleGame {
  final Random _rand = Random();

  // Question Data
  int a = 0;
  int b = 0;
  String op = '+';
  int displayedResult = 0;
  bool isCorrect = false;

  @override
  void start() {
    totalScore = 0;
    questionIndex = 0;
    generateQuestion();
  }

  @override
  void generateQuestion() {
    // 1. Generate Numbers based on difficulty (score)
    int maxVal = 20 + (totalScore * 2);
    a = _rand.nextInt(maxVal) + 1;
    b = _rand.nextInt(maxVal) + 1;

    // 2. Select Operator
    int opType = _rand.nextInt(3); // 0: +, 1: -, 2: *
    int realResult = 0;

    switch (opType) {
      case 0:
        op = '+';
        realResult = a + b;
        break;
      case 1:
        op = '-';
        if (a < b) { int t = a; a = b; b = t; } // Keep positive
        realResult = a - b;
        break;
      case 2:
        op = '×';
        a = _rand.nextInt(12) + 1; // Smaller numbers for multiplication
        b = _rand.nextInt(12) + 1;
        realResult = a * b;
        break;
    }

    // 3. Decide if True or False
    isCorrect = _rand.nextBool();
    if (isCorrect) {
      displayedResult = realResult;
    } else {
      // Generate a believable wrong answer
      int offset = _rand.nextInt(5) + 1;
      displayedResult = _rand.nextBool() ? realResult + offset : realResult - offset;
      
      // Safety checks
      if (displayedResult < 0) displayedResult = realResult + offset;
      if (displayedResult == realResult) displayedResult = realResult + 1;
    }
  }

  @override
  int processAnswer(dynamic input, int secondsLeft) {
    if (input == null || input is! bool) return 0;
    
    bool userChoice = input;
    int points = 0;

    if (userChoice == isCorrect) {
      points = 1; // Standard point for T/F
    }

    totalScore += points;
    questionIndex++;
    return points;
  }

  @override
  void dispose() {
    // No specific cleanup needed
  }
}
