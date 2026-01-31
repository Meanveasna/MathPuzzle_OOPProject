import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'games/quick_calculation_game.dart';
import 'core/app_theme.dart';
import 'models/user_model.dart';
import 'player_storage.dart';
import 'core/sfx.dart';
import 'package:mathpuzzles/l10n/app_localizations.dart';
import 'package:mathpuzzles/main.dart';
class QuickCalculationPage extends StatefulWidget {
  final int level;
  final String username;

  QuickCalculationPage({this.level = 1, required this.username});

  @override
  _QuickCalculationPageState createState() => _QuickCalculationPageState();
}

//Decides mode (addition, subtraction, multiplication, division) and title based on level
//The object that can hold the data created from createState()
class _QuickCalculationPageState extends State<QuickCalculationPage> {
  @override
  Widget build(BuildContext context) {
    return QuickCalculationScreen(
      initialLevel: widget.level,
      username: widget.username,
    );
  }
}

class QuickCalculationScreen extends StatefulWidget {
  final int initialLevel;
  final String username;

  QuickCalculationScreen({required this.initialLevel, required this.username});

  @override
  _QuickCalculationScreenState createState() => _QuickCalculationScreenState();
}

//Handles actual gameplay UI: question, timer, keypad, input
class _QuickCalculationScreenState extends State<QuickCalculationScreen>
    with TickerProviderStateMixin {
  late QuickCalculationGame game; //The page owns a game object
  String currentInput = "";

  int secondsLeft = 10;
  bool showResult = false;
  Timer? timer; //nullable to prevent background run

  int correctCount = 0;
  int earnedStars = 0;
  bool isPaused = false;

  // 🔒 System pause flag (NEW – does not affect your logic)
  bool _pausedBySystem = false;

  @override
  void initState() {
    super.initState();
    game = QuickCalculationGame(widget.initialLevel);
    game.start();
    secondsLeft = 10;

    // ▶️ Start game timer
    startTimer();

    // 🔌 Register app-level pause / resume (ADDED)
    registerPauseCallback(
      onPause: () {
        _pausedBySystem = true;
        timer?.cancel(); // hard stop timer
      },
      onResume: () {
        if (_pausedBySystem && !isPaused && !showResult) {
          _pausedBySystem = false;
          startTimer(); // resume SAME timer safely
        }
      },
    );
  }

  void startTimer() {
    timer?.cancel(); // stop any existing timer

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || isPaused || _pausedBySystem) return;

      if (secondsLeft == 3) {
        Sfx.playTick();
      }

      setState(() {
        secondsLeft--;
      });

      if (secondsLeft <= 0) {
        t.cancel();
        Sfx.die();
        processAnswer(null); // Timeout
      }
    });
  }

  // Keypad Logic and input validation
  void appendDigit(String digit) {
    if (currentInput.length < 6) {
      setState(() {
        currentInput += digit;
      });
      _checkInput();
    }
  }

  void deleteDigit() {
    if (currentInput.isNotEmpty) {
      setState(() {
        currentInput =
            currentInput.substring(0, currentInput.length - 1);
      });
    }
  }

  void clearInput() {
    setState(() {
      currentInput = "";
      });
  }

  void _checkInput() {
    int? val = int.tryParse(currentInput);
    if (val != null && val == game.getCorrectAnswer()) {
      processAnswer(currentInput);
    }
  }

  void processAnswer(String? input) {
    timer?.cancel();

    int score = game.processAnswer(input, secondsLeft);
    if (score > 0) {
      Sfx.win2();
      correctCount++;

      if (correctCount == 5) {
        _unlockNextLevel();
      }
    }

    if (game.questionIndex >= 10) {
      _finishLevel();
    } else {
      currentInput = "";
      game.generateQuestion();
      secondsLeft = 10;
      startTimer();
    }

    if (mounted) setState(() {});
  }

  // Early unlock of the next level
  void _unlockNextLevel() async {
    User? user = await PlayerRepository().getUser();
    if (user != null) {
      int currentMaxLevel = user.levels['quick'] ?? 1;
      if (widget.initialLevel >= currentMaxLevel) {
        user.levels['quick'] = widget.initialLevel + 1;
        await PlayerRepository().updateUser(user);
      }
    }
  }

  void _finishLevel() async {
    if (correctCount >= 10)
      earnedStars = 3;
    else if (correctCount >= 8)
      earnedStars = 2;
    else if (correctCount >= 5)
      earnedStars = 1;
    else
      earnedStars = 0;

    User? user = await PlayerRepository().getUser();
    if (user != null) {
      var quickStars = user.levelStars['quick'] ?? {};
      int currentStars =
          quickStars['${widget.initialLevel}'] ?? 0;

      if (earnedStars > currentStars) {
        quickStars['${widget.initialLevel}'] = earnedStars;
        user.levelStars['quick'] = quickStars;
      }

      if (earnedStars >= 1) {
        int currentMaxLevel = user.levels['quick'] ?? 1;
        if (widget.initialLevel >= currentMaxLevel) {
          user.levels['quick'] = widget.initialLevel + 1;
        }
      }

      user.calculateTotalScore();
      await PlayerRepository().updateUser(user);
    }

    if (mounted) {
      Sfx.playCoinSequence(earnedStars);
      setState(() {
        showResult = true;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    // ❗ DO NOT stop global sound here
    super.dispose();
  }

  void togglePause() {
  setState(() {
    isPaused = !isPaused;
  });

  if (isPaused) {
    timer?.cancel();
    // Do not stop SFX globally here
  } else {
    startTimer();
    // Sounds will naturally play as timer hits ticks
  }
}




  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    //If the level finished, show result screen. Else show game screen
    if (showResult) {
      return _buildResultScreen(l10n);
    }

    return Stack(
      children: [
        _buildGameUI(context, l10n),
        if (isPaused)
          Positioned.fill(
            child: Stack(
              children: [
                // Blur Effect
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
                Center(
                  child: Container(
                    width: 300,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: Colors.black26,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.pause_circle_filled,
                          size: 60,
                          color: Color(0xFFFF8FA3),
                        ),
                        SizedBox(height: 16),
                        Text(
                          l10n.paused,
                          style: TextStyle(
                            fontFamily: 'Google Sans',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(height: 24),

                        // Resume Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.play_arrow_rounded),
                            label: Text(
                              l10n.resume,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF64B5F6),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: StadiumBorder(),
                              elevation: 5,
                            ),
                            onPressed: togglePause,
                          ),
                        ),
                        SizedBox(height: 16),
                        // Home Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: Icon(Icons.home_rounded),
                            label: Text(
                              l10n.home,
                              style: TextStyle(fontSize: 18),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black54,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: Colors.black12, width: 2),
                              shape: StadiumBorder(),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildGameUI(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD), // Light blue bg
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    l10n.calculator,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.black54),
                      //SizedBox(width: 10),
                      //Icon(Icons.pause_circle_outline, color: Colors.black54),
                      IconButton(
                        icon: Icon(
                          isPaused
                              ? Icons.play_circle_outline
                              : Icons.pause_circle_outline,
                          color: Colors.black87,
                          size: 28,
                        ),
                        onPressed: togglePause,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF8FA3), // Pinkish
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.levelLabel(widget.initialLevel),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            //Time UI (Circular bottom, Text Top)
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: CircularProgressIndicator(
                                    value: secondsLeft / 10,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                    backgroundColor: Colors.white24,
                                    strokeWidth: 6,
                                  ),
                                ),
                                Text(
                                  "$secondsLeft",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${l10n.coin} : 0",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "🏆 $correctCount",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Question
                        Text(
                          "${game.a} ${game.operator} ${game.b}",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Answer Box
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black87, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              currentInput.isEmpty ? "?" : currentInput,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  // Keypad
                  _buildKeypad(l10n),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          _buildKeypadRow(['7', '8', '9']),
          SizedBox(height: 15),
          _buildKeypadRow(['4', '5', '6']),
          SizedBox(height: 15),
          _buildKeypadRow(['1', '2', '3']),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton(
                l10n.clear,
                isFunction: true,
                onTap: clearInput,
              ),
              _buildKeypadButton("0", onTap: () => appendDigit("0")),
              _buildKeypadButton(
                "⌫",
                isFunction: true,
                isIcon: true,
                onTap: deleteDigit,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels
          .map((l) => _buildKeypadButton(l, onTap: () => appendDigit(l)))
          .toList(),
    );
  }

  Widget _buildKeypadButton(
    String label, {
    bool isFunction = false,
    bool isIcon = false,
    required VoidCallback onTap,
  }) {
    Color bgColor = isFunction
        ? Colors.white
        : Color(0xFFFF6B6B); // Reddish for numbers
    Color textColor = Colors.black;

    return GestureDetector(
      onTap: isPaused ? null : onTap,
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: isFunction ? Border.all(color: Colors.black, width: 1) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: isIcon
            ? Icon(Icons.backspace_outlined, size: 28)
            : Text(
                label,
                style: TextStyle(
                  fontSize: label.length > 2 ? 18 : 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
      ),
    );
  }

  Widget _buildResultScreen(AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: Text(l10n.calculator)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  index < earnedStars ? Icons.star : Icons.star_border,
                  size: 60,
                  color: Colors.amber,
                );
              }),
            ),
            SizedBox(height: 20),
            Text(
              earnedStars >= 1 ? l10n.levelPassed : l10n.levelFailed,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: earnedStars >= 1 ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              l10n.correctCountLabel(correctCount, 10),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 40),

            if (earnedStars >= 1)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(l10n.nextLevel, style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuickCalculationPage(
                        level: widget.initialLevel + 1,
                        username: widget.username,
                      ),
                    ),
                  );
                },
              ),

            SizedBox(height: 20),
            ElevatedButton(
              child: Text(l10n.retry),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuickCalculationPage(
                      level: widget.initialLevel,
                      username: widget.username,
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: Text(l10n.backToMenu),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
