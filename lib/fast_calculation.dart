import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class FastCalculationMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fast Calculation Menu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OpButton(op: 1, text: '+'),
            OpButton(op: 2, text: '-'),
            OpButton(op: 3, text: '*'),
            OpButton(op: 4, text: '/'),
            OpButton(op: 5, text: 'Mix'),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Back to Main Menu'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class OpButton extends StatelessWidget {
  final int op;
  final String text;

  OpButton({required this.op, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ElevatedButton(
        child: Text(text, style: TextStyle(fontSize: 22)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FastCalculationScreen(mode: op, modeName: text),
            ),
          );
        },
      ),
    );
  }
}

class FastCalculationScreen extends StatefulWidget {
  final int mode;
  final String modeName;

  FastCalculationScreen({required this.mode, required this.modeName});

  @override
  _FastCalculationScreenState createState() => _FastCalculationScreenState();
}

class _FastCalculationScreenState extends State<FastCalculationScreen> {
  final Random rand = Random();
  final TextEditingController answerController = TextEditingController();

  int questionIndex = 0;
  int totalScore = 0;
  int a = 0, b = 0;
  String operator = '+';
  int correctAnswer = 0;
  Timer? timer;
  int secondsLeft = 20;
  bool showResult = false;

  @override
  void initState() {
    super.initState();
    generateQuestion();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    secondsLeft = 20;
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        secondsLeft--;
      });
      if (secondsLeft <= 0) {
        t.cancel();
        processAnswer(null);
      }
    });
  }

  void generateQuestion() {
    a = rand.nextInt(20) + 1;
    b = rand.nextInt(20) + 1;

    List<String> ops = ['+', '-', '*', '/'];
    if (widget.mode == 5) {
      operator = ops[rand.nextInt(4)];
    } else {
      switch (widget.mode) {
        case 1:
          operator = '+';
          break;
        case 2:
          operator = '-';
          break;
        case 3:
          operator = '*';
          break;
        case 4:
          operator = '/';
          break;
      }
    }

    if (operator == '/') {
      b = rand.nextInt(10) + 1;
      int multiplier = rand.nextInt(10) + 1;
      a = b * multiplier;
      correctAnswer = a ~/ b;
    } else if (operator == '+') {
      correctAnswer = a + b;
    } else if (operator == '-') {
      correctAnswer = a - b;
    } else if (operator == '*') {
      correctAnswer = a * b;
    }
  }

  void processAnswer(String? input) {
    int score = 0;
    if (input == null || input.isEmpty) {
      score = 0;
    } else {
      int? ans = int.tryParse(input);
      if (ans == correctAnswer) {
        if (secondsLeft > 15)
          score = 3;
        else if (secondsLeft > 10)
          score = 2;
        else if (secondsLeft > 0)
          score = 1;
      }
    }

    totalScore += score;
    questionIndex++;

    if (questionIndex >= 10) {
      timer?.cancel();
      setState(() {
        showResult = true;
      });
    } else {
      answerController.clear();
      generateQuestion();
      startTimer();
    }
    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (showResult) {
      return Scaffold(
        appBar: AppBar(title: Text('Round Complete')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Total Score: $totalScore', style: TextStyle(fontSize: 30)),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Back to Menu'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('${widget.modeName} Round')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Question ${questionIndex + 1} / 10', style: TextStyle(fontSize: 22)),
            SizedBox(height: 20),
            Text('$a $operator $b = ?', style: TextStyle(fontSize: 28)),
            SizedBox(height: 20),
            TextField(
              controller: answerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your Answer',
              ),
              onSubmitted: (value) => processAnswer(value),
            ),
            SizedBox(height: 20),
            Text('Time Left: $secondsLeft s', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () => processAnswer(answerController.text),
            ),
          ],
        ),
      ),
    );
  }
}
