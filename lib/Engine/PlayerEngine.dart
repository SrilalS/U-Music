import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';

class PlayerEngine{
  AssetsAudioPlayer ap = new AssetsAudioPlayer();


  Stream stream;

  PlayerEngine(){
    position();
  }

  play(int index) async{

    await ap.stop();
    await ap.open(Audio.file(songs[index].uri));
    await ap.play();
    songName.value = songs[index].title;
    songLength.value = songs[index].length;
  }

  stop(){
    ap.stop();
  }

  pause(){
    ap.playOrPause();
  }

  position(){
    ap.currentPosition.asBroadcastStream().forEach((element) {
      songPosition.value = element.inMilliseconds;
    });
  }
}
