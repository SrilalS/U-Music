import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Engine/MusicEngine.dart';
import 'package:umusicv2/Engine/PlayerEngine.dart';
import 'package:umusicv2/ModernUi/SongsListUI.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';


class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {


  void getImage(String songID) async{
    Future frp = audioQuery.getArtwork(
        type: ResourceType.SONG, id: songID
    );
  }

  @override
  void initState() {
    sEngine.getSongs();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: Get.height-128,
            child: SongsListUi(pE: pEngine)
          ),
          Container(
            color: Colors.white,
            height: 128,
            //child: Image.file(File('/storage/emulated/0/Android/data/com.android.providers.media/albumthumbs/1587310922735')),
          )
        ],
      )
    );
  }
}
