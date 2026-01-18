import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'first_page.dart';
import 'core/sfx.dart';
import 'core/app_theme.dart';
import 'settings_page.dart';
import 'main_menu_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mathpuzzlesoop/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Sfx.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? langCode = prefs.getString('language_code');
    if (langCode != null) {
      setState(() {
        _locale = Locale(langCode);
      });
    }
  }

  void setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale, // apply the selected locale
      supportedLocales: [
        Locale('en'), // English
        Locale('km'), // Khmer
      ],
      localizationsDelegates: [
        AppLocalizations.delegate, // your generated localization delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/first',
      routes: {
        '/first': (context) => FirstPage(),
        '/main': (context) => MainMenuPage(username: ""),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}