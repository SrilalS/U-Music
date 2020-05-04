import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';



void saveMusicList(String name , List mList) async{
  List tempolist = [];
  mList.forEach((element) {
    tempolist.add(musicList[element]);
  });

  SharedPreferences shworker = await SharedPreferences.getInstance();
  await shworker.setString('MusicList', tempolist.toString());
}

Future<List> getSaved() async{
  SharedPreferences shworker = await SharedPreferences.getInstance();
  String mListTMP =  await shworker.getString('MusicList');
  print(mListTMP);
 
  //return mListTMP;
}

