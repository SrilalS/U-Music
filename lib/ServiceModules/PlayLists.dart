import 'dart:ui';

import 'package:flutter/material.dart';

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
        FlatButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
        FlatButton(onPressed: (){}, child: Text('Add'))
      ],
    ),
  );
}