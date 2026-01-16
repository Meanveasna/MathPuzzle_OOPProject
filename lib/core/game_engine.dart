abstract class PuzzleGame {
  int totalScore = 0;
  int questionIndex = 0;

  void start();

  void generateQuestion();

  int processAnswer(dynamic input, int secondsLeft);

  void dispose();
}
