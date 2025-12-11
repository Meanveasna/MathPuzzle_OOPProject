import 'package:flutter/material.dart';

class LevelSelectionScreen extends StatelessWidget {
  final List<String> levelNames = List.generate(15, (index) => 'Level ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Level')),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: levelNames.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            child: Text(levelNames[index]),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlayLevelScreen(levelIndex: index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PlayLevelScreen extends StatefulWidget {
  final int levelIndex;
  PlayLevelScreen({required this.levelIndex});

  @override
  _PlayLevelScreenState createState() => _PlayLevelScreenState();
}

class _PlayLevelScreenState extends State<PlayLevelScreen> {
  final TextEditingController controller = TextEditingController();
  String message = '';

  final List<String> questions = [
    "2, 4, 8, 16, ?",
    "     /\\\n    /__\\\n   /\\  /\\   = 5\n  /__\\/__\\  \n\n     /\\\n    /__\\\n   /\\  /\\\n  /__\\/__\\    = ?\n /\\  /\\  /\\\n/__\\/__\\/__\\",
    "3, 10, 18, ?",
    "A + B = 100\nA - B = 60\nA / B = ?",
    "1, 2 = 2\n3, 5 = 15\n2, 7 = 14\n3, 8 = ?",
    " +---+---+\n |   |   |\n +---+---+\n |   |   |\n +---+---+   = 5\n\n +---+---+---+\n |   |   |   |\n +---+---+---+\n |   |   |   |\n +---+---+---+\n |   |   |   |\n +---+---+---+   = ?",
    "5 = 30\n3 = 12\n8 = 72\n7 = ?",
    "2\t1\t0\t0\n4\t1\t1\t1\n6\t1\t0\t1\n?\t?\t?\t?",
    "   5     10\t\t   4     32\n     __\t\t\t      __\n     \\/\t\t\t      \\/\n     2\t\t\t      8\n\n      4     20\n       __\n        \\/\n        ?",
    "7, 15, 31, ?",
    "1, 3, 5\n6, 8, 10\n1, ?, 7",
    "1873, 3187, 7318, ?",
    "  □ + □ = 8\n 2○ + □ = 14\n  △ + ○ = 11\n  △ = ?",
    "E, H, K, ?",
    " +-----+-----+-----+\n | 49  | 64  |  1  |\n +-----+-----+-----+\n |  9  |  ?  | 36  |\n +-----+-----+-----+\n | 81  | 25  | 16  |\n +-----+-----+-----+",
  ];

  final List<String> answers = [
    "32","13","27","4","24","14","56","14","6","63","4","8731","6","O","4"
  ];

  void appendDigit(String digit) {
    setState(() {
      controller.text += digit;
    });
  }

  void deleteDigit() {
    if (controller.text.isNotEmpty) {
      setState(() {
        controller.text = controller.text.substring(0, controller.text.length - 1);
      });
    }
  }

  void checkAnswer() {
    String input = controller.text.trim();
    if (input.toLowerCase() == answers[widget.levelIndex].toLowerCase()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CongratsScreen(
            nextLevel: widget.levelIndex + 1,
          ),
        ),
      );
    } else {
      setState(() {
        message = "Wrong answer! Try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Level ${widget.levelIndex + 1}')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(questions[widget.levelIndex], style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter answer',
                errorText: message.isEmpty ? null : message,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(10, (i) {
                return ElevatedButton(
                  child: Text('$i', style: TextStyle(fontSize: 20)),
                  onPressed: () => appendDigit('$i'),
                  style: ElevatedButton.styleFrom(minimumSize: Size(60, 60)),
                );
              })
              ..add(ElevatedButton(
                child: Text('×', style: TextStyle(fontSize: 20)),
                onPressed: deleteDigit,
                style: ElevatedButton.styleFrom(minimumSize: Size(60, 60)),
              )),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Submit', style: TextStyle(fontSize: 20)),
              onPressed: checkAnswer,
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}

class CongratsScreen extends StatelessWidget {
  final int nextLevel;
  CongratsScreen({required this.nextLevel});

  @override
  Widget build(BuildContext context) {
    bool finishedAll = nextLevel > 14;

    return Scaffold(
      appBar: AppBar(title: Text('Congratulations!')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Correct! 🎉', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text(finishedAll ? 'Back to Level Selection' : 'Next Level', style: TextStyle(fontSize: 20)),
              onPressed: () {
                if (finishedAll) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => PlayLevelScreen(levelIndex: nextLevel)),
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
