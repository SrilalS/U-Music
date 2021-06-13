import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Styles/Styles.dart';
import 'package:umusicv2/UI/Play.dart';
import 'package:umusicv2/UI/Widgets/FAB.dart';

class AllSongs extends StatefulWidget {
  const AllSongs({Key key}) : super(key: key);

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
        title: Text('All Songs'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
          child: ListView.builder(
            itemCount: hEngine.asBox.length,
            itemBuilder: (context,index){
              //print(hEngine.asBox.values.toList());
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
        ),
      ),
    );
  }
}
