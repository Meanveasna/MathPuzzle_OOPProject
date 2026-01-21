// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Khmer Central Khmer (`km`).
class AppLocalizationsKm extends AppLocalizations {
  AppLocalizationsKm([String locale = 'km']) : super(locale);

  @override
  String get appTitle => 'ល្បែងគណិតវិទ្យា';

  @override
  String get mathPuzzlesTitle => 'ល្បែង\nគណិតវិទ្យា';

  @override
  String get startGame => 'ចាប់ផ្តើមលេង';

  @override
  String get enterUsername => 'បញ្ចូលឈ្មោះអ្នកប្រើ';

  @override
  String get profile => 'ប្រវត្តិរូប';

  @override
  String get saveChanges => 'រក្សាទុកការផ្លាស់ប្តូរ';

  @override
  String get totalScore => 'ពិន្ទុសរុប';

  @override
  String get settings => 'ការកំណត់';

  @override
  String get language => 'ភាសា';

  @override
  String get english => 'អង់គ្លេស';

  @override
  String get khmer => 'ខ្មែរ';

  @override
  String get audioSettings => 'ការកំណត់សំឡេង';

  @override
  String get musicVolume => 'កម្រិតតន្ត្រី';

  @override
  String get soundVolume => 'កម្រិតសំឡេង';

  @override
  String get gameData => 'ទិន្នន័យហ្គេម';

  @override
  String get resetProgress => 'កំណត់ឡើងវិញ';

  @override
  String get resetProgressSubtitle => 'លុបកម្រិតនិងពិន្ទុទាំងអស់';

  @override
  String get yes => 'បាទ/ចាស';

  @override
  String get no => 'ទេ';

  @override
  String get chooseAvatar => 'ជ្រើសរើសតួអង្គរបស់អ្នក';

  @override
  String get playQuick => 'គណិតរហ័ស';

  @override
  String get playQuickDesc => 'ដោះស្រាយលំហាត់គណិតងាយៗឱ្យបានរហ័ស';

  @override
  String get playLogical => 'ល្បែងតក្កវិទ្យា';

  @override
  String get playLogicalDesc => 'ស្វែងរកលំនាំដែលបាត់';

  @override
  String get playTrueFalse => 'ពិត / មិនពិត';

  @override
  String get playTrueFalseDesc => 'សម្រេចចិត្តថាតើសមីការត្រឹមត្រូវឬអត់';

  @override
  String get trainBrain => 'បង្វឹកខួរក្បាលរបស់អ្នក បង្កើនជំនាញគណិតវិទ្យា';

  @override
  String get scoreboard => 'តារាងពិន្ទុ';

  @override
  String get exit => 'ចាកចេញ';

  @override
  String get confirmExit => 'បញ្ជាក់ការចាកចេញ';

  @override
  String get confirmExitContent => 'តើអ្នកពិតជាចង់ចាកចេញមែនទេ?';

  @override
  String get selectLevel => 'ជ្រើសរើសកម្រិត';

  @override
  String levelLocked(Object level) {
    return 'កម្រិត $level ត្រូវបានជាប់សោ! សូមបញ្ចប់កម្រិតមុនៗសិន។';
  }

  @override
  String levelLabel(Object level) {
    return 'កម្រិត $level';
  }

  @override
  String get nextLevel => 'កម្រិតបន្ទាប់';

  @override
  String get retry => 'ព្យាយាមម្តងទៀត';

  @override
  String get backToMenu => 'ត្រឡប់ទៅម៉ឺនុយ';

  @override
  String get congratulations => 'អបអរសាទរ!';

  @override
  String get correctAnswer => 'ត្រឹមត្រូវ! 🎉';

  @override
  String get wrongAnswer => 'ចម្លើយខុស! ព្យាយាមម្តងទៀត។';

  @override
  String get submit => 'ដាក់បញ្ចូន';

  @override
  String finalScore(Object score) {
    return 'ពិន្ទុចុងក្រោយ: $score';
  }

  @override
  String get replay => 'លេងម្តងទៀត';

  @override
  String get menu => 'ម៉ឺនុយ';

  @override
  String get levelPassed => 'ឆ្លងកាត់កម្រិត!';

  @override
  String get levelFailed => 'បរាជ័យកម្រិត';

  @override
  String correctCountLabel(Object count, Object total) {
    return 'ត្រឹមត្រូវ: $count / $total';
  }

  @override
  String get trueButton => 'ពិត';

  @override
  String get falseButton => 'មិនពិត';

  @override
  String get calculator => 'គណិតរហ័ស';

  @override
  String get clear => 'សម្អាត';

  @override
  String get enterAnswer => 'បញ្ចូលចម្លើយ';

  @override
  String get coin => 'កាក់';

  @override
  String mathOp(Object a, Object b, Object c, Object shown) {
    return '$a + $b × $c = $shown';
  }

  @override
  String percentOf(Object p, Object base, Object shown) {
    return '$p% នៃ $base = $shown';
  }

  @override
  String square(Object n, Object shown) {
    return '$n² = $shown';
  }

  @override
  String algebraProblem(Object a, Object b, Object result, Object shownX) {
    return 'បើ ${a}x + $b = $result\nនោះ x = $shownX';
  }

  @override
  String rectangleAreaProblem(Object l, Object w, Object shown) {
    return 'ចតុកោណកែង\nបណ្តោយ = $l, ទទឹង = $w\nផ្ទៃក្រឡា = $shown';
  }

  @override
  String circleAreaProblem(Object r, Object shown) {
    return 'រង្វង់\nកាំ(r) = $r\nផ្ទៃក្រឡា ≈ $shown';
  }

  @override
  String get formulaAreaCircle => 'ផ្ទៃរង្វង់ = π × r²';

  @override
  String get formulaAreaRect => 'ផ្ទៃចតុកោណកែង = បណ្តោយ + ទទឹង';

  @override
  String get formulaPerimeterRect => 'បរិមាត្រចតុកោណកែង = 2(បណ្តោយ + ទទឹង)';

  @override
  String get formulaAreaTriangle => 'ផ្ទៃត្រីកោណ = បាត × កម្ពស់';

  @override
  String get profileSaved => 'បានរក្សាទុកប្រវត្តិរូប!';

  @override
  String get editUsername => 'កែឈ្មោះអ្នកប្រើ';

  @override
  String get enterNewName => 'បញ្ចូលឈ្មោះថ្មី';

  @override
  String get cancel => 'បោះបង់';

  @override
  String get save => 'រក្សាទុក';
}
