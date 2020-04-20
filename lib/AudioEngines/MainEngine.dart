import 'package:audioplayer/audioplayer.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:umusic/UI/Home.dart';

AudioPlayer audioEngine = AudioPlayer();
var nowplaying;

void play(path) async {
  await audioEngine.stop();
  audioEngine.play(path);
  nowplaying = path;
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

void playpause(possition){
  if (audioEngine.state == AudioPlayerState.PLAYING) {
    audioEngine.pause();
  } else if (audioEngine.state == AudioPlayerState.PAUSED){
    audioEngine.play(nowplaying);
    audioEngine.seek(possition);
  }
}

SongSortType sort(String opt){
  switch (opt) {
    case 'Sort by Name': return SongSortType.DISPLAY_NAME;
      break;
    case 'Sort by Artist': return SongSortType.ALPHABETIC_ARTIST;
      break;
    case 'Sort by Default': return SongSortType.DEFAULT;
  }
}
