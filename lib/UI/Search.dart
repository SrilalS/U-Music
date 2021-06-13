import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Styles/Styles.dart';
import 'package:string_similarity/string_similarity.dart';
import 'Play.dart';

class Search extends StatefulWidget {
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
        child: ListView.builder(
          itemCount: hEngine.asBox.length,
          itemBuilder: (context,index){
            if (searchText.text.length > 0 &&
                hEngine.asBox.getAt(index)
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
                  pEngine.play(hEngine.asBox.getAt(index),index);
                  Get.to(()=>Play());
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                tileColor: index == currentIndex.value
                    ? mainColor()
                    : Colors.transparent,
                title: Text(
                    hEngine.asBox.getAt(index).title,
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
      )
    );
  }
}
