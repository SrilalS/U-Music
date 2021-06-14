import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:umusicv2/Engine/HiveEngine.dart';
import 'package:umusicv2/Engine/MusicEngine.dart';
import 'package:umusicv2/Engine/PlayerEngine.dart';


import 'Song.dart';

MusicEngine sEngine = new MusicEngine();
PlayerEngine pEngine = new PlayerEngine();
HiveEngine hEngine = new HiveEngine();

RxInt settingsChanged = 0.obs;
RxInt songsListChanged = 0.obs;

RxBool isPlaying = false.obs;
RxInt currentIndex = 0.obs;
RxString currentPlayList = 'AllSongs'.obs;
RxInt songPosition = 0.obs;
Rx<Song> currentSong = Song().obs;
RxList<Song> songs = List<Song>.empty().obs;
