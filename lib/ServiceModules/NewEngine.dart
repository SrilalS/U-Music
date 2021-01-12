import 'dart:typed_data';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';

final AssetsAudioPlayer player = AssetsAudioPlayer();
final FlutterAudioQuery query = FlutterAudioQuery();
final PlayController pc = Get.put(PlayController());

int nowPlayingIndex = 0;

List<SongInfo> songsList = [];

Future getSongs() async {
  songsList = await query.getSongs();
}

void broadcast() {
  Stream playerStream = player.currentPosition.asBroadcastStream();

  playerStream.listen((event) {
    pc.changeTime(event.inMilliseconds);
    double preprogress = event.inMilliseconds /
        player.current.value.audio.duration.inMilliseconds;
    pc.changeProgress(preprogress);
  });
}

void play({int indexofSong}) async{

  

  print(songsList[0].albumArtwork);

  

  if (indexofSong != null) {
    nowPlayingIndex = indexofSong;
    player.open(Audio.file(songsList[indexofSong].uri));
    pc.changeName(songsList[indexofSong].displayName);
    player.play();
    pc.changePlayState(true);
  } else {
    if (player.isPlaying.value) {
      pc.changePlayState(false);
      player.pause();
    } else if (player.current.value != null) {
      player.play();
      pc.changePlayState(true);
    } else if (player.current.value == null && indexofSong != null) {
      nowPlayingIndex = indexofSong;
      
      player.open(Audio.file(songsList[indexofSong].uri));
      pc.changeName(songsList[indexofSong].displayName);
      player.play();
      pc.changePlayState(true);
    } else {
      nowPlayingIndex = 0;
      //albumArt = await query.getArtwork(type: ResourceType.SONG, id: songsList[0].id);
      player.open(Audio.file(songsList[0].uri));
      player.play();
      pc.changePlayState(true);
    }
  }
}

void pause() {
  player.pause();
}

void seek(double seekpoint) {
  int seeken =
      (player.current.value.audio.duration.inMilliseconds * seekpoint).floor();
  player.seek(Duration(milliseconds: seeken));
}

String timeEngine(int inMilliseconds) {
  var min = Duration(milliseconds: inMilliseconds);
  var timeslices = min.toString().split('.').first.split(':');
  var time = (timeslices[1].toString() + ':' + timeslices[2].toString());
  return time;
}

class PlayController extends GetxController {
  RxBool isPlaying = false.obs;
  RxInt timeinmils = 0.obs;
  RxDouble progress = 0.0.obs;
  RxString name = "Play a Song...".obs;
  changePlayState(bool val) => isPlaying.value = val;
  changeTime(int time) => timeinmils.value = time;
  changeProgress(double prog) => progress.value = prog;
  changeName(String songname) => name.value = songname;
}
