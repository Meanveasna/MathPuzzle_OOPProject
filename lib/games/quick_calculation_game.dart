import 'dart:math';
import '../core/game_engine.dart';

class QuickCalculationGame extends PuzzleGame {
  final int level;
  final Random _rand = Random();

  int a = 0;
  int b = 0;
  String operator = '+';
  int _correctAnswer = 0;
  int getCorrectAnswer() => _correctAnswer;
  
  QuickCalculationGame(this.level); 

  @override
  void start() {
    totalScore = 0;
    questionIndex = 0;
    generateQuestion();
  }

  @override
  void generateQuestion() {
    int cycle = (level - 1) % 5; //cycle is the number to tells the program which operator to use for each level.
    int difficulty = (level - 1) ~/ 5; //increase every 5 levels, used to make numbers bigger for higher levels.
    
    int maxNumber = 10 + (difficulty * 10); 
    
    //pick the operator
    if (cycle == 4) {
       List<String> ops = ['+', '-', '*', '/'];
       operator = ops[_rand.nextInt(4)];
    } else {
       if (cycle == 0) operator = '+';
       else if (cycle == 1) operator = '-';
       else if (cycle == 2) operator = '*';
       else if (cycle == 3) operator = '/';
    }

    a = _rand.nextInt(maxNumber) + 1; //+1 to ensure no zero
    b = _rand.nextInt(maxNumber) + 1;

    if (operator == '/') {
      b = _rand.nextInt(maxNumber ~/ 2 + 1) + 1;//generates the divisor integer between 0 and maxNumber/2
      if (b > 10 + difficulty * 2) b = 10; //
      a = b * (_rand.nextInt(10) + 1);
      _correctAnswer = a ~/ b;
    } else if (operator == '*') {
       int limit = (maxNumber > 12) ? 12 : maxNumber; 
       a = _rand.nextInt(limit) + 1;
       b = _rand.nextInt(limit) + 1;
      _correctAnswer = a * b;
    } else if (operator == '+') {
      _correctAnswer = a + b;
    } else if (operator == '-') {
      if (a < b) { int temp = a; a = b; b = temp; }
      _correctAnswer = a - b;
    }
  }

  @override
  int processAnswer(dynamic input, int secondsLeft) {
    int score = 0;
    if (input != null && input.toString().isNotEmpty) {
      int? ans = int.tryParse(input.toString()); //tryParse might fail if the input is not a valid number so we need to use int? (?) mean nullable
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
  }
}
