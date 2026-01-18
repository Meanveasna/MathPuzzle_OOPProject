import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sfx {
  /// Player for short sound effects (click, correct, wrong)
  static final AudioPlayer _sfxPlayer = AudioPlayer();

  /// Player for background music (menu, game bg)
  static final AudioPlayer _bgmPlayer = AudioPlayer();

  static bool enabled = true;
  static double musicVolume = 0.5;
  static double sfxVolume = 0.5;

  /// Call once at app start (main.dart)
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    musicVolume = prefs.getDouble('musicVolume') ?? 0.5;
    sfxVolume = prefs.getDouble('soundVolume') ?? 0.5;

    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _sfxPlayer.setVolume(sfxVolume);

    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.setVolume(musicVolume);
  }

  /// ---------- SFX ----------
  static Future<void> _playSfx(String fileName) async {
    if (!enabled || sfxVolume <= 0) return;

    try {
      await _sfxPlayer.stop();
      // Ensure volume is set (in case it was changed)
      await _sfxPlayer.setVolume(sfxVolume); 
      await _sfxPlayer.play(AssetSource('sfx/$fileName'));
    } catch (_) {
      // fail silently
    }
  }

  static Future<void> correct() => _playSfx('correct.mp3');
  static Future<void> wrong() => _playSfx('wrong.mp3');
  static Future<void> timeUp() => _playSfx('timeup.mp3');
  static Future<void> win() => _playSfx('win.mp3'); // Dedicated win sound
  static Future<void> click() => _playSfx('click.mp3');
  
  static Future<void> playCoinSequence(int count) async {
    if (!enabled || count <= 0 || sfxVolume <= 0) return;

    // Play first coin immediately
    await _playSfx('coin.mp3');

    if (count >= 2) {
      await Future.delayed(const Duration(milliseconds: 200)); // 0.1s delay
      await _playSfx('coin.mp3');
    }

    if (count >= 3) {
      await Future.delayed(const Duration(milliseconds: 200)); // 0.1s delay
      await _playSfx('coin.mp3');
    }
  }

  /// ---------- BACKGROUND MUSIC ----------
  static Future<void> playMenuBgm() async {
    if (!enabled || musicVolume <= 0) return;

    try {
      // If already playing the same file, we might not want to restart.
      // But checking state/source is tricky with just audio_players simple usage.
      // For now, we will stop and start to ensure it loops correctly if interrupted.
      // However, if we want to avoid restart on navigation, we should check status?
      // But typically we simply won't CALL this method if we don't want to restart.
      
      await _bgmPlayer.stop();
      await _bgmPlayer.setVolume(musicVolume);
      await _bgmPlayer.play(
        AssetSource('sfx/menu_bg.mp3'),
      );
    } catch (_) {
      // fail silently
    }
  }

  static Future<void> stopBgm() async {
    try {
      await _bgmPlayer.stop();
    } catch (_) {}
  }

  static Future<void> setBgmVolume(double volume) async {
    musicVolume = volume;
    await _bgmPlayer.setVolume(volume);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('musicVolume', volume);
    
    // If volume is 0, maybe pause? if >0 ensure playing?
    // For now, just set volume.
  }

  static Future<void> setSfxVolume(double volume) async {
    sfxVolume = volume;
    await _sfxPlayer.setVolume(volume);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('soundVolume', volume);
  }

  /// ---------- GAME LOOP ----------
  // REPLACED WITH ONE-SHOT TICK
  static Future<void> playTick() => _playSfx('timeup.mp3'); 

  // New Win2 sound
  static Future<void> win2() => _playSfx('win2.mp3');

  // Die/Timeout sound
  static Future<void> die() => _playSfx('die.mp3');

  static Future<void> stopSfx() async {
    try {
      await _sfxPlayer.stop();
    } catch (_) {}
  }

  static Future<void> stopGameLoop() async {
     // Stop game loop and resume menu music
     try {
       await _bgmPlayer.stop();
       // Only play Menu BGM if we explicitly want to restore it via this call
       // But in the new logic, we just stop the tick/loop player context.
       // However, since we used _bgmPlayer for the loop, stopping it stops the loop.
       // Wait, if we use playTick(), it uses _sfxPlayer (fire and forget).
       // So we don't need 'stopGameLoop' to stop sound, but we might need it to RESUME menu BGM?
       // The user wants Level Selection to be SILENT.
       // So let's just make this method ensure BGM is stopped.
     } catch (_) {}
  }
}
