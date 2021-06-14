import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Styles/Styles.dart';
import 'package:umusicv2/UI/Play.dart';
import 'package:umusicv2/UI/Widgets/FAB.dart';

class AllSongs extends StatefulWidget {
  final String playList;
  const AllSongs({Key key, this.playList}) : super(key: key);

  @override
  _AllSongsState createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {

  void stateSetter(){
    songsListChanged.listen((value) {
      setState(() {
        print(value);
      });
    });
  }

  @override
  void initState() {
    stateSetter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor(),
      floatingActionButton: mainFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        backgroundColor: backColor(),
        title: Text(widget.playList),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
          child: StreamBuilder(
            stream: hEngine.pBox.watch(key: 'Favorites'),
            builder: (context,snapshot){
              return ListView.builder(
                itemCount: hEngine.pBox.get(widget.playList, defaultValue: []).length,
                itemBuilder: (context,index){
                  //print(hEngine.asBox.values.toList());
                  return Obx((){
                    return ListTile(
                      onTap: (){
                        pEngine.play(widget.playList,hEngine.pBox.get(widget.playList)[index],index);
                        Get.to(()=>Play());
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      tileColor: hEngine.pBox.get(widget.playList)[index].id == currentSong.value.id
                          ? mainColor()
                          : Colors.transparent,
                      title: Text(
                          hEngine.pBox.get(widget.playList)[index].title,
                          overflow: TextOverflow.ellipsis
                      ),
                      trailing: IconButton(
                        onPressed: () async{
                          //print(hEngine.pBox.get('Favorites',defaultValue: []));
                          if(hEngine.pBox.get('Favorites',defaultValue: []).contains(hEngine.pBox.get(widget.playList)[index])){
                            await hEngine.removeFromPlayList('Favorites', hEngine.pBox.get(widget.playList)[index]);
                            setState(() {});
                          } else {
                            await hEngine.saveToPlayList('Favorites', hEngine.pBox.get(widget.playList)[index]);
                            setState(() {});
                          }
                        },
                        //icon: Icon(Icons.favorite)
                        icon: hEngine.pBox.get('Favorites',defaultValue: []).contains(hEngine.pBox.get(widget.playList)[index]) ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                      ),
                      leading: Icon(Icons.music_note,size: 32),
                    );
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
