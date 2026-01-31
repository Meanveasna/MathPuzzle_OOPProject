import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'core/app_theme.dart';
import 'core/file_storage.dart';
import 'first_page.dart';
import 'player_storage.dart';
import 'main.dart'; // For MyApp
import 'core/sfx.dart';
import 'l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';


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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌍 Language
            Text(
              l10n.language,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLanguageButton(
                    context, 'English', '🇺🇸', const Locale('en')),
                _buildLanguageButton(context, 'ខ្មែរ', '🇰🇭', const Locale('km')),
              ],
            ),

            Divider(height: 40),

            // Audio
            Text(
              l10n.audioSettings,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            _buildVolumeSlider(l10n.musicVolume, _musicVolume, (val) {
              setState(() => _musicVolume = val);
              Sfx.setBgmVolume(val);
            }),

            _buildVolumeSlider(l10n.soundVolume, _soundVolume, (val) {
              setState(() => _soundVolume = val);
              Sfx.setSfxVolume(val);
            }),

            Divider(height: 40),

            // Reset
            Text(
              l10n.gameData,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            ListTile(
              title: Text(l10n.resetProgress),
              subtitle: Text(l10n.resetProgress),
              leading: Icon(Icons.delete_forever, color: Colors.red),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () async {
                bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.resetProgress),
                    content: Text(l10n.confirmExit),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(l10n.no),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          l10n.yes,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await PlayerRepository().resetAll();
                  Sfx.stopBgm();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => FirstPage()),
                    (_) => false,
                  );
                }
              },
            ),

            // About Me
            SizedBox(height: 20),
            ListTile(
              title: Text(l10n.aboutus),
              subtitle: Text(l10n.meetthedeveloper),
              leading: Icon(Icons.info_outline, color: Colors.blue),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.all(30),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                l10n.aboutus,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              _buildDeveloperTile(
                                  l10n.lang, l10n.langdecription),
                             _buildDeveloperTile(l10n.sna, l10n.snadescription),
                              _buildDeveloperTile(l10n.liz, l10n.lizdescription),
                              Text(l10n.g1),
                              Text(l10n.g2),
                              
                              SizedBox(height: 30),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 18,
                                    color: Colors.grey[700],
                                  ),
                                  SizedBox(width: 6),
                                    Text(
                                      '+855 96 81 96 665',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                ],
                              ),

                              SizedBox(height: 8),

                              // Email link
                              InkWell(
                                onTap: () async {
                                  final Uri emailUri = Uri(
                                    scheme: 'mailto',
                                    path: 'engsoklang325@email.com',
                                    queryParameters: {
                                      'subject': 'Support Request',
                                    },
                                  );

                                  if (await canLaunchUrl(emailUri)) {
                                    await launchUrl(
                                      emailUri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    debugPrint('Could not launch email app');
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.email, size: 18),
                                    SizedBox(width: 6),
                                    Text(
                                      'engsoklang325@email.com',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),


                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------- helpers ----------

  Widget _buildLanguageButton(
    BuildContext context,
    String label,
    String flag,
    Locale locale,
  ) {
    bool isSelected =
        Localizations.localeOf(context).languageCode == locale.languageCode;

    return InkWell(
      onTap: () {
        MyApp.setLocale(context, locale);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primaryColor),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeSlider(
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
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

  Widget _buildDeveloperTile(String name, String role) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppTheme.primaryColor,
        child: Text(
          name[0],
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(role),
    );
  }
}
