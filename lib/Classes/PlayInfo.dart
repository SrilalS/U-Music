import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:umusicv2/Engine/FavoritesEngine.dart';
import 'package:umusicv2/Engine/HiveEngine.dart';
import 'package:umusicv2/Engine/MusicEngine.dart';
import 'package:umusicv2/Engine/PlayerEngine.dart';


import 'Song.dart';

MusicEngine sEngine = new MusicEngine();
PlayerEngine pEngine = new PlayerEngine();
FavoritesEngine fEngine = new FavoritesEngine();
HiveEngine hEngine = new HiveEngine();


RxBool isPlaying = false.obs;
RxString currentIndex = '0'.obs;
RxInt songPosition = 0.obs;
Rx<Song> currentSong = Song().obs;
RxList<Song> songs = List<Song>.empty().obs;
