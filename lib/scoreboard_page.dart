
import 'package:flutter/material.dart';
import 'models/user_model.dart';
import 'player_storage.dart';
import 'core/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreboardPage extends StatefulWidget {
  final String currentUsername;
  ScoreboardPage({required this.currentUsername});

  @override
  _ScoreboardPageState createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  List<User> _topPlayers = [];
  bool _isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadScoreboard();
  // }

  // void _loadScoreboard() async {
  //   // Force reload from repo to ensure updated scores
  //   await PlayerRepository().load();
  //   List<User> players = PlayerRepository().getTopPlayers();

  //   if (mounted) {
  //     setState(() {
  //       _topPlayers = players;
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Scoreboard', style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            color: AppTheme.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, color: Colors.amber, size: 40),
                SizedBox(width: 10),
                Text(
                  "Top Players",
                  style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _topPlayers.length,
              itemBuilder: (context, index) {
                final player = _topPlayers[index];
                bool isMe = player.username == widget.currentUsername;

                return Card(
                  color: isMe ? Colors.amber[50] : Colors.white,
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    // Removed redundant leading
                    title: Text(
                        player.username,
                        style: TextStyle(fontWeight: FontWeight.bold, color: isMe ? Colors.brown : Colors.black87)
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${player.totalScore} pts',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800]),
                      ),
                    ),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '#${index + 1}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Text(player.avatarId.isNotEmpty ? player.avatarId : '😊', style: TextStyle(fontSize: 24)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
