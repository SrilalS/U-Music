import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Classes/Song.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';

class MusicEngine{
  Future<bool> getSongs() async{
      print('Getting Music From MediaStore');
      List<AudioModel> songInfo = await audioQuery.queryAudios(
        filter: MediaFilter.init(
          type: {
            AudioType.IS_MUSIC: true,
            AudioType.IS_ALARM: false,
            AudioType.IS_NOTIFICATION: false,
            AudioType.IS_RINGTONE: false,
            AudioType.IS_PODCAST: false,
            AudioType.IS_AUDIOBOOK: false,
          }
        )
          
      );
      songInfo.removeWhere((element) => element.isMusic == false);
      songInfo.removeWhere((element) => element.isBlank == true);
      songInfo.removeWhere((element) => element.isAlarm == true);
      songInfo.removeWhere((element) => element.isNotification == true);
      songInfo.removeWhere((element) => element.isRingtone == true);
      songInfo.removeWhere((element) => element.isPodcast == true);
      songInfo.removeWhere((element) => element.duration < 30000);
      songInfo.sort((a, b) {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      });
      await hEngine.pBox.put('AllSongs', List.generate(songInfo.length, (index) async {
          ArtworkModel albumArt = await audioQuery.queryArtwork(songInfo[index].id, ArtworkType.AUDIO);
          return Song.name(
              songInfo[index].id,
              songInfo[index].title,
              songInfo[index].album,
              songInfo[index].artist,
              songInfo[index].uri,
              albumArt.path,
              songInfo[index].duration
          );
      }));
      /**
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
          **/
      currentSong.value = hEngine.pBox.get('AllSongs').first;
      settingsChanged.value = settingsChanged.value++;
      return true;
  }
}
