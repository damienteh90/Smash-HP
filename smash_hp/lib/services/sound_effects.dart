import 'package:audioplayers/audioplayers.dart';

import 'local_storage_service.dart';

class SoundEffects {
  static void playMiss() => _play('attack_miss.mp3');
  static void playHit() => _play('attack_hit.mp3');
  static void playCritical() => _play('attack_crit.mp3');
  static void playKo() => _play('ko.mp3');

  static Future<void> _play(String fileName) async {
    if (!localStorage.isSoundEnabled()) {
      return;
    }

    final player = AudioPlayer();

    try {
      await player.play(
        AssetSource('sounds/$fileName'),
        mode: PlayerMode.lowLatency,
      );

      Future.delayed(const Duration(seconds: 3), () {
        player.dispose();
      });
    } catch (_) {
      await player.dispose();
    }
  }
}
