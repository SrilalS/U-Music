
import 'dart:convert';



import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Classes/Song.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';
import 'package:umusicv2/ServiceModules/StorageWorker.dart';

class MusicEngine{


  Future<bool> getSongs() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool first = prefs.getBool('First') ?? true;
    if (first){
      print('Getting Music From MediaStore');
      List<SongInfo> songinfo = await audioQuery.getSongs(sortType: SongSortType.DEFAULT);
      songinfo.removeWhere((element) => element.isMusic == false);
      songinfo.removeWhere((element) => element.filePath.contains('sound_recorder'));
      songinfo.removeWhere((element) => int.parse(element.duration) < 30000);
      songs = RxList.generate(songinfo.length, (index)=> Song.name(
          songinfo[index].id,
          songinfo[index].title,
          songinfo[index].album,
          songinfo[index].artist,
          songinfo[index].uri,
          songinfo[index].albumArtwork,
          int.parse(songinfo[index].duration))
      );
      currentSong.value = songs[0];
      saveSongsList(songs);
      return true;
    } else {
      print('Getting Music From Storage');
      var jsonfile = jsonDecode(prefs.getString('Songs'));
      print(jsonfile);
      songs = RxList.generate(jsonfile.length, (index)=> Song.fromJSON(
        jsonfile[index]
      ));
      currentSong.value = songs[0];
      updateSongs();
      return true;
    }
  }

  void updateSongs() async{
    print('Updating Music From MediaStore');
    List<SongInfo> songinfo = await audioQuery.getSongs(sortType: SongSortType.DEFAULT);
    songinfo.removeWhere((element) => element.isMusic == false);
    songinfo.removeWhere((element) => element.filePath.contains('sound_recorder'));

    songs = RxList.generate(songinfo.length, (index)=> Song.name(
        songinfo[index].id,
        songinfo[index].title,
        songinfo[index].album,
        songinfo[index].artist,
        songinfo[index].uri,
        songinfo[index].albumArtwork,
        int.parse(songinfo[index].duration))
    );

    int updatedSongIndex = songs.indexOf(currentSong);
    if (updatedSongIndex > -1){
      currentSong.value = songs[updatedSongIndex];
    }
    saveSongsList(songs);
  }

}
