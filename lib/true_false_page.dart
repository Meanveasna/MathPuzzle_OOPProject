import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mathpuzzlesoop/games/true_false_game.dart';
import 'package:mathpuzzlesoop/core/sfx.dart';

import 'package:mathpuzzlesoop/l10n/app_localizations.dart';

class TrueFalsePage extends StatefulWidget {
  final String? username;
  const TrueFalsePage({super.key, this.username});

  @override
  State<TrueFalsePage> createState() => _TrueFalsePageState();
}

class _TrueFalsePageState extends State<TrueFalsePage> {
  static const Color kDarkPurple = Color(0xFF5B2CA0);
  static const int roundSeconds = 20;

  final TrueFalseGameState game = TrueFalseGameState();

  int timeLeft = roundSeconds;
  bool showCongrats = false; //if true → show winning UI instead of game UI
  bool buttonsEnabled = true;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    Sfx.correct();
    restartGame();
  }

  @override
  void dispose() {
    stopTimer();
    Sfx.stopSfx();
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

    final bool correct = (playerSaysTrue == game.current.isTrue);

    game.answer(playerSaysTrue);

    if (correct) {
      Sfx.correct();
    } else {
      Sfx.wrong();
    }

    if (game.reachedTarget()) {
      Sfx.win();
      setState(() => showCongrats = true);
    } else {
      loadNextStatement();
    }
  }

  void timeUp() {
    Sfx.die();
    game.timeout();
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
        if (timeLeft % 2 == 0) {
          Sfx.playTick();
        }
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(l10n.playTrueFalse),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: showCongrats ? _buildCongratsUI(l10n) : _buildGameUI(l10n),
      ),
    );
  }

  Widget _buildGameUI(AppLocalizations l10n) {
    return Column(
      children: [
        Align(alignment: Alignment.centerRight, child: _scoreChip()),

        const SizedBox(height: 14),

        Stack(
          clipBehavior: Clip.none,
          children: [
            _questionCard(game.current),

            Positioned(
              top: -30,
              left: 0,
              right: 0,
              child: Center(child: _timerCircle()),
            ),
          ],
        ),

        const Spacer(),

        _fullButton(
          text: l10n.trueButton,
          color: Colors.green.shade700,
          onTap: buttonsEnabled ? () => submitAnswer(true) : null,
        ),
        const SizedBox(height: 12),
        _fullButton(
          text: l10n.falseButton,
          color: Colors.red.shade700,
          onTap: buttonsEnabled ? () => submitAnswer(false) : null,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildCongratsUI(AppLocalizations l10n) {
    return Center(
      child: Container(
        width: 330,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 70, color: Colors.green),
            const SizedBox(height: 10),
            Text(
              l10n.congratulations,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.finalScore(game.score),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 18),
            _fullButton(
              text: l10n.replay,
              color: Colors.green.shade700,
              onTap: restartGame,
            ),
            const SizedBox(height: 12),
            _fullButton(
              text: l10n.menu,
              color: Colors.red.shade700,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timerCircle() {
    final progress = timeLeft / roundSeconds; // from 1.0 down to 0.0

    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 66,
            height: 66,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor: Colors.deepPurple.shade100,
              valueColor: const AlwaysStoppedAnimation(Colors.deepPurple),
            ),
          ),

          Text(
            "00:${timeLeft.toString().padLeft(2, "0")}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
        ],
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

  String _getQuestionText(TFStatement s, AppLocalizations l10n) {
    switch (s.type) {
      case TFQuestionType.mathOp:
        return l10n.mathOp(
          s.params['a'],
          s.params['b'],
          s.params['c'],
          s.params['shown'],
        );
      case TFQuestionType.percentOf:
        return l10n.percentOf(
          s.params['p'],
          s.params['base'],
          s.params['shown'],
        );
      case TFQuestionType.square:
        return l10n.square(s.params['n'], s.params['shown']);
      case TFQuestionType.algebraProblem:
        return l10n.algebraProblem(
          s.params['a'],
          s.params['b'],
          s.params['result'],
          s.params['shownX'],
        );
      case TFQuestionType.rectangleAreaProblem:
        return l10n.rectangleAreaProblem(
          s.params['l'],
          s.params['w'],
          s.params['shown'],
        );
      case TFQuestionType.circleAreaProblem:
        return l10n.circleAreaProblem(s.params['r'], s.params['shown']);
      case TFQuestionType.formulaAreaCircle:
        return l10n.formulaAreaCircle;
      case TFQuestionType.formulaAreaRect:
        return l10n.formulaAreaRect;
      case TFQuestionType.formulaPerimeterRect:
        return l10n.formulaPerimeterRect;
      case TFQuestionType.formulaAreaTriangle:
        return l10n.formulaAreaTriangle;
      case TFQuestionType.custom:
      default:
        return s.text;
    }
  }

  Widget _questionCard(TFStatement s) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(20, 50, 20, 26),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        children: [
          Icon(s.icon, size: 56, color: Colors.deepPurple),
          const SizedBox(height: 14),
          Text(
            _getQuestionText(s, l10n),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.black, // Text color
            ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
