
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Classes/Song.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';

class MusicEngine{


  Future<bool> getSongs() async{
    List<SongInfo> songinfo = await audioQuery.getSongs(sortType: SongSortType.DEFAULT);
    print(songinfo[150].toString());
    songinfo.removeWhere((element) => element.isMusic == false);
    songinfo.removeWhere((element) => element.filePath.contains('sound_recorder'));
    print(songinfo[11].toString());
    songs = RxList.generate(songinfo.length, (index)=> Song.name(
        songinfo[index].id,
        songinfo[index].title,
        songinfo[index].album,
        songinfo[index].artist,
        songinfo[index].uri,
        songinfo[index].albumArtwork,
        int.parse(songinfo[index].duration))
    );
    print(songs.length);
    localStorage();
    return true;
  }

  Future<String> localStorage() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
