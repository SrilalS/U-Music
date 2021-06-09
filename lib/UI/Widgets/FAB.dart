import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';
import 'package:umusicv2/Styles/Styles.dart';
import 'package:umusicv2/UI/Play.dart';

Widget mainFAB(){
  return SizedBox(
    width: Get.width,
    height: 128,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: Get.width,
          height: 116,
          padding: const EdgeInsets.all(16),
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(256)),
          ),
        ),





        Obx((){
          return Container(
            width: Get.width / 2.5,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(currentSong.value.title, overflow: TextOverflow.ellipsis),
                Text(Duration(milliseconds: songPosition.value).toString().split('.')[0]+' | '+Duration(milliseconds: currentSong.value.length).toString().split('.')[0]),
              ],
            ),
          );
        }),

        Container(
          width: Get.width,
          height: 116,
          padding: const EdgeInsets.all(16),
          child: Material(
            borderRadius: BorderRadius.circular(256),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(256),
              onTap: (){
                Get.to(()=>Play());
              },
            ),
          ),
        ),

        Obx((){
          return Positioned(
              right: 24,
              child: Container(
                width: 64,
                height: 64,
                child: ElevatedButton(
                  child: isPlaying.value ? Icon(Icons.pause) : Icon(Icons.play_arrow_rounded),
                  onPressed: (){
                    pEngine.pause();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: mainColor(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(256)
                      )
                  ),
                ),
              ));
        }),
        Positioned(
            left: 0,
            child: Container(
              width: 128,
              height: 128,
              padding: const EdgeInsets.all(32),
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(256)),
                child: Obx((){

                  return FutureBuilder(
                    future: audioQuery.getArtwork(
                      type: ResourceType.SONG,
                      id: currentSong.value.id,
                    ),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.done) {
                        if (snap.data.toString() == '[]'){
                          return ClipOval(
                            child: Image.asset('assets/Art.png', fit: BoxFit.cover),
                          );
                        } else if(snap.data != null){
                          return ClipOval(
                            child: Image.memory(snap.data, fit: BoxFit.cover),
                          );
                        } else {
                          if (currentSong.value.albumArt != null){
                            return ClipRRect(
                              child: Image.file(File(currentSong.value.albumArt), fit: BoxFit.cover),
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
                                      child: Image.asset('assets/Art.png', fit: BoxFit.cover),
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
              ),
            )),
        Obx((){
          return Positioned(
              left: 0,
              child: Container(
                width: 128,
                height: 128,
                padding: const EdgeInsets.all(32),
                child: Card(
                  color: Colors.transparent,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(256)),
                  child: CircularProgressIndicator(
                    value: songPosition.value / currentSong.value.length,

                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(mainColor()),
                  ),
                ),
              ));
        }),
      ],
    ),
  );
}
