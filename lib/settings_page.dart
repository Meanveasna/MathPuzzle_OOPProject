import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'core/app_theme.dart';
import 'core/file_storage.dart';
import 'first_page.dart';
import 'player_storage.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _musicVolume = 0.5;
  double _soundVolume = 0.5;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _musicVolume = prefs.getDouble('musicVolume') ?? 0.5;
      _soundVolume = prefs.getDouble('soundVolume') ?? 0.5;
    });
  }

  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('musicVolume', _musicVolume);
    await prefs.setDouble('soundVolume', _soundVolume);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Audio Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            // Music Volume
            _buildVolumeSlider('Music Volume', _musicVolume, (val) {
              setState(() => _musicVolume = val);
              _saveSettings();
            }),

            // Sound Volume
            _buildVolumeSlider('Sound Effects', _soundVolume, (val) {
              setState(() => _soundVolume = val);
              _saveSettings();
            }),

            Divider(height: 40),

            Text('Game Data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            SizedBox(height: 10),

            ListTile(
              title: Text("Reset Progress"),
              subtitle: Text("Clear all levels and scores"),
              leading: Icon(Icons.delete_forever, color: Colors.red),
              onTap: () async {
                bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Reset Game"),
                    content: Text("Are you sure you want to reset the game? All progress will be lost."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("No"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text("Yes", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  // Fully reset everything
                  await PlayerRepository().resetAll();

                  // Navigate to FirstPage immediately, clearing all previous routes
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => FirstPage()),
                        (route) => false,
                  );
                }
              },
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),


          ],
        ),
      ),
    );
  }

  Widget _buildVolumeSlider(String label, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Slider(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }
}
