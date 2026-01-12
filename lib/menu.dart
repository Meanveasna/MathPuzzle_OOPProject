import 'package:flutter/material.dart';

import 'models/game_menu_item.dart';
import 'quick_calculation_page.dart';
import 'logical_puzzle_page.dart';
import 'true_false_page.dart';

class MenuPage extends StatefulWidget {
  final String username;

  const MenuPage({super.key, required this.username});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late final List<GameMenuItem> _menuItems;

  @override
  void initState() {
    super.initState();

    // ✅ IMPORTANT:
    // We create menu items inside initState so we can use widget.username safely.
    _menuItems = [
      GameMenuItem(
        title: "Quick Calculation",
        routeName: "quick",
        icon: Icons.flash_on,
        color: Colors.orange,
        builder: (context) => QuickCalculationPage(username: widget.username),
      ),
      GameMenuItem(
        title: "Logical Math",
        routeName: "logical",
        icon: Icons.extension,
        color: Colors.blue,
        builder: (context) => LogicalPuzzlePage(level: 1, username: widget.username),
      ),
      GameMenuItem(
        title: "True / False",
        routeName: "truefalse",
        icon: Icons.rule,
        color: Colors.green,
        builder: (context) => TrueFalsePage(username: widget.username),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("Menu"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: _menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            return _buildGameCard(context, _menuItems[index]);
          },
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, GameMenuItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => item.builder(ctx)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6)),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: item.color.withOpacity(0.15),
                child: Icon(item.icon, size: 30, color: item.color),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
