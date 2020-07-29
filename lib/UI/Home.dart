import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umusicv2/ServiceModules/AESupport.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';
import 'package:umusicv2/ServiceModules/Lyrics.dart';
import 'package:umusicv2/ServiceModules/Notifications.dart';
import 'package:umusicv2/ServiceModules/PlayLists.dart';
import 'package:umusicv2/ServiceModules/StorageWorker.dart';
import 'package:umusicv2/Styles/Styles.dart';
import 'package:umusicv2/Widgets/MusicListView.dart';

import 'PlayUi.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer timer;

  void isthisfirst() async{
    SharedPreferences hdriver = await SharedPreferences.getInstance();
    bool isthisfirstrun =  hdriver.getBool('ITFR')?? true ;
    print(isthisfirstrun);
    getMusicList(isthisfirstrun);
  }

  @override
  void initState() {
    super.initState();
    listener();
    isthisfirst();
    getMusicList(true).then((value){
      setState(() {});
    });
    initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent));

    Widget drawer() {
      //getSaved();
      return Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width *0.6,
            child: ListView.builder(
                itemCount: playLists.length,
                itemBuilder: (context, index) {
                  
                  return Card(
                    child: InkWell(
                      onTap: (){},
                      child: ListTile(title: Text(playLists[index]),)),
                  );
                }),
          )
        ],
      );
    }

    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0,
              ),
              child: AlertDialog(
                title: Text('Are you Sure?'),
                content: Text('Are You Sure You Want to Exit?'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No')),
                  FlatButton(
                      onPressed: () {
                        audioPlayer.stop();
                        notifications.cancelAll();
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                      },
                      child: Text('Yes')),
                ],
              ),
            ));
      },
      child: StreamBuilder(
          stream: audioplayerstatestream(),
          builder: (context, state) {
            if (state.data == AudioPlayerState.COMPLETED) {
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
                  drawer: drawer(),
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
                            playListTemp.isEmpty
                                ? Container()
                                : AppBar(
                                    backgroundColor: Colors.red,
                                    
                                    title: Text(playListTemp.length.toString() +
                                        ' Selected'),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            //clearList();
                                            showDialog(
                                                context: context,
                                                child: makePlayList(context));
                                          },
                                          child: Text('Create a Play List')),
                                      FlatButton(
                                          onPressed: () {
                                            clearList();
                                          },
                                          child: Text('Clear'))
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: PopupMenuButton(
                                          itemBuilder: (context) {
                                          return <PopupMenuEntry>[
                                            PopupMenuItem(
                                              value: "Scan",
                                              child: Text("Scan For New Songs"))
                                          ];
                                        },
                                        onSelected: (value){
                                          getMusicList(true).then((value){
                                            setState(() {});
                                          });
                                        },
                                        )
                                      ),
                                    ],
                                  )
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlayUi()));
                          },
                          child: Container(
                            //color: Colors.grey[900].withOpacity(0.5),
                            width: w,
                            height: h * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  musicTitles[nowPlayingSongIndex],
                                  textAlign: TextAlign.center,
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
                                            setState(() {
                                              emptylyrics();
                                            });
                                          }),
                                    ),
                                    Container(
                                      height: h * 0.1,
                                      width: h * 0.1,
                                      child: RaisedButton(
                                          child: state.data ==
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
                                            setState(() {
                                              emptylyrics();
                                            });
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
          }),
    );
  }
}
