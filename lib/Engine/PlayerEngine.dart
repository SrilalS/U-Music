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

  play(String playList ,Song song, int index) async{

    await ap.pause();
    currentSong.value = song;
    currentIndex.value = index;
    currentPlayList.value = playList;
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

    await ap.play();
  }

  stop(){
    ap.stop();
  }

  next(){
    if(hEngine.pBox.get(currentPlayList.value).last.id == currentSong.value.id){
      play(currentPlayList.value,hEngine.pBox.get(currentPlayList.value)[0],0);
    } else {
      play(currentPlayList.value,hEngine.pBox.get(currentPlayList.value)[currentIndex.value+1],currentIndex.value+1);
    }
  }

  back(){
    if(currentIndex.value == 0){
      play(currentPlayList.value,hEngine.pBox.get(currentPlayList.value)[0],0);
    } else {
      play(currentPlayList.value,hEngine.pBox.get(currentPlayList.value)[currentIndex.value-1],currentIndex.value-1);
    }
  }

  pause(){
    if (ap.current == null){
      play(currentPlayList.value,hEngine.pBox.get(currentPlayList.value)[0],0);
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
      print('PLAYING NEXT SONG FROM' + currentPlayList.value);
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
