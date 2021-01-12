import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umusicv2/UI/NewHome.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'U Music',
      home: NXHome(),
    );
  }
}