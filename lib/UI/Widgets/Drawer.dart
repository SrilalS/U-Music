import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umusicv2/UI/SongLibrary/AllSongs.dart';

Widget drawer(){
  return Drawer(
    child: AllSongs(),
  );
}
