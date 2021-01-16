import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';



class PlayUi extends StatefulWidget {
  @override
  _PlayUiState createState() => _PlayUiState();
}

class _PlayUiState extends State<PlayUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: currentSong.value.uri == 'Loading...'
          ? Container()
          : Obx((){
            return Container(
              child: Stack(
                children: [

                  FutureBuilder(
                    future: audioQuery.getArtwork(
                      type: ResourceType.SONG,
                      id: currentSong.value.id,
                    ),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.done) {
                        if (snap.data.toString() == '[]'){
                          return ClipRRect(
                            child: Container(
                              height: Get.height - 190,
                              width: Get.width,
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10,
                                        sigmaY: 10
                                    ),
                                    child: Container(
                                      width: Get.width*0.8,
                                      height: Get.width*0.8,
                                      child: Image.asset('assets/Art.png', fit: BoxFit.fitWidth),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else if (snap.data != null) {
                          return ClipRRect(
                            child: Container(
                              height: Get.height - 190,
                              width: Get.width,
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10,
                                        sigmaY: 10
                                    ),
                                    child: Container(
                                      width: Get.width*0.8,
                                      height: Get.width*0.8,
                                      child: Image.memory(snap.data, fit: BoxFit.cover),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          if (currentSong.value.albumArt != null){
                            return ClipRRect(
                              child: Container(
                                height: Get.height - 190,
                                width: Get.width,
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10,
                                          sigmaY: 10
                                      ),
                                      child: Container(
                                        width: Get.width*0.8,
                                        height: Get.width*0.8,
                                        child: Image.file(File(currentSong.value.albumArt), fit: BoxFit.cover),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return ClipRRect(
                              child: Container(
                                height: Get.height - 190,
                                width: Get.width,
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10,
                                          sigmaY: 10
                                      ),
                                      child: Container(
                                        width: Get.width*0.8,
                                        height: Get.width*0.8,
                                        child: Image.asset('assets/Art.png', fit: BoxFit.fitWidth),
                                      ),
                                    )
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
                  ),
                ],
              ),
            );
      })
    );
  }
}
