import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:umusic/AudioEngines/MainEngine.dart';

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

  void getMusic() async {
    musicList = await audioList.getSongs(sortType: SongSortType.DISPLAY_NAME);
    musicPathList.clear();
    musicList.forEach((obj){
      var stringobj = obj.toString().split(',')[11].split(':')[1].trim();
      print(stringobj);
      musicPathList.add(stringobj);
    });
    setState(() {
      musicCount = musicList.length;
    });


  }

  void audiInfo(){
    var dura = audioEngine.duration;

    audioEngine.onAudioPositionChanged.listen((dx){
      print(dx.inMilliseconds);
      setState(() {
        progress = dx.inMilliseconds/dura.inMilliseconds; 
      });
    });
  }


  @override
  void initState() {
    super.initState();
    getMusic();
    
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  //getMusic();
                  audiInfo();
                  audioEngine.stop();
                },
              ),
              Container(
                height: h / 1.4,
                width: w * 0.9,
                child: ListView.builder(
                    itemCount: musicCount,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                         
                          
                          play(musicPathList[index]);

                        },
                        child: Card(
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
                    }),
              ),
              
              Container(
                child: Slider(
                  value: progress, onChanged: (val){
                    seeker(val);
                  }),
              )
            ],
          ),
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
