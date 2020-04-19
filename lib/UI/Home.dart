import 'dart:ui';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:umusic/AudioEngines/MainEngine.dart';
import 'package:umusic/Styles/Styles.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterAudioQuery audioList = FlutterAudioQuery();
  var musicList;
  var musicPathList = [];
  int musicCount = 0;
  var progress = 0.0;
  var nowplaying;
  int possition = 0;
  int nowindex = 0;
  String nowplayingtitle = '';

  //iconfor play pause
  Icon ppx = Icon(Icons.play_arrow);

  //ui gimix
  var caliber = 0.2;
  var listcaliber = 0.8;

  void getMusic() async {
    musicList = await audioList.getSongs(sortType: SongSortType.DISPLAY_NAME);
    musicPathList.clear();
    musicList.forEach((obj) {
      var stringobj = obj.toString().split(',')[11].split(':')[1].trim();
      print(stringobj);
      musicPathList.add(stringobj);
    });
    setState(() {
      musicCount = musicList.length;
    });
  }

  void audiInfo() {
    audioEngine.onPlayerStateChanged.listen((d) {
      setState(() {
        if (audioEngine.state == AudioPlayerState.PLAYING) {
          ppx = Icon(Icons.pause);
        } else if (audioEngine.state == AudioPlayerState.PAUSED) {
          ppx = Icon(Icons.play_arrow);
        }
      });
    });

    audioEngine.onAudioPositionChanged.listen((dx) {
      setState(() {
        possition = dx.inSeconds;
        var dura = audioEngine.duration;
        progress = dx.inMilliseconds / dura.inMilliseconds;
        //print(progress);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getMusic();
    audiInfo();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.purple,
        statusBarColor: Colors.transparent));
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
     
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: h * listcaliber,
              width: w,
              child: ListView.builder(
                  itemCount: musicCount,
                  itemBuilder: (context, index) {
                    if (musicCount < 1){
                      return Center(child: CircularProgressIndicator(),);
                    }

                    if (index == nowindex) {
                      return InkWell(
                        hoverColor: Colors.purple,
                        focusColor: Colors.purple,
                        highlightColor: Colors.purple,
                        splashColor: Colors.purple,
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            nowplayingtitle = musicList[index].title;
                          });
                          nowplaying = musicPathList[index];
                          nowindex = index;
                          play(musicPathList[index]);
                        },
                        child: Card(
                          //color: Colors.purple,
                          child: ListTile(
                            
                            title: Text(
                              musicList[index].title,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                            ),
                            subtitle: Text(millitomini(
                                    int.parse(musicList[index].duration))
                                .toString()),
                          ),
                        ),
                      );
                    }
                    return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          nowplayingtitle = musicList[index].title;
                        });
                        nowplaying = musicPathList[index];
                        nowindex = index;
                        play(musicPathList[index]);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(
                            musicList[index].title,
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                              millitomini(int.parse(musicList[index].duration))
                                  .toString()),
                        ),
                      ),
                    );
                  }),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              height: h * caliber,
              child: ClipRRect(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (caliber == 1) {
                        caliber = 0.2;
                        listcaliber = 0.8;
                      } else {
                        caliber = 1;
                        listcaliber = 0.0;
                      }
                    });
                  },
                  child: Container(
                    color: Colors.grey[900].withOpacity(0.7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(nowplayingtitle),
                        Container(
                          child: Slider(
                              value: progress,
                              onChanged: (val) {
                                seeker(val);
                              }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                                shape: rounded(128.0),
                                child: Icon(Icons.skip_previous),
                                onPressed: () {
                                  audioEngine.stop();
                                  audioEngine
                                      .play(musicPathList[nowindex - 1]);
                                }),
                            RaisedButton(
                                child: ppx,
                                shape: rounded(128.0),
                                onPressed: () {
                                  playpause(possition);
                                }),
                            RaisedButton(
                                child: Icon(Icons.skip_next),
                                shape: rounded(128.0),
                                onPressed: () {
                                  audioEngine.stop();
                                  audioEngine
                                      .play(musicPathList[nowindex + 1]);
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double millitomini(int milli) {
    var min = Duration(milliseconds: milli);
    var mini = int.parse(min.inSeconds.toString());
    var minit = mini % 60;
    var miex = ((mini - minit) / 60).toString().split('.')[0];
    var finx = miex + '.' + minit.toString();
    return double.parse(finx);
  }
}
