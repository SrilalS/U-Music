import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Classes/Song.dart';

final AssetsAudioPlayer ap = AssetsAudioPlayer();

class PlayerEngine{

  RxBool loopMode = false.obs;
  RxBool isMute = false.obs;

  Stream stream;

  PlayerEngine(){
    position();
    getState();
    getPlayerState();
  }

  play(Song song, int index) async{

    await ap.pause();
    await ap.open(
        Audio.file(
          song.uri,
          metas: Metas(
            title:  song.title,
            album: song.album,
            image: MetasImage.file(song.albumArt),
          )
        ),
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        showNotification: true,
        //playInBackground: PlayInBackground.enabled,
        notificationSettings: NotificationSettings(
          prevEnabled: true,
          nextEnabled: true,
          seekBarEnabled: true,
          customStopAction: (apx){
            stop();
          },
          customPlayPauseAction: (apx){
            pause();
          },
          customNextAction: (apx){
            next();
          },
          customPrevAction: (apx){
            back();
          },
        )
    );
    currentSong.value = song;
    currentIndex.value = index;
    await ap.play();
  }

  stop(){
    ap.stop();
  }

  next(){
    if(currentIndex.value == hEngine.asBox.length-1){
      play(hEngine.asBox.getAt(0),0);
    } else {
      play(hEngine.asBox.getAt(currentIndex.value+1),currentIndex.value+1);
    }
  }

  back(){
    if(currentIndex.value == 0){
      play(hEngine.asBox.getAt(0),0);
    } else {
      play(hEngine.asBox.getAt(currentIndex.value-1),currentIndex.value-1);
    }
  }

  pause(){
    if (ap.current == null){
      play(hEngine.asBox.getAt(0),0);
    } else {
      ap.playOrPause();
    }
  }

  loopSong(){
    ap.toggleLoop();
    loopMode.value = !loopMode.value;
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

  mute(){
    if(isMute.value == true){
      ap.setVolume(1);
    } else {
      ap.setVolume(0);
    }
    isMute.value = !isMute.value;
  }
}
