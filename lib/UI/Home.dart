import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umusicv2/ServiceModules/AESupport.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';
import 'package:umusicv2/ServiceModules/Notifications.dart';
import 'package:umusicv2/Styles/Styles.dart';
import 'package:umusicv2/Widgets/MusicListView.dart';

import 'PlayUi.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer timer;
  @override
  void initState() {
    super.initState();
    listener();
    getMusicList();
    initNotifications();
    
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.purple));

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
                body: Center(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            height: h * 0.7,
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
                            child: Container(
                              height: h * 0.7,
                              child: SafeArea(child: mainMusicList()),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayUi()));
                        },
                                              child: Container(
                          color: Colors.grey[900].withOpacity(0.5),
                          width: w,
                          height: h * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(musicList[nowPlayingSongIndex].title, textAlign: TextAlign.center, style: textStyle(16.0),),
                              Text(timeEngine(milliseconds) + ' | ' + timeEngine(audioPlayer.duration.inMilliseconds)),
                              Slider(
                                  value: progress,
                                  onChanged: (dt) {
                                    seek(dt);
                                  }),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    width: h * 0.1,
                                    child: RaisedButton(
                                        child: Icon(Icons.skip_previous),
                                        shape: roundedRectangleBorder(256.0),
                                        onPressed: () {
                                          nowPlayingSongIndex == 0 ? play(nowPlayingSongIndex) : play(nowPlayingSongIndex - 1);
                                        }),
                                  ),
                                  Container(
                                    height: h * 0.1,
                                    width: h * 0.1,
                                    child: RaisedButton(
                                        child:
                                            state.data == AudioPlayerState.PLAYING
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
                                            nowPlayingSongIndex == (musicList.length - 1) ? play(0) : play(nowPlayingSongIndex + 1);
                                        }),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
