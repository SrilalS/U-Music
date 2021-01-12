import 'package:get/get.dart';
import 'package:umusicv2/Engine/MusicEngine.dart';
import 'package:umusicv2/Engine/PlayerEngine.dart';

import 'Song.dart';

MusicEngine sEngine = new MusicEngine();
PlayerEngine pEngine = new PlayerEngine();

RxString songName = 'P'.obs;
RxInt songLength = 0.obs;
RxInt songPosition = 0.obs;
RxString songID = '0'.obs;

RxList<Song> songs = [].obs;
