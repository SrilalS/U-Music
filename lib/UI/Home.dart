import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterAudioQuery audioEngine = FlutterAudioQuery();

  var musicList;
  int musicCount = 0;

  void getMusic() async {
    musicList = await audioEngine.getSongs();
    print(musicList.toList());
    setState(() {
      musicCount = musicList.length;
    });
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
                  getMusic();
                },
                
              ),
              Container(
                height: h/1.5,
                width: w*0.9,
                child: ListView.builder(
                  itemCount: musicCount,
                  itemBuilder: (context, index){
                    return Card(
                      color: Colors.purple,
                                          child: ListTile(
                        title: Text(musicList[index].title),
                        subtitle: Text((int.parse(musicList[index].duration)).toStringAsPrecision(3).toString()),
                      ),
                    );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
