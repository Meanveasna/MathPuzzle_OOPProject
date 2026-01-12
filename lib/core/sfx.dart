import 'package:audioplayers/audioplayers.dart';

/// Team sound effects helper.
/// Use anywhere: Sfx.correct(); Sfx.wrong(); etc.
class Sfx {
  static final AudioPlayer _player = AudioPlayer();
  static bool enabled = true;

  /// Call once at app start (main.dart).
  static Future<void> init() async {
    await _player.setReleaseMode(ReleaseMode.stop);
    await _player.setVolume(1.0);
  }

  static Future<void> _play(String fileName) async {
    if (!enabled) return;

    try {
      await _player.stop();
      await _player.play(AssetSource('sfx/$fileName'));
    } catch (_) {
      // If file missing, do nothing (so app doesn't crash).
    }
  }

  static Future<void> correct() => _play('correct.mp3');
  static Future<void> wrong() => _play('wrong.mp3');
  static Future<void> timeUp() => _play('timeup.mp3');
  static Future<void> win() => _play('win.mp3');
  static Future<void> click() => _play('click.mp3');
}
