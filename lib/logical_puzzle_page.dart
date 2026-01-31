import 'package:flutter/material.dart';
import 'main_menu_page.dart';
import 'games/logical_puzzle_game.dart';
import 'level_selection_page.dart';
import 'player_storage.dart';
import 'models/user_model.dart';
import 'core/sfx.dart';
import 'package:mathpuzzles/main.dart';
import 'package:mathpuzzles/l10n/app_localizations.dart';

final LogicalPuzzleGame game = LogicalPuzzleGame();

class LogicalPuzzlePage extends StatelessWidget {
  final String username;
  final int level; // 1-based level from LevelSelectionPage

  const LogicalPuzzlePage({
    super.key,
    required this.username,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return PlayLevelScreen(
      username: username,
      levelIndex: level - 1, // convert to 0-based
    );
  }
}

class PlayLevelScreen extends StatefulWidget {
  final int levelIndex;
  final String username;
  
  const PlayLevelScreen({
    super.key,
    required this.levelIndex,
    required this.username,
  });

  @override
  _PlayLevelScreenState createState() => _PlayLevelScreenState();
}

const Color backgroundColor = Color(0xFFE3F2FD); // soft blue
const Color primaryColor = Color(0xFFFF8FA3);         // default Flutter pink

class _PlayLevelScreenState extends State<PlayLevelScreen> {
  final TextEditingController controller = TextEditingController();

  bool _pausedBySystem = false;
  String message = '';
  @override
void initState() {
  super.initState();

  // Register system pause / resume
  registerPauseCallback(
    onPause: () {
      _pausedBySystem = true;
      Sfx.stopSfx();
    },
    onResume: () {
      _pausedBySystem = false;
    },
  );
}

@override
void dispose() {
  // Safety: stop any pending short sound
  Sfx.stopSfx();
  super.dispose();
}


  void appendDigit(String digit) {
    if (controller.text.length >= 5) return;
    setState(() {
      controller.text += digit;
    });
  }

  void deleteDigit() {
    if (controller.text.isNotEmpty) {
      setState(() {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
      });
    }
  }

  Future<void> checkAnswer(AppLocalizations l10n) async {
    if (game.isCorrect(widget.levelIndex, controller.text)) {
      int nextUnlockedLevel = widget.levelIndex + 2;

      final repo = PlayerRepository();
      User? user = await repo.getUser();
      if (user != null) {
        final currentUnlocked = user.levels['logical'] ?? 1;
        if (nextUnlockedLevel > currentUnlocked) {
          user.levels['logical'] = nextUnlockedLevel;
        }
        await repo.updateUser(user);
      }
      
      Sfx.win(); // Play win sound

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CongratsScreen(
            username: widget.username,
            nextLevel: widget.levelIndex + 2,
          ),
        ),
      );
    } else {
      setState(() {
        message = l10n.wrongAnswer;
        controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
        backgroundColor: backgroundColor, // soft blue background
        appBar: AppBar(
          title: Text(l10n.levelLabel(widget.levelIndex + 1)),
          //backgroundColor: Colors.white,
          foregroundColor: Colors.black, // black text/icon on white appbar
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Display question in a fixed scrollable area
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.39, // fixed height for question
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: game.questions[widget.levelIndex],
                  ),
                ),
              ),
            ),

            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 0.5),
                      ),
                      hintText: l10n.enterAnswer,
                      errorText: message.isEmpty ? ' ' : message, // reserve 1 space if empty
                      errorStyle: TextStyle(height: 0.8), // make it smaller so it doesn’t push much
                    ),

                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  child: Text(
                    '×',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  onPressed: deleteDigit,
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: primaryColor, width: 0.5),
                    minimumSize: Size(60, 60),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: 10,
              itemBuilder: (context, i) {
                return ElevatedButton(
                  child: Text(
                    '$i',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  onPressed: () => appendDigit('$i'),
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: primaryColor, width: 0.5),
                    minimumSize: Size(60, 60),
                  ),
                );
              },
            ),
            SizedBox(height: 5),
            ElevatedButton(
              child: Text(
                l10n.submit,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              onPressed: () => checkAnswer(l10n),
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: primaryColor, width: 0.5),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),

    );
  } 
}

class CongratsScreen extends StatelessWidget {
  final int nextLevel;
  final String username;

  const CongratsScreen({
    super.key,
    required this.nextLevel,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    bool finishedAll = nextLevel > 15;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.congratulations), automaticallyImplyLeading: false,centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.correctAnswer,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(
                finishedAll ? l10n.backToMenu : l10n.nextLevel,
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                if (finishedAll) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MainMenuPage(username: username),
                    ),
                    (route) => false,
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LogicalPuzzlePage(
                        username: username,
                        level: nextLevel,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
