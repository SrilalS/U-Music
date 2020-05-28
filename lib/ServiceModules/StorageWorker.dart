import 'package:shared_preferences/shared_preferences.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';

List playLists = [];
List preProcessedlists = [];

void saveMusicList(String name, List mList) async {
  List tempolist = [];
  mList.forEach((element) {
    tempolist.add(musicList[element]);
  });

  SharedPreferences shworker = await SharedPreferences.getInstance();
  await shworker.setString(name, tempolist.toString());
  String plist = await shworker.getString('PlayLists') ?? '';
  plist = plist + '||' + name;
  await shworker.setString('PlayLists', plist);
}

void getSaved() async {
  playLists.clear();
  preProcessedlists.clear();
  SharedPreferences shworker = await SharedPreferences.getInstance();
  String mListTMP = await shworker.getString('PlayLists') ?? '-999';
  if (mListTMP != '-999') {
    var processor = mListTMP.trim().split('||');
    processor.remove('');
    processor.forEach((element) async {
      playLists.add(element);
      SharedPreferences shworker = await SharedPreferences.getInstance();
      preProcessedlists.add(shworker.getString(element));
      //print(preProcessedlists);
    });
    //print(preProcessedlists);
  }
}
