import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';
import 'package:umusicv2/Styles/Styles.dart';

class Play extends StatefulWidget {
  const Play({Key key}) : super(key: key);

  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Now Playing'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.width * 0.75,
                height: Get.width * 0.75,
                child: Obx((){

                  return FutureBuilder(
                    future: audioQuery.getArtwork(
                      type: ResourceType.SONG,
                      id: currentSong.value.id,
                    ),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.done) {
                        if (snap.data.toString() == '[]') {
                          return  ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: Get.height,
                              width: Get.width,
                              child: Card(
                                margin: const EdgeInsets.all(0),
                                color: mainColor(),
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Image.asset('assets/Art.png',
                                      fit: BoxFit.contain),
                                ),
                              ),
                            ),
                          );
                        } else if (snap.data != null) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: Get.height,
                              width: Get.width,
                              child:
                              Image.memory(snap.data, fit: BoxFit.cover),
                            ),
                          );
                        } else {
                          if (currentSong.value.albumArt != null) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                  File(currentSong.value.albumArt),
                                  fit: BoxFit.cover),
                            );
                          } else {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                height: Get.height,
                                width: Get.width,
                                child: Card(
                                  margin: const EdgeInsets.all(0),
                                  color: mainColor(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Image.asset('assets/Art.png',
                                        fit: BoxFit.contain),
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<Color>(mainColor()),
                          ),
                        );
                      }
                    },
                  );

                }),
              ),
            ],
          ),

          SizedBox(height: 16),

          Obx((){
            return Container(
              width: Get.width * 0.75,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(currentSong.value.title,style: TextStyle(
                      fontSize: 18
                  ), overflow: TextOverflow.ellipsis),
                  Text(Duration(milliseconds: songPosition.value).toString().split('.')[0]+' | '+Duration(milliseconds: currentSong.value.length).toString().split('.')[0]),
                ],
              ),
            );
          }),

          SizedBox(height: 8),
          Container(
            width: Get.width * 0.8,
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.all(0),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: mainColor(),
                inactiveTrackColor: Colors.grey.shade900,
                trackShape: RectangularSliderTrackShape(),
                trackHeight: 4.0,
                thumbColor: mainColor(),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4.0),
                overlayColor: Colors.red.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
              ),
              child: Obx((){
                return Slider(
                  value: songPosition.value.toDouble() > currentSong.value.length.toDouble() ? 0: songPosition.value.toDouble(),
                  min: 0,
                  inactiveColor: mainColor().withOpacity(0.25),
                  max: currentSong.value.length.toDouble(),
                  onChanged: (value){
                    songPosition.value = value.toInt();
                    pEngine.seek(value.milliseconds);
                  },
                );
              }),
            ),
          ),
          SizedBox(height: 16),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: (){
                pEngine.loopSong();
              },
                  icon: Obx((){
                    return Icon(
                      Icons.loop,
                      color: pEngine.loopMode.value ? mainColor(): Colors.white,
                    );
                  })
              ),

              Container(
                height: 32,
                width: 64,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: mainColor(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(256)
                      )
                  ),
                  child: Icon(Icons.skip_previous_rounded),
                  onPressed: (){
                    pEngine.back();
                  },
                ),
              ),
              Obx((){
                return Container(
                  width: 64,
                  height: 64,
                  child: Hero(
                    tag: 'AlbumArt',
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
                  ),
                );
              }),
              Container(
                height: 32,
                width: 72,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: mainColor(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(256)
                      )
                  ),
                  child: Icon(Icons.skip_next_rounded),
                  onPressed: (){
                    pEngine.next();
                  },
                ),
              ),

              IconButton(
                  onPressed: (){
                    pEngine.mute();
                  },
                  icon: Obx((){
                    return Icon(
                      pEngine.isMute.value ? Icons.volume_off : Icons.volume_up,
                      color: pEngine.isMute.value ? mainColor(): Colors.white,
                    );
                  })
              ),
            ],
          ),
          SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){
                //hEngine.toggleFavorite(currentSong.value);
              }, icon: Icon(Icons.favorite))
            ],
          )

        ],
      ),
    );
  }
}
