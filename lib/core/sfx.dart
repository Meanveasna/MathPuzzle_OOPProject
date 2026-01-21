import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sfx {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _bgmPlayer = AudioPlayer();
  static bool enabled = true;
  static double _sfxVolume = 1.0;
  static double _bgmVolume = 1.0; 

  /// Call once at app start (main.dart).
  static Future<void> init() async {
    // Enable playback
    try {
       // Prepare SFX player
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      // Prepare BGM player
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);

      // Load saved settings
      final prefs = await SharedPreferences.getInstance();
      _sfxVolume = prefs.getDouble('soundVolume') ?? 0.5; // Default matches settings_page
      _bgmVolume = prefs.getDouble('musicVolume') ?? 0.5;

      // Set initial volumes
      await _sfxPlayer.setVolume(_sfxVolume);
      await _bgmPlayer.setVolume(_bgmVolume);
    } catch (e) {
      print("Error initializing Sfx: $e");
    }
  }

  static void setSfxVolume(double volume) {
    _sfxVolume = volume;
    _sfxPlayer.setVolume(volume);
  }

  static void setBgmVolume(double volume) {
    _bgmVolume = volume;
    _bgmPlayer.setVolume(volume);
  }

  static Future<void> _playSfx(String fileName) async {
    if (!enabled) return;
    try {
      // For simple single-channel SFX, we can stop the previous sound or just play.
      // Stopping ensures we don't get weird overlaps if using a single player.
      await _sfxPlayer.stop(); 
      await _sfxPlayer.play(AssetSource('sfx/$fileName'));
    } catch (_) {
      // Ignore missing files to prevent crashes
    }
  }

  // --- Wrapper identifiers ---

  // 'click.mp3' is missing, using 'coin.mp3' as a substitute per plan.
  static Future<void> click() => _playSfx('coin.mp3'); 
  static Future<void> playTick() => _playSfx('tick.mp3'); // Added

  static Future<void> correct() => _playSfx('correct.mp3');
  static Future<void> wrong() => _playSfx('wrong.mp3');
  static Future<void> timeUp() => _playSfx('timeup.mp3');
  static Future<void> die() => _playSfx('die.mp3'); // Added
  
  static Future<void> win() => _playSfx('win.mp3'); 
  static Future<void> win2() => _playSfx('win.mp3'); // Added

  static Future<void> playCoinSequence(int count) async {
    for (int i = 0; i < count; i++) {
        await _playSfx('coin.mp3');
        await Future.delayed(Duration(milliseconds: 200));
    }
  }

  static Future<void> stopSfx() async {
    await _sfxPlayer.stop();
  }

  static Future<void> stopGameLoop() async {
      await _sfxPlayer.stop();
  } 

  static String? _currentBgm;

  // --- BGM Methods ---
  static Future<void> playBgm(String fileName) async {
    if (!enabled) return;
    if (_currentBgm == fileName) return; // Don't restart if same song
    
    _currentBgm = fileName;
    try {
      await _bgmPlayer.stop();
      await _bgmPlayer.play(AssetSource('sfx/$fileName'));
    } catch (_) {
       _currentBgm = null;
    }
  }

  static Future<void> stopBgm() async {
    _currentBgm = null;
    await _bgmPlayer.stop();
  }
}
