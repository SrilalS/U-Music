import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';

final AssetsAudioPlayer ap = AssetsAudioPlayer();

class PlayerEngine{



  Stream stream;

  PlayerEngine(){
    position();
    getState();
    getPlayerState();
  }

  play(int index) async{

    await ap.pause();
    await ap.open(
        Audio.file(
          songs[index].uri,
          metas: Metas(
            title:  songs[index].title,
            album: songs[index].album,
            image: MetasImage.file(songs[index].albumArt),
          )
        ),
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        showNotification: true,
        //playInBackground: PlayInBackground.enabled,
        notificationSettings: NotificationSettings(
          prevEnabled: true,
          nextEnabled: true,
          seekBarEnabled: true,
          //customNextAction: next(),
          //customPrevAction: back(),
        )
    );
    currentSong.value = songs[index];
    currentIndex.value = index;
    await ap.play();
  }

  stop(){
    ap.stop();
  }

  next(){
    if(currentIndex.value == songs.length-1){
      play(0);
    } else {
      play(currentIndex.value+1);
    }
  }

  back(){
    if(currentIndex.value == 0){

      play(0);
    } else {
      play(currentIndex.value-1);
    }
  }

  pause(){
    if (ap.current.value == null){
      play(0);
    } else {
      ap.playOrPause();
    }
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

  getPlayerState(){
    ap.playerState.distinct().asBroadcastStream().forEach((element) {
      print(element);
      if (element == PlayerState.stop && currentSong.value.uri != 'Loading...'){
        next();
      }
    });
  }
}
