import 'package:flutter/material.dart';
import 'first_page.dart';
import 'core/sfx.dart';
import 'settings_page.dart';
import 'main_menu_page.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

// Global RouteObserver
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

// GLOBAL PAUSE / RESUME SYSTEM
final List<VoidCallback> _pauseCallbacks = [];
final List<VoidCallback> _resumeCallbacks = [];

void registerPauseCallback({
  required VoidCallback onPause,
  required VoidCallback onResume,
}) {
  _pauseCallbacks.add(onPause);
  _resumeCallbacks.add(onResume);
}

void pauseAllGames() {
  for (final cb in _pauseCallbacks) {
    cb();
  }
}

void resumeAllGames() {
  for (final cb in _resumeCallbacks) {
    cb();
  }
}

// MAIN
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Sfx.init();
  runApp(MyApp());
}
// APP ROOT
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state =
        context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Pause all sounds & timers
      _pauseGames();
      Sfx.pauseBgmBySystem(); // Only pause BGM
      // Do NOT call stopSfx! short sounds are one-shot, we let page handle it
    } else if (state == AppLifecycleState.resumed) {
      // Resume only currently active pages
      _resumeGames();
      Sfx.resumeBgmBySystem(); // Only resume BGM if it was playing
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,

      // Needed for RouteAware pages
      navigatorObservers: [routeObserver],

      supportedLocales: const [
        Locale('en'),
        Locale('km'),
      ],

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Global font
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'GoogleSans',
            ),
          ),
          child: child!,
        );
      },

      initialRoute: '/first',
      routes: {
        '/first': (context) => FirstPage(),
        '/main': (context) => MainMenuPage(username: ""),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
