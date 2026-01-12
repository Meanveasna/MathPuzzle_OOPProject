import 'dart:math';
import 'package:flutter/material.dart';

class TFStatement {
  final String text;
  final bool isTrue;
  final IconData icon;

  const TFStatement({
    required this.text,
    required this.isTrue,
    required this.icon,
  });
}

class TFStatementGenerator {
  final Random rand = Random();

  TFStatement next(int difficulty) {
    final int type = rand.nextInt(7);
    switch (type) {
      case 0:
        return orderOfOps(difficulty);
      case 1:
        return percent(difficulty);
      case 2:
        return squares(difficulty);
      case 3:
        return algebra(difficulty);
      case 4:
        return rectangleArea(difficulty);
      case 5:
        return circleArea(difficulty);
      default:
        return formulaCheck();
    }
  }

  TFStatement orderOfOps(int difficulty) {
    int a = 2 + rand.nextInt(9);
    int b = 2 + rand.nextInt(9);
    int c = 2 + rand.nextInt(9);

    int correct = a + b * c;
    bool makeTrue = rand.nextBool();
    int shown = makeTrue ? correct : correct + pickOffset(difficulty);

    return TFStatement(
      text: "$a + $b × $c = $shown",
      isTrue: makeTrue,
      icon: Icons.calculate,
    );
  }

  TFStatement percent(int difficulty) {
    int base = 50 + rand.nextInt(151);
    int p = (difficulty == 1)
        ? (10 * (1 + rand.nextInt(5)))
        : (5 * (1 + rand.nextInt(10)));

    int correct = (base * p) ~/ 100;
    bool makeTrue = rand.nextBool();
    int shown = makeTrue ? correct : correct + pickOffset(difficulty);

    return TFStatement(
      text: "$p% of $base = $shown",
      isTrue: makeTrue,
      icon: Icons.percent,
    );
  }

  TFStatement squares(int difficulty) {
    int n = (difficulty == 1) ? (2 + rand.nextInt(9)) : (2 + rand.nextInt(13));
    int correct = n * n;

    bool makeTrue = rand.nextBool();
    int shown = makeTrue ? correct : correct + pickOffset(difficulty);

    return TFStatement(
      text: "$n² = $shown",
      isTrue: makeTrue,
      icon: Icons.exposure,
    );
  }

  TFStatement algebra(int difficulty) {
    int x = 2 + rand.nextInt(10);
    int a = 2 + rand.nextInt(9);
    int b = rand.nextInt(10);

    int result = a * x + b;

    bool makeTrue = rand.nextBool();
    int shownX = makeTrue ? x : (x + (rand.nextBool() ? 1 : -1));

    return TFStatement(
      text: "If ${a}x + $b = $result\nthen x = $shownX",
      isTrue: makeTrue,
      icon: Icons.functions,
    );
  }

  TFStatement rectangleArea(int difficulty) {
    int l = 3 + rand.nextInt(10);
    int w = 3 + rand.nextInt(10);
    int correct = l * w;

    bool makeTrue = rand.nextBool();
    int shown = makeTrue ? correct : correct + pickOffset(difficulty);

    return TFStatement(
      text: "Rectangle\nL = $l, W = $w\nArea = $shown",
      isTrue: makeTrue,
      icon: Icons.crop_square,
    );
  }

  TFStatement circleArea(int difficulty) {
    int r = 3 + rand.nextInt(8);
    int correct = (3.14 * r * r).round();

    bool makeTrue = rand.nextBool();
    int shown = makeTrue ? correct : correct + pickOffset(difficulty);

    return TFStatement(
      text: "Circle\nr = $r\nArea ≈ $shown",
      isTrue: makeTrue,
      icon: Icons.circle_outlined,
    );
  }

  TFStatement formulaCheck() {
    final list = [
      const TFStatement(text: "Area of circle = π × r²", isTrue: true, icon: Icons.menu_book),
      const TFStatement(text: "Area of rectangle = L + W", isTrue: false, icon: Icons.menu_book),
      const TFStatement(text: "Perimeter of rectangle = 2(L + W)", isTrue: true, icon: Icons.menu_book),
      const TFStatement(text: "Triangle area = base × height", isTrue: false, icon: Icons.menu_book),
    ];
    return list[rand.nextInt(list.length)];
  }

  int pickOffset(int difficulty) {
    if (difficulty == 1) return rand.nextBool() ? 1 : -1;
    if (difficulty == 2) return rand.nextBool() ? 2 : -2;
    return rand.nextBool() ? 5 : -5;
  }
}

/// A tiny "game state" class so your page stays clean
class TrueFalseGameState {
  static const int targetScore = 20;

  final TFStatementGenerator generator;
  int score = 0;
  TFStatement current = const TFStatement(
    text: "Loading...",
    isTrue: true,
    icon: Icons.hourglass_bottom,
  );

  TrueFalseGameState({TFStatementGenerator? generator})
      : generator = generator ?? TFStatementGenerator();

  void reset() {
    score = 0;
    nextQuestion();
  }

  int difficulty() {
    if (score < 6) return 1;
    if (score < 13) return 2;
    return 3;
  }

  void nextQuestion() {
    current = generator.next(difficulty());
  }

  bool answer(bool playerSaysTrue) {
    final correct = (playerSaysTrue == current.isTrue);
    score += correct ? 1 : -1;
    return correct;
  }

  bool reachedTarget() => score >= targetScore;
}
