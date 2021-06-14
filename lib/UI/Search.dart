import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Styles/Styles.dart';
import 'package:string_similarity/string_similarity.dart';
import 'Play.dart';

class Search extends StatefulWidget {
  final String playList = 'AllSongs';
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController searchText = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor(),
      appBar: AppBar(
        backgroundColor: backShadeColor(),
        title: TextField(
          autofocus: true,
          controller: searchText,
          onChanged: (val){
            setState(() {});
          },
          cursorColor: mainColor(),
          style: TextStyle(fontSize: 18),
          decoration: InputDecoration(
            hintText: 'Search Your Song Library',
            border: InputBorder.none
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: mainColor(),
          child: ListView.builder(
            itemCount: hEngine.pBox.get(widget.playList,defaultValue: []).length,
            itemBuilder: (context,index){
              if (searchText.text.length > 0 &&
                  hEngine.pBox.get(widget.playList,defaultValue: [])[index]
                      .title
                      .toLowerCase()
                      .similarityTo(searchText.text.toLowerCase()) <
                      0.05) {
                //print(songs[index].title.similarityTo(searchText.text));
                return Container();
              }
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
                      if(hEngine.pBox.get('Favorites').contains(hEngine.pBox.get(widget.playList)[index])){
                        await hEngine.removeFromPlayList('Favorites', hEngine.pBox.get(widget.playList)[index]);
                        setState(() {});
                      } else {
                        await hEngine.saveToPlayList('Favorites', hEngine.pBox.get(widget.playList)[index]);
                        setState(() {});
                      }
                    },
                    icon: hEngine.pBox.get('Favorites').contains(hEngine.pBox.get(widget.playList)[index]) ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                  ),
                  leading: Icon(Icons.music_note,size: 32),
                );
              });
            },
          ),
        ),
      )
    );
  }
}
