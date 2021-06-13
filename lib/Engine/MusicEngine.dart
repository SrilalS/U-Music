import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Classes/Song.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';

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
      await hEngine.asBox.clear();
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
      settingsChanged.value = settingsChanged.value++;
      return true;
  }
}
