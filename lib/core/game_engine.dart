abstract class PuzzleGame {
  int totalScore = 0;
  int questionIndex = 0;

  /// Starts the game or round.
  void start();

  /// Generates the next question or puzzle state.
  void generateQuestion();

  /// Processes user input and returns points awarded for this specific move.
  int processAnswer(dynamic input, int secondsLeft);

  /// Cleans up resources (timers, controllers).
  void dispose();
}
