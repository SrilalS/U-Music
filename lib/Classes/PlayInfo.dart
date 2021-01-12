import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:umusicv2/Engine/MusicEngine.dart';
import 'package:umusicv2/Engine/PlayerEngine.dart';

import 'Song.dart';

MusicEngine sEngine = new MusicEngine();
PlayerEngine pEngine = new PlayerEngine();

RxBool isPlaying = false.obs;
RxInt songPosition = 0.obs;
Rx<Song> currentSong = Song().obs;
RxList<Song> songs = List<Song>.empty().obs;
