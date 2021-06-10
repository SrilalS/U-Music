import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Engine/MusicEngine.dart';
import 'package:umusicv2/Styles/Styles.dart';
import 'package:umusicv2/UI/Search.dart';
import 'package:umusicv2/UI/Settings.dart';
import 'package:umusicv2/UI/SongLibrary/AllSongs.dart';
import 'package:umusicv2/UI/Widgets/FAB.dart';



class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    MusicEngine().getSongs();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: mainFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 32,right: 23,top: 32),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Library', style: TextStyle(fontSize: 32,fontWeight: FontWeight.w500),),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: (){
                      Get.to(()=>Settings());
                    },
                  )
                ],
              ),
              SizedBox(height: 16),
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
                  child: TextField(
                    onTap: (){
                      Get.to(()=>Search());
                    },
                    cursorColor: mainColor(),
                    cursorHeight: 24,

                    decoration: InputDecoration(
                        hintText: 'Search Your Song Library',
                        border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: mainColor(),),

                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Playlists', style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: (){},
                  )
                ],
              ),
              SizedBox(height: 16),
              Container(
                width: Get.width,
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      height: 180,
                      width: 180,
                      child: ElevatedButton(
                        onPressed: (){
                          Get.to(
                                  ()=>AllSongs(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: mainColor(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.music_note, size: 72),
                                ],
                              ),
                              Text('All Songs', style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
                              Obx((){
                                return Text(songs.toList().length.toString() +' Songs');
                              })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Favorites', style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: hEngine.fBox == null ? []: hEngine.fBox.values.map((element){
                    return ListTile(
                      title: Text(element.title),
                    );
                  }).toList(),
                ),
              ),
            ],
        ),
        ),
      ),
    );
  }
}
