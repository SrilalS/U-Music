import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Classes/Song.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';
import 'package:umusicv2/ServiceModules/StorageWorker.dart';

class MusicEngine{
  Future<bool> getSongs() async{
      print('Getting Music From MediaStore');
      List<SongInfo> songInfo = await audioQuery.getSongs(sortType: SongSortType.DEFAULT);
      songInfo.removeWhere((element) => element.isMusic == false);
      songInfo.removeWhere((element) => element.isBlank == true);
      songInfo.removeWhere((element) => element.isAlarm == true);
      songInfo.removeWhere((element) => element.isNotification == true);
      songInfo.removeWhere((element) => element.isRingtone == true);
      songInfo.removeWhere((element) => element.isPodcast == true);
      songInfo.removeWhere((element) => element.filePath.contains('sound_recorder'));
      songInfo.removeWhere((element) => element.filePath.contains('MIUI'));
      songInfo.removeWhere((element) => int.parse(element.duration) < 30000);
      songInfo.sort((a, b) {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      });
      songInfo.forEach((element) async{
        await hEngine.saveSongToBox(Song.name(
            element.id,
            element.title,
            element.album,
            element.artist,
            element.uri,
            element.albumArtwork,
            int.parse(element.duration)));
      });
      currentSong.value = hEngine.asBox.getAt(0);
      return true;
  }
  void updateSongs() async{
    print('Updating Music From MediaStore');
    List<SongInfo> songinfo = await audioQuery.getSongs(sortType: SongSortType.DEFAULT);
    songinfo.removeWhere((element) => element.isMusic == false);
    songinfo.removeWhere((element) => element.isBlank == true);
    songinfo.removeWhere((element) => element.isAlarm == true);
    songinfo.removeWhere((element) => element.isNotification == true);
    songinfo.removeWhere((element) => element.isRingtone == true);
    songinfo.removeWhere((element) => element.isPodcast == true);
    songinfo.removeWhere((element) => element.filePath.contains('sound_recorder'));
    songinfo.removeWhere((element) => element.filePath.contains('MIUI'));
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

    int updatedSongIndex = songs.indexOf(currentSong);
    if (updatedSongIndex > -1){
      currentSong.value = songs[updatedSongIndex];
    }
    saveSongsList(songs);
  }
}
