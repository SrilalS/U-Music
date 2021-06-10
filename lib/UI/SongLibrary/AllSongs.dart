import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/UI/Play.dart';
import 'package:umusicv2/UI/Widgets/FAB.dart';

class AllSongs extends StatefulWidget {
  const AllSongs({Key key}) : super(key: key);

  @override
  _AllSongsState createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: mainFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: Text('All Songs'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16,right: 16,bottom: 100),
          child: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context,index){
              return Obx((){
                return ListTile(
                  onTap: (){
                    pEngine.play(songs[index]);
                    Get.to(()=>Play());
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  tileColor: songs[index].id == currentIndex.value
                      ? Color(0xffe42c3f)
                      : Colors.transparent,
                  title: Text(
                      songs[index].title,
                      overflow: TextOverflow.ellipsis
                  ),
                  trailing: IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.favorite_border),
                  ),
                  leading: Icon(Icons.music_note,size: 32),
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
