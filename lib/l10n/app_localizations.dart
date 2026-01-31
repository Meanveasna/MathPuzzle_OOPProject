import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_km.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('km'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Math Puzzle'**
  String get appTitle;

  /// No description provided for @mathPuzzlesTitle.
  ///
  /// In en, this message translates to:
  /// **'MATH\nPUZZLES'**
  String get mathPuzzlesTitle;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'START GAME'**
  String get startGame;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enterUsername;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profile;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get saveChanges;

  /// No description provided for @totalScore.
  ///
  /// In en, this message translates to:
  /// **'Total Score'**
  String get totalScore;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @khmer.
  ///
  /// In en, this message translates to:
  /// **'Khmer (ខ្មែរ)'**
  String get khmer;

  /// No description provided for @audioSettings.
  ///
  /// In en, this message translates to:
  /// **'Audio Settings'**
  String get audioSettings;

  /// No description provided for @musicVolume.
  ///
  /// In en, this message translates to:
  /// **'Music Volume'**
  String get musicVolume;

  /// No description provided for @soundVolume.
  ///
  /// In en, this message translates to:
  /// **'Sound Volume'**
  String get soundVolume;

  /// No description provided for @gameData.
  ///
  /// In en, this message translates to:
  /// **'Game Data'**
  String get gameData;

  /// No description provided for @resetProgress.
  ///
  /// In en, this message translates to:
  /// **'Reset Progress'**
  String get resetProgress;

  /// No description provided for @resetProgressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all levels and scores'**
  String get resetProgressSubtitle;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @chooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Avatar'**
  String get chooseAvatar;

  /// No description provided for @playQuick.
  ///
  /// In en, this message translates to:
  /// **'Quick Calculation'**
  String get playQuick;

  /// No description provided for @playQuickDesc.
  ///
  /// In en, this message translates to:
  /// **'Solve simple math problems quickly.'**
  String get playQuickDesc;

  /// No description provided for @playLogical.
  ///
  /// In en, this message translates to:
  /// **'Logical Puzzle'**
  String get playLogical;

  /// No description provided for @playLogicalDesc.
  ///
  /// In en, this message translates to:
  /// **'Find the missing pattern.'**
  String get playLogicalDesc;

  /// No description provided for @playTrueFalse.
  ///
  /// In en, this message translates to:
  /// **'True / False'**
  String get playTrueFalse;

  /// No description provided for @playTrueFalseDesc.
  ///
  /// In en, this message translates to:
  /// **'Decide if the equation is correct.'**
  String get playTrueFalseDesc;

  /// No description provided for @trainBrain.
  ///
  /// In en, this message translates to:
  /// **'Train Your Brain, Improve Your Math Skill'**
  String get trainBrain;

  /// No description provided for @scoreboard.
  ///
  /// In en, this message translates to:
  /// **'Scoreboard'**
  String get scoreboard;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @confirmExit.
  ///
  /// In en, this message translates to:
  /// **'Confirm Exit'**
  String get confirmExit;

  /// No description provided for @confirmExitContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the app?'**
  String get confirmExitContent;

  /// No description provided for @selectLevel.
  ///
  /// In en, this message translates to:
  /// **'Select Level'**
  String get selectLevel;

  /// No description provided for @levelLocked.
  ///
  /// In en, this message translates to:
  /// **'Level {level} is locked! Complete previous levels first.'**
  String levelLocked(Object level);

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelLabel(Object level);

  /// No description provided for @nextLevel.
  ///
  /// In en, this message translates to:
  /// **'NEXT LEVEL'**
  String get nextLevel;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'RETRY'**
  String get retry;

  /// No description provided for @backToMenu.
  ///
  /// In en, this message translates to:
  /// **'Back to Menu'**
  String get backToMenu;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct! 🎉'**
  String get correctAnswer;

  /// No description provided for @wrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Wrong answer! Try again.'**
  String get wrongAnswer;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @finalScore.
  ///
  /// In en, this message translates to:
  /// **'Final Score: {score}'**
  String finalScore(Object score);

  /// No description provided for @replay.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get replay;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @levelPassed.
  ///
  /// In en, this message translates to:
  /// **'Level Passed!'**
  String get levelPassed;

  /// No description provided for @levelFailed.
  ///
  /// In en, this message translates to:
  /// **'Level Failed'**
  String get levelFailed;

  /// No description provided for @correctCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct: {count} / {total}'**
  String correctCountLabel(Object count, Object total);

  /// No description provided for @trueButton.
  ///
  /// In en, this message translates to:
  /// **'TRUE'**
  String get trueButton;

  /// No description provided for @falseButton.
  ///
  /// In en, this message translates to:
  /// **'FALSE'**
  String get falseButton;

  /// No description provided for @calculator.
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get calculator;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @enterAnswer.
  ///
  /// In en, this message translates to:
  /// **'Enter answer'**
  String get enterAnswer;

  /// No description provided for @coin.
  ///
  /// In en, this message translates to:
  /// **'Coin'**
  String get coin;

  /// No description provided for @mathOp.
  ///
  /// In en, this message translates to:
  /// **'{a} + {b} × {c} = {shown}'**
  String mathOp(Object a, Object b, Object c, Object shown);

  /// No description provided for @percentOf.
  ///
  /// In en, this message translates to:
  /// **'{p}% of {base} = {shown}'**
  String percentOf(Object p, Object base, Object shown);

  /// No description provided for @square.
  ///
  /// In en, this message translates to:
  /// **'{n}² = {shown}'**
  String square(Object n, Object shown);

  /// No description provided for @algebraProblem.
  ///
  /// In en, this message translates to:
  /// **'If {a}x + {b} = {result}\nthen x = {shownX}'**
  String algebraProblem(Object a, Object b, Object result, Object shownX);

  /// No description provided for @rectangleAreaProblem.
  ///
  /// In en, this message translates to:
  /// **'Rectangle\nL = {l}, W = {w}\nArea = {shown}'**
  String rectangleAreaProblem(Object l, Object w, Object shown);

  /// No description provided for @circleAreaProblem.
  ///
  /// In en, this message translates to:
  /// **'Circle\nr = {r}\nArea ≈ {shown}'**
  String circleAreaProblem(Object r, Object shown);

  /// No description provided for @formulaAreaCircle.
  ///
  /// In en, this message translates to:
  /// **'Area of circle = π × r²'**
  String get formulaAreaCircle;

  /// No description provided for @formulaAreaRect.
  ///
  /// In en, this message translates to:
  /// **'Area of rectangle = L + W'**
  String get formulaAreaRect;

  /// No description provided for @formulaPerimeterRect.
  ///
  /// In en, this message translates to:
  /// **'Perimeter of rectangle = 2(L + W)'**
  String get formulaPerimeterRect;

  /// No description provided for @formulaAreaTriangle.
  ///
  /// In en, this message translates to:
  /// **'Triangle area = base × height'**
  String get formulaAreaTriangle;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile Saved!'**
  String get profileSaved;

  /// No description provided for @editUsername.
  ///
  /// In en, this message translates to:
  /// **'Edit Username'**
  String get editUsername;

  /// No description provided for @enterNewName.
  ///
  /// In en, this message translates to:
  /// **'Enter new name'**
  String get enterNewName;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @aboutus.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutus;

  /// No description provided for @meetthedeveloper.
  ///
  /// In en, this message translates to:
  /// **'Meet the developers'**
  String get meetthedeveloper;

  /// No description provided for @lang.
  ///
  /// In en, this message translates to:
  /// **'Eng Soklang'**
  String get lang;

  /// No description provided for @langdecription.
  ///
  /// In en, this message translates to:
  /// **'Logical puzzle'**
  String get langdecription;

  /// No description provided for @sna.
  ///
  /// In en, this message translates to:
  /// **'Thuon MeanVeasna'**
  String get sna;

  /// No description provided for @snadescription.
  ///
  /// In en, this message translates to:
  /// **'Quick calculation'**
  String get snadescription;

  /// No description provided for @liz.
  ///
  /// In en, this message translates to:
  /// **'Khim Phanalis'**
  String get liz;

  /// No description provided for @lizdescription.
  ///
  /// In en, this message translates to:
  /// **'True/False'**
  String get lizdescription;

  /// No description provided for @g1.
  ///
  /// In en, this message translates to:
  /// **'Offline math & puzzle game'**
  String get g1;

  /// No description provided for @g2.
  ///
  /// In en, this message translates to:
  /// **'Focus on thinking, problem-solving, and fun learning'**
  String get g2;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'km'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'km':
      return AppLocalizationsKm();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
