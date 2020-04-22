import 'dart:io';
import 'dart:ui';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:umusic/AudioEngines/DataService.dart';
import 'package:umusic/AudioEngines/MainEngine.dart';
import 'package:umusic/Styles/Styles.dart';
import 'package:umusic/UI/PlayScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterAudioQuery audioList = FlutterAudioQuery();
  final FlutterLocalNotificationsPlugin noti =
      FlutterLocalNotificationsPlugin();

  var musicList;
  var musicPathList = [];
  var musicArtList = [];
  int musicCount = 0;
  var progress = 0.0;
  var nowplaying;
  int possition = 0;
  int nowindex = 0;
  String nowplayingtitle = '';
  int progressinmillies = 0;

  File check(path){
    File(path).exists().then((data){
      if(data){
        setCurrentArt(data);
      }
    });
  }

  var sorting = SongSortType.DISPLAY_NAME;

  void setnoti() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '0', '0', '0',
        playSound: false,
        enableVibration: false,
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await noti.show(
        0, 'Now Playing: ' + nowplayingtitle, '', platformChannelSpecifics,
        payload: 'item x');
  }

  //iconfor play pause
  Icon ppx = Icon(Icons.play_arrow);

  void getMusic(sortmode) async {
    musicList = await audioList.getSongs(sortType: sortmode);
    musicPathList.clear();
    musicList.forEach((obj) {
      var stringobj =
          obj.toString().split('_data:').last.split(',').first.trim();
      musicPathList.add(stringobj);

      var stringobjalbumart =
          obj.toString().split('album_artwork:').last.split(',').first.trim();
      musicArtList.add(stringobjalbumart);
      setCurrentArt(musicArtList[0]);
    });
    setState(() {
      musicCount = musicList.length;
    });
  }

  void audiInfo() {
    audioEngine.onPlayerStateChanged.listen((d) {
      setTitle(nowplayingtitle);
      setCurrentArt(musicArtList[nowindex]);
      check(musicArtList[nowindex]);
      setState(() {
        if (audioEngine.state == AudioPlayerState.PLAYING) {
          setnoti();
          ppx = Icon(Icons.pause);
        } else if (audioEngine.state == AudioPlayerState.PAUSED) {
          ppx = Icon(Icons.play_arrow);
        } else if (audioEngine.state == AudioPlayerState.COMPLETED) {
          nowindex += 1;
          nowplayingtitle = musicList[nowindex].title;
          nowplaying = musicPathList[nowindex];
          audioEngine.play(musicPathList[nowindex]);

          setTitle(nowplayingtitle);
          setCurrentArt(musicArtList[nowindex]);
        }
      });
    });

    audioEngine.onAudioPositionChanged.listen((dx) {
      setnpossi(dx.inSeconds);
      setState(() {
        possition = dx.inSeconds;
        progressinmillies = dx.inMilliseconds;
        var dura = audioEngine.duration;
        progress = dx.inMilliseconds / dura.inMilliseconds;
        setPosi(progress);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getMusic(sorting);
    audiInfo();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    noti.initialize(initializationSettings);
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
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: <Widget>[
                Container(
                  height: h*0.8,
                    child: Image.file(
                  File(currentArt),
                  fit: BoxFit.cover,
                )),
                BackdropFilter(filter: ImageFilter.blur(
                  sigmaX: 25.0,
                  sigmaY: 25.0,
                  
                ),
                child: Container(
                  height: h * 0.8,
                  width: w,
                  child: ListView.builder(
                      itemCount: musicCount,
                      itemBuilder: (context, index) {
                        if (index == nowindex) {
                          return InkWell(
                            splashColor: Colors.purple,
                            onTap: () {
                              
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

                            setCurrentIndex(index);
                            setTitle(musicList[index].title);
                            //setCurrentArt(musicArtList[curentIndex]);
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
                
                ),
                
                mainappbar(),
              ],
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              height: h * 0.2,
              child: ClipRRect(
                child: InkWell(
                  onTap: () {
                    if (nowplaying != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlayScreen(
                                    pathtoart: musicArtList[nowindex],
                                  )));
                    }
                  },
                  child: Container(
                    color: Colors.grey[900].withOpacity(0.5),
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
                                  //setnoti();
                                  if (nowplaying == null) {
                                    setState(() {
                                      nowplayingtitle = musicList[0].title;
                                    });
                                    nowplaying = musicPathList[0];
                                    nowindex = 0;
                                    play(musicPathList[0]);

                                    setCurrentIndex(0);
                                    setTitle(musicList[0].title);

                                    setCurrentArt(musicArtList[nowindex]);
                                  } else {
                                    playpause(
                                        double.parse(possition.toString()));
                                  }
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
