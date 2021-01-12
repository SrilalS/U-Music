import 'package:flutter/material.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Engine/MusicEngine.dart';
import 'package:umusicv2/Engine/PlayerEngine.dart';

class SongsListUi extends StatefulWidget {
  final PlayerEngine pE;

  const SongsListUi({Key key, this.pE}) : super(key: key);
  @override
  _SongsListUiState createState() => _SongsListUiState();
}

class _SongsListUiState extends State<SongsListUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: songs == null ? 0:songs.length,
        itemBuilder: (context,index){
          return Padding(
            padding: EdgeInsets.all(2),
            child: Card(
              color: ,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(songs[index].title),
              )
            ),
          );
        },
      ),
    );
  }
}
