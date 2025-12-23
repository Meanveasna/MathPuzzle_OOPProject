import 'package:flutter/material.dart';

class LogicalPuzzlePage extends StatelessWidget {
  final int level;

  LogicalPuzzlePage({this.level = 1});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logical Puzzle - Level $level')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb, size: 80, color: Colors.amber),
            SizedBox(height: 20),
            Text('Puzzle Level $level', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Find the pattern...', style: TextStyle(fontSize: 18, color: Colors.grey)),
            // Placeholder for actual puzzle logic
          ],
        ),
      ),
    );
  }
}
