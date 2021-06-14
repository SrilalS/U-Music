import 'package:hive/hive.dart';
import 'package:umusicv2/Classes/Song.dart';

class HiveEngine{
  Box<Song> fBox;
  Box sBox;

  Box<List> pBox;

  init() async{
    fBox = await Hive.openBox('fBox');
    sBox = await Hive.openBox('sBox');
    pBox = await Hive.openBox('pBox');
  }

  devOPS() async{
    print(pBox.keys);
  }

  saveToPlayList(String playList, Song song) async{
    List temp = pBox.get(playList,defaultValue: []);
    temp.add(song);
    await pBox.put(playList,temp);
  }

  removeFromPlayList(String playList, Song song) async{
    List temp = pBox.get(playList,defaultValue: []);
    temp.removeAt(temp.indexOf(song));
    await pBox.put(playList,temp);
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

  saveBackColor(int colorInt){
    sBox.put('BackColor', colorInt);
  }

  saveBackShadeColor(int colorInt){
    sBox.put('BackShadeColor', colorInt);
  }
}
