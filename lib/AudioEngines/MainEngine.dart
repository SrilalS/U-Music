import 'package:audioplayer/audioplayer.dart';

AudioPlayer audioEngine = AudioPlayer();

void play(path) async {
  await audioEngine.stop();
  audioEngine.play(path);
}

void pause() {
  audioEngine.pause();
}

void stop() {
  audioEngine.stop();
}

void seeker(val) {
  if (audioEngine.state == AudioPlayerState.PLAYING) {
    var len = audioEngine.duration.inSeconds;
    var x = len * val;
    audioEngine.seek(x);
  }
}
