import 'package:flutter/material.dart';

class GameMenuItem {
  final String title;
  final String emoji; // Changed from IconData
  final List<Color> gradientColors;
  final String routeName;
  final Widget destination;

  GameMenuItem({
    required this.title,
    required this.emoji,
    required this.gradientColors,
    required this.routeName,
    required this.destination,
  });
}
