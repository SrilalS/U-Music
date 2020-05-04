import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';



void saveMusicList(String name , List mList) async{
  SharedPreferences shworker = await SharedPreferences.getInstance();
  await shworker.setString('MusicList', musicPathsList.toString());
}

Future<List> getSaved() async{
  SharedPreferences shworker = await SharedPreferences.getInstance();
  String mListTMP =  await shworker.getString('MusicList');
 List testList = mListTMP.replaceAll('[', '').replaceAll(']', '').split(',');
  testList.forEach((element) {
    File testFile = File(element.trim());
    testFile.exists().then((value) => print(value));
  });
 
  //return mListTMP;
}

