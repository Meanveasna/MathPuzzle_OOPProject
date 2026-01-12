import 'dart:async';
import 'package:flutter/material.dart';
import 'games/true_false_game.dart';
import 'core/sfx.dart';


class TrueFalsePage extends StatefulWidget {
  final String? username;
  const TrueFalsePage({super.key, this.username});

  @override
  State<TrueFalsePage> createState() => _TrueFalsePageState();
}

class _TrueFalsePageState extends State<TrueFalsePage> {
  static const int roundSeconds = 20;

  final TrueFalseGameState game = TrueFalseGameState();

  int timeLeft = roundSeconds;
  bool showCongrats = false;
  bool buttonsEnabled = true;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    Sfx.correct(); // test sound once
    restartGame();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  void restartGame() {
    stopTimer();
    setState(() {
      showCongrats = false;
      buttonsEnabled = true;
      timeLeft = roundSeconds;
      game.reset();
    });
    startTimer();
  }

  void loadNextStatement() {
    stopTimer();
    setState(() {
      timeLeft = roundSeconds;
      buttonsEnabled = true;
      game.nextQuestion();
    });
    startTimer();
  }

  void submitAnswer(bool playerSaysTrue) {
    if (!buttonsEnabled || showCongrats) return;

    stopTimer();
    setState(() => buttonsEnabled = false);

    // ✅ check correctness using the current question (before moving next)
    final bool correct = (playerSaysTrue == game.current.isTrue);

    // ✅ update game score/state
    game.answer(playerSaysTrue);

    // ✅ play correct/wrong sound
    if (correct) {
      Sfx.correct();
    } else {
      Sfx.wrong();
    }

    // ✅ win or next
    if (game.reachedTarget()) {
      Sfx.win();
      setState(() => showCongrats = true);
    } else {
      loadNextStatement(); // this will re-enable buttons
    }
  }

  void timeUp() {
    Sfx.timeUp();

    // treat as wrong (simple)
    game.score -= 1;

    if (game.reachedTarget()) {
      Sfx.win();
      setState(() => showCongrats = true);
    } else {
      loadNextStatement();
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || showCongrats) {
        t.cancel();
        return;
      }

      if (timeLeft <= 1) {
        t.cancel();
        setState(() => timeLeft = 0);
        timeUp();
      } else {
        setState(() => timeLeft -= 1);
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  Color _timerColor() {
    if (timeLeft <= 5) return Colors.red;
    if (timeLeft <= 10) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("True / False"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: showCongrats ? _buildCongratsUI() : _buildGameUI(),
      ),
    );
  }

  Widget _buildGameUI() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_timerCircle(), _scoreChip()],
        ),
        const SizedBox(height: 18),
        _questionCard(game.current),
        const Spacer(),
        _fullButton(
          text: "TRUE",
          color: Colors.green.shade700,
          onTap: buttonsEnabled ? () => submitAnswer(true) : null,
        ),
        const SizedBox(height: 12),
        _fullButton(
          text: "FALSE",
          color: Colors.red.shade700,
          onTap: buttonsEnabled ? () => submitAnswer(false) : null,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildCongratsUI() {
    return Center(
      child: Container(
        width: 330,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 70, color: Colors.green),
            const SizedBox(height: 10),
            const Text(
              "Congratulations!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text("Final Score: ${game.score}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 18),
            _fullButton(
              text: "Replay",
              color: Colors.green.shade700,
              onTap: restartGame,
            ),
            const SizedBox(height: 12),
            _fullButton(
              text: "Menu",
              color: Colors.red.shade700,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timerCircle() {
    // simple circle + color change
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: _timerColor().withOpacity(0.20),
        shape: BoxShape.circle,
        border: Border.all(color: _timerColor(), width: 2),
      ),
      child: Center(
        child: Text(
          timeLeft.toString().padLeft(2, "0"),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  Widget _scoreChip() {
    return Row(
      children: [
        const Icon(Icons.monetization_on, color: Color(0xFFFFC107)),
        const SizedBox(width: 6),
        Text(
          "${game.score}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _questionCard(TFStatement s) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Icon(s.icon, size: 48, color: Colors.deepPurple),
          const SizedBox(height: 10),
          Text(
            s.text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _fullButton({
    required String text,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
