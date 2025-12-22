import 'package:flutter/material.dart';
import 'quick_calculation_page.dart';
import 'logical_puzzle_page.dart';
import 'true_false_page.dart';
import 'core/app_theme.dart';
import 'models/game_menu_item.dart';
import 'profile_page.dart';

class MenuPage extends StatelessWidget {
  final String username;
  final bool isNewUser;

  MenuPage({required this.username, required this.isNewUser});

  final List<GameMenuItem> _menuItems = [
    GameMenuItem(
      title: 'Quick Calculation',
      emoji: '⏱️',
      gradientColors: [Colors.orange, Colors.deepOrange],
      routeName: '/quick',
      destination: QuickCalculationPage(),
    ),
    GameMenuItem(
      title: 'Logical Puzzle',
      emoji: '💡',
      gradientColors: [Colors.green, Colors.teal],
      routeName: '/logical',
      destination: LogicalPuzzlePage(),
    ),
    GameMenuItem(
      title: 'True / False',
      emoji: '✅',
      gradientColors: [Colors.blue, Colors.indigo],
      routeName: '/truefalse',
      destination: TrueFalsePage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Welcome, $username',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage(username: username)));
            },
            borderRadius: BorderRadius.circular(50),
            child: CircleAvatar(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: Text(username[0].toUpperCase(), style: TextStyle(color: AppTheme.primaryColor)),
            ),
          ),
          SizedBox(width: 16),
        ],
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Game Mode',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 24),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      return GameMenuCard(item: _menuItems[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameMenuCard extends StatefulWidget {
  final GameMenuItem item;

  GameMenuCard({required this.item});

  @override
  _GameMenuCardState createState() => _GameMenuCardState();
}

class _GameMenuCardState extends State<GameMenuCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 200), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        Navigator.push(context, MaterialPageRoute(builder: (_) => widget.item.destination));
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: widget.item.gradientColors),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.item.gradientColors.first.withOpacity(0.4),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(widget.item.emoji, style: TextStyle(fontSize: 32)),
                ),
                SizedBox(width: 24),
                Text(
                  widget.item.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios, color: Colors.white70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
