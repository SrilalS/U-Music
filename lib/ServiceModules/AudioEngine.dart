import 'dart:async';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umusicv2/ServiceModules/Notifications.dart';

final AudioPlayer audioPlayer = AudioPlayer();
final FlutterAudioQuery audioQuery = FlutterAudioQuery();

int nowPlayingSongIndex = 0;
void setnowPlayingSongIndex(int data) {
  nowPlayingSongIndex = data;
}

int nowPossition = 0;
void setnowPossition(int data) {
  nowPossition = data;
}

double progress = 0.0;
void setProgress() {
  progress = nowPossition / audioPlayer.duration.inMilliseconds;
  progress = ((progress.isNaN) || (progress.isInfinite) || (progress > 1))
      ? 0
      : progress;
  //shownotification(musicList[nowPlayingSongIndex].title, timeEngine(nowPossition)+' | '+timeEngine(audioPlayer.duration.inMilliseconds));
}

List<String> musicList = [];
List musicPathsList = [];
List musicAlbemArtsList = [];
List musicartistNameList = [];

List bmusicList = [];
List bmusicPathsList = [];
List bmusicAlbemArtsList = [];
List bmusicartistNameList = [];

List musicTitles = [];
List musicArtists = [];

Future<bool> getMusicList(bool needtoupdate) async {
  SharedPreferences mdriver = await SharedPreferences.getInstance();
  musicList.clear();
  musicPathsList.clear();

  bmusicList.clear();
  bmusicPathsList.clear();

  musicTitles.clear();
  musicArtists.clear();

  List<String> listStrings = [];

  if (needtoupdate) {
    print("Scanning...");
    var musicListS = await audioQuery.getSongs();
    bmusicList = musicListS;

    musicListS.forEach((element) {
      listStrings.add(element.toString());
    });

    await mdriver.setStringList('MLIST', listStrings);

    mdriver.setBool("ITFR", false);
     print("Scanning...");
  } else {
    print("Did not Scan");
  }


  musicList = mdriver.getStringList("MLIST");

  print(musicList[0]);

  musicList.forEach((song) {
    musicPathsList
        .add(song.toString().split('_data:').last.split(',').first.trim());
    musicAlbemArtsList.add(
        song.toString().split('album_artwork:').last.split(',').first.trim());
    musicTitles.add(
        song.toString().split('title:').last.split(',').first.trim());
    musicArtists.add(
        song.toString().split('artist:').last.split(',').first.trim());
        
    bmusicPathsList = musicPathsList;
    bmusicAlbemArtsList = musicAlbemArtsList;
  });
  return true;
}

Stream audioplayerstatestream() {
  return audioPlayer.onPlayerStateChanged.asBroadcastStream();
}

Stream audioplayerpositionstream() {
  return audioPlayer.onAudioPositionChanged.asBroadcastStream();
}

String timeEngine(int inMilliseconds) {
  var min = Duration(milliseconds: inMilliseconds);
  var timeslices = min.toString().split('.').first.split(':');
  var time = (timeslices[1].toString() + ':' + timeslices[2].toString());

  return time;
}

void play(int songindex) async {
  await audioPlayer.stop();
  nowPlayingSongIndex = songindex;
  audioPlayer.play(musicPathsList[songindex]);
}

void seek(double seconds) {
  seconds = seconds * audioPlayer.duration.inSeconds;
  audioPlayer.seek(double.parse(seconds.toString()));
}

void playpause(int possition) {
  double playpauseposition =
      double.parse(Duration(milliseconds: possition).inSeconds.toString());

  if (audioPlayer.state == AudioPlayerState.PLAYING) {
    audioPlayer.pause();
  } else if (audioPlayer.state == AudioPlayerState.PAUSED) {
    audioPlayer.play(musicPathsList[nowPlayingSongIndex]);
    audioPlayer.seek(playpauseposition);
  } else if (audioPlayer.state == AudioPlayerState.STOPPED) {
    audioPlayer.play(musicPathsList[nowPlayingSongIndex]);
  } else if (audioPlayer.state == AudioPlayerState.COMPLETED) {
    audioPlayer.play(musicPathsList[nowPlayingSongIndex]);
  }
}

void listener() {
  audioPlayer.onAudioPositionChanged.listen((event) {
    shownotification(
        musicTitles[nowPlayingSongIndex],
        
        timeEngine(event.inMilliseconds) +
            ' | ' +
            timeEngine(audioPlayer.duration.inMilliseconds));
  }).onError((e) {
    print(e);
  });
}

void dullfunction() {}
