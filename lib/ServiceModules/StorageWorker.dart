import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umusicv2/Classes/Song.dart';



void saveSongsList(RxList<Song> songslist) async{
  print('Using Storage');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('Songs', jsonEncode(songslist));
  await prefs.setBool('First', false);
}
