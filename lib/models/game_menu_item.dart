import 'package:flutter/material.dart';

class GameMenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final String routeName;
  final Widget destination; //navigate push
  final int score;

  GameMenuItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.routeName,
    required this.destination,
    this.score = 0,
  });
}
