import 'package:flutter/material.dart';
import 'first_page.dart';
import 'core/app_theme.dart';

void main() {
  runApp(MathPuzzleApp());
}

class MathPuzzleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathPuzzle',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}
