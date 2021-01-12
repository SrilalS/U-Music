import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';

class PlayerEngine{
  AssetsAudioPlayer ap = new AssetsAudioPlayer();


  Stream stream;

  PlayerEngine(){
    position();
    getState();
  }

  play(int index) async{
    await ap.stop();
    await ap.open(
        Audio.file(
          songs[index].uri,

          metas: Metas(
            title:  songs[index].title,
            //artist: songs[index].album,
            album: songs[index].album,
            image: MetasImage.file(songs[index].albumArt),
          )
        ),
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        showNotification: true,
        notificationSettings: NotificationSettings(
          prevEnabled: true,
          nextEnabled: true,
          seekBarEnabled: true,
        )
    );
    currentSong.value = songs[index];
    await ap.play();
  }

  stop(){
    ap.stop();
  }

  pause(){
    ap.playOrPause();
  }

  seek(Duration seekpoint){
    ap.seek(seekpoint);
  }

  position(){
    ap.currentPosition.asBroadcastStream().forEach((element) {
      songPosition.value = element.inMilliseconds;
    });
  }

  getState(){
    ap.isPlaying.asBroadcastStream().forEach((element) {
      isPlaying.value = element;
    });
  }
}
