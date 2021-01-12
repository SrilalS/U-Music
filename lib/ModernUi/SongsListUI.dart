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
          return Container(
            height: 64,
            child: Card(
                child: InkWell(
                  onTap: (){
                    pEngine.play(index);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(songs[index].title),
                  ),
                )
            ),
          );
        },
      ),
    );
  }
}
