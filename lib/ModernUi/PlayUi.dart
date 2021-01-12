import 'dart:ui';

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
      body: currentSong.value.uri == 'Loading...'
          ? Container()
          : Container(
              child: Stack(
                children: [
                  FutureBuilder(
                    future: audioQuery.getArtwork(
                      type: ResourceType.SONG,
                      id: currentSong.value.id,
                    ),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.done) {
                        return Container(
                          height: Get.height - 190,
                          width: Get.width,
                          child: Image.memory(snap.data, fit: BoxFit.fitWidth),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
