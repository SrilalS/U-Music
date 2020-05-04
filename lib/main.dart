import 'package:flutter/material.dart';
import 'package:umusicv2/Styles/Styles.dart';
import 'package:umusicv2/UI/Home.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
   
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'U Music',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: primarycolor,
      ),
      home: Home(),
    );
  }
}