import 'package:flutter/material.dart';

class GameMenuItem {
  final String title;
  final String routeName; // required by your project
  final IconData icon;
  final Color color;

  // We store a builder so we can pass username later safely.
  final Widget Function(BuildContext context) builder;

  const GameMenuItem({
    required this.title,
    required this.routeName,
    required this.icon,
    required this.color,
    required this.builder,
  });
}
