import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/ServiceModules/NewEngine.dart';

class PlayerEngine{
  AssetsAudioPlayer ap = new AssetsAudioPlayer();


  Stream stream;

  PlayerEngine(){
    position();
    getState();
    getPlayerState();
  }

  play(int index) async{
    await ap.stop();
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
        notificationSettings: NotificationSettings(
          prevEnabled: true,
          nextEnabled: true,
          seekBarEnabled: true,
        )
    );
    currentSong.value = songs[index];
    currentIndex.value = index;
    await ap.play();
  }

  onfinished(){

  }

  stop(){
    ap.stop();
  }

  next(){
    if(currentIndex.value == songsList.length){
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
    ap.playOrPause();
    if (currentSong.value.uri == 'Loading...'){
      play(0);
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

  }
}
