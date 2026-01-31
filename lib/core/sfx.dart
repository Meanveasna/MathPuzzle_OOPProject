import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sfx {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _bgmPlayer = AudioPlayer();

  static bool enabled = true;
  static double musicVolume = 0.5;
  static double sfxVolume = 0.5;

  static bool _bgmPlaying = false;
  static bool _bgmPausedBySystem = false;

static AudioPlayer? _gamePlayer;
static String? _currentGame;

  static void enterGame(String gameId) {
    _currentGame = gameId;
    _gamePlayer ??= AudioPlayer();
  }

  static void leaveGame(String gameId) {
    if (_currentGame == gameId) {
      _gamePlayer?.stop();
      _sfxPlayer.stop(); // Stop any pending SFX when leaving game
      _currentGame = null;
    }
  }

  static void pauseGameOnly() {
    _gamePlayer?.pause();
  }

  static void resumeGameOnly() {
    _gamePlayer?.resume();
  }

  static void stopGameOnly() {
    _gamePlayer?.stop();
  }


  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    musicVolume = prefs.getDouble('musicVolume') ?? 0.5;
    sfxVolume = prefs.getDouble('soundVolume') ?? 0.5;

    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _sfxPlayer.setVolume(sfxVolume);

    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.setVolume(musicVolume);
  }

  static Future<void> _playSfx(String fileName) async {
    if (!enabled || sfxVolume <= 0) return;

    try {
      await _sfxPlayer.stop(); // Cut previous SFX
      await _sfxPlayer.setVolume(sfxVolume);
      await _sfxPlayer.play(AssetSource('sfx/$fileName'));
    } catch (_) {}
  }

  static Future<void> correct() => _playSfx('correct.mp3');
  static Future<void> wrong() => _playSfx('wrong.mp3');
  static Future<void> timeUp() => _playSfx('timeup.mp3');
  static Future<void> win() => _playSfx('win.mp3');
  static Future<void> playTick() => _playSfx('timeup.mp3');
  static Future<void> win2() => _playSfx('win2.mp3');
  static Future<void> die() => _playSfx('die.mp3');

  static Future<void> playCoinSequence(int count) async {
    if (!enabled || count <= 0 || sfxVolume <= 0) return;

    await _playSfx('coin.mp3');

    if (count >= 2) {
      await Future.delayed(const Duration(milliseconds: 200));
      await _playSfx('coin.mp3');
    }

    if (count >= 3) {
      await Future.delayed(const Duration(milliseconds: 200));
      await _playSfx('coin.mp3');
    }
  }

  static Future<void> playMenuBgm() async {
    if (!enabled || musicVolume <= 0) return;
    if (_bgmPlaying) return; 

    try {
      _bgmPlaying = true;
      _bgmPausedBySystem = false;

      await _bgmPlayer.stop();
      await _bgmPlayer.setVolume(musicVolume);
      await _bgmPlayer.play(AssetSource('sfx/menu_bg.mp3'));
    } catch (_) {}
  }

  static Future<void> stopBgm() async {
    if (!_bgmPlaying) return;

    try {
      _bgmPlaying = false;
      await _bgmPlayer.stop();
    } catch (_) {}
  }

  // --- LIFECYCLE HANDLERS ---
  
  // Called when app goes background
  static Future<void> pauseAll() async {
    try {
      if (_bgmPlaying) {
        _bgmPausedBySystem = true;
        await _bgmPlayer.pause();
      }
      // Stop short SFX so they don't resume out of context on return
      await _sfxPlayer.stop();
      await _gamePlayer?.pause(); 
    } catch (_) {}
  }

  // Called when app resumes
  static Future<void> resumeBgmOnly() async {
    try {
      // Only resume BGM, do NOT auto-resume SFX (user must trigger game action)
      if (enabled && musicVolume > 0 && _bgmPlaying && _bgmPausedBySystem) {
        _bgmPausedBySystem = false;
        await _bgmPlayer.resume();
      }
    } catch (_) {}
  }

  // Deprecated wrappers for compatibility if needed
  static Future<void> pauseBgmBySystem() async => pauseAll();
  static Future<void> resumeBgmBySystem() async => resumeBgmOnly();
  static Future<void> pauseSfxBySystem() async => pauseAll(); // Safe fallback
  static Future<void> resumeSfxBySystem() async {} // Do nothing on resume SFX globally

  static bool get isBgmPlaying => _bgmPlaying;

  // SETTINGS
  static Future<void> setBgmVolume(double volume) async {
    musicVolume = volume;
    await _bgmPlayer.setVolume(volume);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('musicVolume', volume);
  }

  static Future<void> setSfxVolume(double volume) async {
    sfxVolume = volume;
    await _sfxPlayer.setVolume(volume);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('soundVolume', volume);
  }

  static Future<void> stopSfx() async {
    try {
      await _sfxPlayer.stop();
    } catch (_) {}
  }
  
}
