import 'package:flutter/material.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Engine/PlayerEngine.dart';
import 'package:get/get.dart';
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
              child: Obx((){
                return Card(
                    color: index == currentIndex.value ? Colors.blue: Colors.grey.shade800,
                    child: InkWell(
                      onTap: (){
                        pEngine.play(index);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Flexible(
                              child: Container(
                                child: Text(songs[index].title, overflow: TextOverflow.ellipsis,),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                );
              }),
            );
      })
    );
  }
}
