import 'package:hive/hive.dart';
import 'package:umusicv2/Classes/Song.dart';

class HiveEngine{
  Box fBox;

  init() async{
    fBox = await Hive.openBox('fBox');
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
}
