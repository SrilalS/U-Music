import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:umusicv2/ServiceModules/StorageWorker.dart';

List playListTemp = [];

void addtoTmpList(data){
  playListTemp.add(data);
}

void clearList(){
  playListTemp.clear();
}

final playlistname = TextEditingController();
Widget makePlayList(context){
  return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5.0,
        sigmaY: 5.0,
      ),
      child: AlertDialog(
      title: Text('New Play List'),
      content: TextField(
        controller: playlistname,
      
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          //getSaved();
          //Navigator.pop(context);
          }, child: Text('Cancel')),
        FlatButton(onPressed: (){
          saveMusicList(playlistname.text, playListTemp);
        }, child: Text('Add'))
      ],
    ),
  );
}