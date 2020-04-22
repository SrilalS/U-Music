import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umusicv2/ServiceModules/AESupport.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';
import 'package:umusicv2/Styles/Styles.dart';
import 'package:umusicv2/Widgets/MusicListView.dart';

class PlayUi extends StatefulWidget {
  @override
  _PlayUiState createState() => _PlayUiState();
}

class _PlayUiState extends State<PlayUi> {
  Timer timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent));

    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;
    return StreamBuilder(
        stream: audioplayerstatestream(),
        builder: (context, state) {

          if (state.data == AudioPlayerState.COMPLETED){
            autonext();
          }
          
          if (musicList.isEmpty) {
            timer = Timer.periodic(Duration(milliseconds: 50), (dt) {
              if (musicList.isNotEmpty) {
                setState(() {
                  timer.cancel();
                  print('Getting Music is Complete');
                });
              }
            });
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                ),
              ),
            );
          }

          return StreamBuilder(
            stream: audioplayerpositionstream(),
            builder: (context, possition) {
              int milliseconds;

              if (possition.data == null) {
                milliseconds = 00;
                setnowPossition(0);
                setProgress();
              } else {
                milliseconds = possition.data.inMilliseconds;
                setnowPossition(possition.data.inMilliseconds);
                setProgress();
              }

              return Scaffold(
                body: Stack(
                  children: <Widget>[
                    Container(
                      height: h,
                      child: Image.file(
                        File(musicAlbemArtsList.length == 0
                            ? null
                            : musicAlbemArtsList[nowPlayingSongIndex]),
                        fit: BoxFit.fill,
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 25.0,
                        sigmaY: 25.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: w * 0.5,
                            width: w * 0.5,
                            child: Card(
                              elevation: 16,
                              shape: roundedRectangleBorder(1024.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1024),
                                child: Image.file(
                                  File(musicAlbemArtsList[nowPlayingSongIndex]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                musicList[nowPlayingSongIndex].title,
                                style: textStyle(16.0),
                              ),
                              Text(timeEngine(milliseconds) +
                                  ' | ' +
                                  timeEngine(
                                      audioPlayer.duration.inMilliseconds)),
                              Slider(
                                  value: progress,
                                  onChanged: (dt) {
                                    seek(dt);
                                  }),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    width: h * 0.1,
                                    child: RaisedButton(
                                        child: Icon(Icons.skip_previous),
                                        shape: roundedRectangleBorder(256.0),
                                        onPressed: () {
                                          nowPlayingSongIndex == 0
                                              ? play(nowPlayingSongIndex)
                                              : play(nowPlayingSongIndex - 1);
                                        }),
                                  ),
                                  Container(
                                    height: h * 0.1,
                                    width: h * 0.1,
                                    child: RaisedButton(
                                        child: audioPlayer.state ==
                                                AudioPlayerState.PLAYING
                                            ? Icon(Icons.pause)
                                            : Icon(Icons.play_arrow),
                                        shape: roundedRectangleBorder(256.0),
                                        onPressed: () {
                                          playpause(milliseconds);
                                        }),
                                  ),
                                  Container(
                                    width: h * 0.1,
                                    child: RaisedButton(
                                        child: Icon(Icons.skip_next),
                                        shape: roundedRectangleBorder(256.0),
                                        onPressed: () {
                                          nowPlayingSongIndex ==
                                                  (musicList.length - 1)
                                              ? play(0)
                                              : play(nowPlayingSongIndex + 1);
                                        }),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
