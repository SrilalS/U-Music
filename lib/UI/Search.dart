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
      appBar: AppBar(
        title: TextField(
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
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context,index){
          if (searchText.text.length > 0 &&
              songs[index]
                  .title
                  .toLowerCase()
                  .similarityTo(searchText.text.toLowerCase()) <
                  0.05) {
            print(songs[index].title.similarityTo(searchText.text));
            return Container();
          }
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
    );
  }
}
