import 'package:flutter/material.dart';
import 'logical_puzzle.dart';
import 'fast_calculation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // updated from 'primary'
            textStyle: TextStyle(fontSize: 20),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      home: MainMenu(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// ---------------- MAIN MENU ----------------
class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('===== Puzzle Game =====')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuButton(
              text: '1. Logical Puzzle',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LevelSelectionScreen()),
                );
              },
            ),
            MenuButton(
              text: '2. Fast Calculation',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FastCalculationMenu()),
                );
              },
            ),
            MenuButton(
              text: '0. Exit',
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  MenuButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ElevatedButton(
        child: Text(text),
        onPressed: onTap,
      ),
    );
  }
}
