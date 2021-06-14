import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Engine/MusicEngine.dart';
import 'package:umusicv2/Styles/Styles.dart';
import 'package:umusicv2/UI/Search.dart';
import 'package:umusicv2/UI/Settings.dart';
import 'package:umusicv2/UI/SongLibrary/AllSongs.dart';
import 'package:umusicv2/UI/Widgets/Drawer.dart';
import 'package:umusicv2/UI/Widgets/FAB.dart';



class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController playlistName = new TextEditingController();

  void stateSetter(){
    settingsChanged.listen((value) {
      setState(() {
        print(value);
      });
    });
  }

  void newPlayList(){
    Get.defaultDialog(
      radius: 8,
      backgroundColor: backShadeColor(),
      title: 'New Playlist',
      content: TextField(
        autofocus: true,
        controller: playlistName,
        cursorColor: mainColor(),
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
            hintText: 'Playlist Name',
            border: InputBorder.none
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            primary: mainColor()
          ),
            onPressed: (){
            Get.back();
            }, child: Text('Cancel')),
        TextButton(
            style: TextButton.styleFrom(
                primary: mainColor()
            ),
        onPressed: (){
              if(hEngine.pBox.keys.contains(playlistName.text)){
                Get.snackbar('This Playlist Already Exists!',
                  'You Already has a playlist with the same name. please use a different name',
                  backgroundColor: backShadeColor(),
                );
              } else {
                hEngine.pBox.put(playlistName.text, []);
              }
        }, child: Text('Create'))
      ]
    );
  }

  @override
  void initState() {
    MusicEngine().getSongs();
    stateSetter();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor(),
      //drawer: drawer(),

      floatingActionButton: mainFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: WillPopScope(
        onWillPop: () async{
          if(isPlaying.value){
            MoveToBackground.moveTaskToBack();
            return false;
          } else {
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return true;
          }
        },
        child: SafeArea(
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
                Container(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: backShadeColor(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                    onPressed: (){
                      Get.to(()=>Search());
                    },
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                        Text('  Search Your Music Library', style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.5)
                        ),)
                      ],
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
                      onPressed: (){
                        //newPlayList();
                      },
                    )
                  ],
                ),
                SizedBox(height: 16),
                Expanded(

                  child: ListView(
                    //scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        height: 128,
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: (){
                            Get.to(
                                  ()=>AllSongs(
                                    playList: 'AllSongs',
                                  ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: mainColor(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.music_note, size: 72),
                                ],
                              ),
                              Text('All Songs', style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
                              /**
                                  Obx((){
                                  return Text(songs.length.toString() +' Songs');
                                  })
                               **/
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 128,
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: (){
                            //hEngine.devOPS();
                            Get.to(
                                 ()=>AllSongs(
                                    playList: 'Favorites',
                                  ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: mainColor(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.favorite, size: 72),
                                ],
                              ),
                              Text('Favorites', style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
