import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:umusicv2/Classes/Song.dart';

class HiveEngine{
  Box<Song> fBox;
  Box sBox;
  Box<Song> asBox;

  init() async{
    fBox = await Hive.openBox('fBox');
    sBox = await Hive.openBox('sBox');
    asBox = await Hive.openBox('asBox');
  }

  saveSongToBox(Song song) async{
    await asBox.put(song.id, song);
  }

  toggleFavorite(Song song){
    print('INIT');
    if(fBox.get(song.id) == null){
      print('HAVE');
      fBox.put(song.id, song);
    } else {
      print('HAVE NOT');
      fBox.delete(song.id);
    }
  }

  saveThemeColor(int colorInt){
    sBox.put('ThemeColor', colorInt);
  }
}
