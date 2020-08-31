import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:umusicv2/UI/Home.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'U Music',
      home: Home(),
    );
  }
}