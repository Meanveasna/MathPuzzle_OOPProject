// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Math Puzzle';

  @override
  String get mathPuzzlesTitle => 'MATH\nPUZZLES';

  @override
  String get startGame => 'START GAME';

  @override
  String get enterUsername => 'Enter your username';

  @override
  String get profile => 'My Profile';

  @override
  String get saveChanges => 'SAVE CHANGES';

  @override
  String get totalScore => 'Total Score';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get khmer => 'Khmer (ខ្មែរ)';

  @override
  String get audioSettings => 'Audio Settings';

  @override
  String get musicVolume => 'Music Volume';

  @override
  String get soundVolume => 'Sound Volume';

  @override
  String get gameData => 'Game Data';

  @override
  String get resetProgress => 'Reset Progress';

  @override
  String get resetProgressSubtitle => 'Clear all levels and scores';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get chooseAvatar => 'Choose Your Avatar';

  @override
  String get playQuick => 'Quick Calculation';

  @override
  String get playQuickDesc => 'Solve simple math problems quickly.';

  @override
  String get playLogical => 'Logical Puzzle';

  @override
  String get playLogicalDesc => 'Find the missing pattern.';

  @override
  String get playTrueFalse => 'True / False';

  @override
  String get playTrueFalseDesc => 'Decide if the equation is correct.';

  @override
  String get trainBrain => 'Train Your Brain, Improve Your Math Skill';

  @override
  String get scoreboard => 'Scoreboard';

  @override
  String get exit => 'Exit';

  @override
  String get confirmExit => 'Confirm Exit';

  @override
  String get confirmExitContent => 'Are you sure you want to exit the app?';

  @override
  String get selectLevel => 'Select Level';

  @override
  String levelLocked(Object level) {
    return 'Level $level is locked! Complete previous levels first.';
  }

  @override
  String levelLabel(Object level) {
    return 'Level $level';
  }

  @override
  String get nextLevel => 'NEXT LEVEL';

  @override
  String get retry => 'RETRY';

  @override
  String get backToMenu => 'Back to Menu';

  @override
  String get congratulations => 'Congratulations!';

  @override
  String get correctAnswer => 'Correct! 🎉';

  @override
  String get wrongAnswer => 'Wrong answer! Try again.';

  @override
  String get submit => 'Submit';

  @override
  String finalScore(Object score) {
    return 'Final Score: $score';
  }

  @override
  String get replay => 'Replay';

  @override
  String get menu => 'Menu';

  @override
  String get levelPassed => 'Level Passed!';

  @override
  String get levelFailed => 'Level Failed';

  @override
  String correctCountLabel(Object count, Object total) {
    return 'Correct: $count / $total';
  }

  @override
  String get trueButton => 'TRUE';

  @override
  String get falseButton => 'FALSE';

  @override
  String get calculator => 'Calculator';

  @override
  String get clear => 'Clear';

  @override
  String get enterAnswer => 'Enter answer';

  @override
  String get coin => 'Coin';

  @override
  String mathOp(Object a, Object b, Object c, Object shown) {
    return '$a + $b × $c = $shown';
  }

  @override
  String percentOf(Object p, Object base, Object shown) {
    return '$p% of $base = $shown';
  }

  @override
  String square(Object n, Object shown) {
    return '$n² = $shown';
  }

  @override
  String algebraProblem(Object a, Object b, Object result, Object shownX) {
    return 'If ${a}x + $b = $result\nthen x = $shownX';
  }

  @override
  String rectangleAreaProblem(Object l, Object w, Object shown) {
    return 'Rectangle\nL = $l, W = $w\nArea = $shown';
  }

  @override
  String circleAreaProblem(Object r, Object shown) {
    return 'Circle\nr = $r\nArea ≈ $shown';
  }

  @override
  String get formulaAreaCircle => 'Area of circle = π × r²';

  @override
  String get formulaAreaRect => 'Area of rectangle = L + W';

  @override
  String get formulaPerimeterRect => 'Perimeter of rectangle = 2(L + W)';

  @override
  String get formulaAreaTriangle => 'Triangle area = base × height';

  @override
  String get profileSaved => 'Profile Saved!';

  @override
  String get editUsername => 'Edit Username';

  @override
  String get enterNewName => 'Enter new name';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get aboutus => 'About us';

  @override
  String get meetthedeveloper => 'Meet the developers';

  @override
  String get lang => 'Eng Soklang';

  @override
  String get langdecription => 'Logical puzzle';

  @override
  String get sna => 'Thuon MeanVeasna';

  @override
  String get snadescription => 'Quick calculation';

  @override
  String get liz => 'Khim Phanalis';

  @override
  String get lizdescription => 'True/False';

  @override
  String get g1 => 'Offline math & puzzle game';

  @override
  String get g2 => 'Focus on thinking, problem-solving, and fun learning';

  @override
  String get paused => 'Paused';

  @override
  String get resume => 'Resume';

  @override
  String get home => 'Home';
}
