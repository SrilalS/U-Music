import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:umusicv2/UI/MainHome.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    


    return WillPopScope(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'U Music',
        theme: ThemeData.dark(),
        home: MainHome(),
      ),
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
    );
  }
}
