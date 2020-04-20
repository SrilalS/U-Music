import 'dart:io';
import 'dart:ui';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umusic/AudioEngines/DataService.dart';
import 'package:umusic/Styles/Styles.dart';
import 'package:umusic/AudioEngines/MainEngine.dart';

class PlayScreen extends StatefulWidget {
  final pathtoart;

  const PlayScreen({Key key, this.pathtoart}) : super(key: key);
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {

  var playicon = Icon(Icons.pause);

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent));
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: playerState(),
      builder: (context,statedata){
        
        
        if (statedata.data == AudioPlayerState.PLAYING){
          playicon = Icon(Icons.pause);
        } else if (statedata.data == AudioPlayerState.PAUSED) {
          playicon = Icon(Icons.play_arrow);
        }

        return StreamBuilder(
        stream: setdata(),
        builder: (context, data) {
          int millisecon;
          if (data.data == null) {
            millisecon = 00;
          } else {
            millisecon = data.data.inMilliseconds;
          }

          return Scaffold(
            body: Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: h,
                    child: Image.file(
                      File(widget.pathtoart),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            height: w * 0.8,
                            width: w * 0.8,
                            child: Card(
                              elevation: 16,
                              shape: rounded(1024.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1024),
                                  child: Image.file(
                                    File(widget.pathtoart),
                                    fit: BoxFit.cover,
                                  )),
                            )),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(title),
                              Text(millitomini(millisecon) +
                                  '/' +
                                  millitomini(
                                      audioEngine.duration.inMilliseconds)),
                              Container(
                                child: Slider(
                                    value: currentposition,
                                    onChanged: (val) {
                                      seeker(val);
                                    }),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RaisedButton(
                                      shape: rounded(128.0),
                                      child: Icon(Icons.skip_previous),
                                      onPressed: () {}),
                                  Container(
                                    height: w/6,
                                    width: w/6,
                                    child: RaisedButton(
                                      child:  playicon,
                                        shape: rounded(256.0),
                                        onPressed: () {
                                          playpause(double.parse(
                                              data.data.inSeconds.toString()));

                                          setState(() {
                                            
                                          });
                                        }),
                                  ),
                                  RaisedButton(
                                      child: Icon(Icons.skip_next),
                                      shape: rounded(128.0),
                                      onPressed: () {}),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
    });
  }

  String millitomini(int milli) {
    var min = Duration(milliseconds: milli);
    var timeslices = min.toString().split('.').first.split(':');
    var time = (timeslices[1].toString() + ':' + timeslices[2].toString());

    return time;
  }
}
