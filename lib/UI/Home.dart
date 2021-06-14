import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:move_to_background/move_to_background.dart';
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

  TextEditingController playlistName = new TextEditingController();

  void stateSetter(){
    settingsChanged.listen((value) {
      setState(() {
        print(value);
      });
    });
  }

  IconData getIcon(String key){
    if(key =='AllSongs'){
      return Icons.music_note;
    } else if(key =='Favorites'){
      return Icons.favorite;
    } else {
      return Icons.playlist_play_rounded;
    }
  }

  String getName(String key){
    if(key =='AllSongs'){
      return 'All Songs';
    } else {
      return key;
    }
  }

  bool shouldBeDeletable(String key){
    if(key =='AllSongs' || key =='Favorites'){
      return false;
    } else {
      return true;
    }
  }

  void deletePlayList(String playList){
    Get.defaultDialog(
        radius: 8,
        backgroundColor: backShadeColor(),
        title: 'Delete Playlist',
        content: Text('Are You Sure?'),
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
                  hEngine.pBox.delete(playList);
                  Get.back();
              }, child: Text('Delete'))
        ]
    );
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
              } else if(playlistName.text.length < 1 || playlistName.text.length > 16){
                Get.snackbar('Playlist is Too long or Too Short!',
                  'Playlist name must be shorter than 16 characters and longer than 1 character. please use a proper playlist',
                  backgroundColor: backShadeColor(),
                );
              } else {
                hEngine.pBox.put(playlistName.text, []);
                playlistName.clear();
                Get.back();
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
                        newPlayList();
                      },
                    )
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: StreamBuilder(
                    stream: hEngine.pBox.watch(),
                    builder: (context, AsyncSnapshot<BoxEvent> snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<Color>(mainColor()),
                          ),
                        );
                      }
                      return GlowingOverscrollIndicator(
                        color: mainColor(),
                        axisDirection: AxisDirection.down,
                        child: ListView.builder(
                          itemCount: hEngine.pBox.length,
                          itemBuilder: (context,index){
                            return Container(
                              height: 128,
                              margin: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: (){
                                  Get.to(
                                        ()=>AllSongs(
                                      playList: hEngine.pBox.keys.toList()[index],
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: mainColor(),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                ),
                                child: shouldBeDeletable(hEngine.pBox.keys.toList()[index])? Stack(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(getIcon(hEngine.pBox.keys.toList()[index]), size: 72),
                                          ],
                                        ),
                                        Text(getName(hEngine.pBox.keys.toList()[index]), style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
                                        Text(hEngine.pBox.get(hEngine.pBox.keys.toList()[index]).length.toString() +' Songs'),
                                      ],
                                    ),
                                    Positioned(
                                        right: 0,
                                        top: 42,
                                        child: IconButton(
                                          icon: Icon(Icons.highlight_remove_rounded),
                                          onPressed: (){
                                            deletePlayList(hEngine.pBox.keys.toList()[index]);
                                          },
                                        ))
                                  ],
                                ) : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(getIcon(hEngine.pBox.keys.toList()[index]), size: 72),
                                      ],
                                    ),
                                    Text(getName(hEngine.pBox.keys.toList()[index]), style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
                                    Text(hEngine.pBox.get(hEngine.pBox.keys.toList()[index]).length.toString() +' Songs'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
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
