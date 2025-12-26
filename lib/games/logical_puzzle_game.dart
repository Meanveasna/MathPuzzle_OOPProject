import 'dart:math';
import '../core/game_engine.dart';

class LogicalPuzzleGame extends PuzzleGame {
  final Random _rand = Random();

  String questionText = '';
  String correctAnswer = '';
  List<String> options = [];

  @override
  void start() {
    totalScore = 0;
    questionIndex = 0;
    generateQuestion();
  }

  @override
  void generateQuestion() {
    int type = _rand.nextInt(3); // 0: Number Series, 1: Shapes/Symbols math, 2: Word logic
    
    switch (type) {
      case 0:
        _generateNumberSeries();
        break;
      case 1:
        _generateSimpleAlgebra();
        break;
      case 2:
        _generatePatternMath(); // e.g. 2 + 2 = 4, 3 + 3 = 6...
        break;
    }
  }

  void _generateNumberSeries() {
    // Example: 2, 4, 6, 8, ?
    int start = _rand.nextInt(5) + 1;
    int step = _rand.nextInt(5) + 1;
    List<int> series = List.generate(5, (index) => start + (index * step));
    
    questionText = "${series[0]}, ${series[1]}, ${series[2]}, ${series[3]}, ?";
    correctAnswer = series[4].toString();
    
    // Generate options
    Set<String> opts = {correctAnswer};
    while (opts.length < 4) {
      opts.add((series[4] + _rand.nextInt(10) - 5).toString());
    }
    options = opts.toList()..shuffle();
  }

  void _generateSimpleAlgebra() {
    // Example: A = 5, B = 2. A + B = ?
    int a = _rand.nextInt(10) + 1;
    int b = _rand.nextInt(10) + 1;
    
    questionText = "If A = $a and B = $b,\nthen A + B = ?";
    correctAnswer = (a + b).toString();
    
    Set<String> opts = {correctAnswer};
    while (opts.length < 4) {
      opts.add((a + b + _rand.nextInt(6) - 3).toString());
    }
    options = opts.toList()..shuffle();
  }

  void _generatePatternMath() {
     // A slightly different pattern
     int base = _rand.nextInt(5) + 1;
     questionText = "$base -> ${base*2}\n${base+1} -> ${(base+1)*2}\n${base+2} -> ?";
     correctAnswer = ((base+2)*2).toString();

     Set<String> opts = {correctAnswer};
     while (opts.length < 4) {
      opts.add(((base+2)*2 + _rand.nextInt(6) - 3).toString());
    }
    options = opts.toList()..shuffle();
  }

  @override
  int processAnswer(dynamic input, int secondsLeft) {
    if (input.toString() == correctAnswer) {
      totalScore += 5; // Logic puzzles are harder, more points
      questionIndex++;
      return 5;
    }
    questionIndex++;
    return 0;
  }

  @override
  void dispose() {}
}
