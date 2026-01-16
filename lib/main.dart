import 'package:flutter/material.dart';
import 'first_page.dart';
import 'core/sfx.dart';
import 'core/app_theme.dart';
import 'settings_page.dart';
import 'main_menu_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Sfx.init();
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
