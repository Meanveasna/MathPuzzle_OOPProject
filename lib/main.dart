import 'package:flutter/material.dart';
import 'core/sfx.dart';

import 'first_page.dart';
import 'settings_page.dart';
import 'main_menu_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Sfx.init(); // ✅ IMPORTANT: prepare the audio player
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/first',
      routes: {
        '/first': (context) => FirstPage(),
        '/main': (context) => MainMenuPage(username: ""),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
