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
  int progressinmillies = 0;

  var sorting = SongSortType.DISPLAY_NAME;

  //iconfor play pause
  Icon ppx = Icon(Icons.play_arrow);

  void getMusic(sortmode) async {
    musicList = await audioList.getSongs(sortType: sortmode);
    musicPathList.clear();
    musicList.forEach((obj) {
      var stringobj =
          obj.toString().split('_data:').last.split(',').first.trim();
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
        } else if (audioEngine.state == AudioPlayerState.COMPLETED) {
          nowindex += 1;
          nowplayingtitle = musicList[nowindex].title;
          nowplaying = musicPathList[nowindex];
          audioEngine.play(musicPathList[nowindex]);
        }
      });
    });

    audioEngine.onAudioPositionChanged.listen((dx) {
      setState(() {
        possition = dx.inSeconds;
        progressinmillies = dx.inMilliseconds;
        var dura = audioEngine.duration;
        progress = dx.inMilliseconds / dura.inMilliseconds;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getMusic(sorting);
    audiInfo();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.purple,
        statusBarColor: Colors.purple));
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: <Widget>[
                Container(
                  height: h * 0.8,
                  width: w,
                  child: ListView.builder(
                  
                      itemCount: musicCount,
                      itemBuilder: (context, index) {
                        if (index == nowindex) {
                          return InkWell(
                            splashColor: Colors.purple,
                            onTap: () {
                              setState(() {
                                nowplayingtitle = musicList[index].title;
                              });
                              nowplaying = musicPathList[index];
                              nowindex = index;
                              play(musicPathList[index]);
                            },
                            child: Card(
                              margin: EdgeInsets.only(
                                  left: 16, right: 16, top: 4, bottom: 4),
                              color: Colors.purple,
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
                            margin: EdgeInsets.only(
                                left: 16, right: 16, top: 4, bottom: 4),
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
                      }),
                ),
                mainappbar(),
              ],
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              height: h * 0.2,
              child: ClipRRect(
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    color: Colors.grey[900].withOpacity(0.7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(nowplayingtitle),
                        Text(millitomini(progressinmillies).toString() +
                            ' / ' +
                            millitomini(audioEngine.duration.inMilliseconds)
                                .toString()),
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
                                  nowindex -= 1;
                                  nowplayingtitle = musicList[nowindex].title;
                                  nowplaying = musicPathList[nowindex];
                                  audioEngine.play(musicPathList[nowindex]);
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
                                  nowindex += 1;
                                  nowplayingtitle = musicList[nowindex].title;
                                  nowplaying = musicPathList[nowindex];
                                  audioEngine.play(musicPathList[nowindex]);
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

  String millitomini(int milli) {
    var min = Duration(milliseconds: milli);
    var timeslices = min.toString().split('.').first.split(':');
    var time = (timeslices[1].toString() + ':' + timeslices[2].toString());

    return time;
  }

  Widget mainappbar() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 32,
        ),
        PopupMenuButton<String>(
          onSelected: (item) {
            getMusic(sort(item));
          },
          itemBuilder: (BuildContext context) {
            return {'Sort by Name', 'Sort by Artist', 'Sort by Default'}
                .map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
