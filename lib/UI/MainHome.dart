import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Engine/MusicEngine.dart';
import 'package:umusicv2/Engine/PlayerEngine.dart';
import 'package:umusicv2/ModernUi/LyricUi.dart';
import 'package:umusicv2/ModernUi/PlayUi.dart';
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

  RxInt page = 0.obs;

  void stateSetter(){
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    sEngine.getSongs().then((value) => stateSetter());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async{
          if(isPlaying.value){
            MoveToBackground.moveTaskToBack();
            return false;
          } else {
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return true;
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Obx((){

              return FutureBuilder(
                future: audioQuery.getArtwork(
                  type: ResourceType.SONG,
                  id: currentSong.value.id,
                ),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.done) {
                    if (snap.data.toString() == '[]'){
                      return ClipRRect(
                        child: Container(
                          height: Get.height,
                          width: Get.width,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                height: Get.height,
                                width: Get.width,
                                child: Image.asset('assets/MainArt.png', fit: BoxFit.cover),
                              ),
                              Container(
                                height: Get.height,
                                width: Get.width,
                                color: Colors.grey.shade800.withOpacity(0.6),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if(snap.data != null){
                      return ClipRRect(
                        child: Container(
                          height: Get.height,
                          width: Get.width,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                height: Get.height,
                                width: Get.width,
                                child: Image.memory(snap.data, fit: BoxFit.cover),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      if (currentSong.value.albumArt != null){
                        return ClipRRect(
                          child: Container(
                            height: Get.height,
                            width: Get.width,
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  height: Get.height,
                                  width: Get.width,
                                  child: Image.file(File(currentSong.value.albumArt), fit: BoxFit.cover),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return ClipRRect(
                          child: Container(
                            height: Get.height,
                            width: Get.width,
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  height: Get.height,
                                  width: Get.width,
                                  child: Image.asset('assets/MainArt.png', fit: BoxFit.cover),
                                ),
                                Container(
                                  height: Get.height,
                                  width: Get.width,
                                  color: Colors.grey.shade800.withOpacity(0.6),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }

                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );

            }),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10
                ),
                child: Column(
                  children: [
                    Container(
                        height: Get.height-200,
                        child: PageView(
                          onPageChanged: (val){
                            page.value = val;
                          },
                          children: [
                            SongsListUi(pE: pEngine),
                            PlayUi(),
                            LyricsUI(),
                          ],
                        )
                    ),
                    Obx((){
                      return Container(
                        padding: EdgeInsets.only(left: 16,right: 16,top: 8),
                        color: Colors.black54.withOpacity(0.75),
                        height: 200,
                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 16,
                                  width: 16,
                                  child: Card(color: page.value == 0 ? Colors.white:Colors.white.withOpacity(0.4)),
                                ),
                                Container(
                                  height: 16,
                                  width: 16,
                                  child: Card(color: page.value == 1 ? Colors.white:Colors.white.withOpacity(0.4)),
                                ),
                                Container(
                                  height: 16,
                                  width: 16,
                                  child: Card(color: page.value == 2 ? Colors.white:Colors.white.withOpacity(0.4)),
                                )
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Container(
                                    child: Text(currentSong.value.title, maxLines: 1,),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(Duration(milliseconds: songPosition.value).toString().split('.')[0]),
                                Text(' | '),
                                Text(Duration(milliseconds: currentSong.value.length).toString().split('.')[0])
                              ],
                            ),
                            Slider(
                              value: songPosition.value.toDouble() > currentSong.value.length.toDouble() ? 0: songPosition.value.toDouble(),
                              min: 0,
                              max: currentSong.value.length.toDouble(),
                              onChanged: (value){
                                songPosition.value = value.toInt();
                                pEngine.seek(value.milliseconds);
                              },
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 32,
                                  width: 64,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2048)
                                    ),
                                    child: Icon(Icons.skip_previous_rounded),
                                    onPressed: (){
                                      pEngine.back();
                                    },
                                  ),
                                ),
                                Container(
                                  height: 64,
                                  width: 64,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2048)
                                    ),
                                    child: isPlaying.value ? Icon(Icons.pause) : Icon(Icons.play_arrow_rounded),
                                    onPressed: (){
                                      pEngine.pause();
                                    },
                                  ),
                                ),
                                Container(
                                  height: 32,
                                  width: 72,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2048)
                                    ),
                                    child: Icon(Icons.skip_next_rounded),
                                    onPressed: (){
                                      pEngine.next();
                                    },
                                  ),
                                )
                              ],
                            )

                          ],
                        ),
                      );
                    })
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
