import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';

Color mainColor(){
  return Color(hEngine.sBox.get('ThemeColor', defaultValue: 0xffe42c3f));
}

Color backColor(){
  return Color(hEngine.sBox.get('BackColor', defaultValue: 0xff260f42));
}

Color backShadeColor(){
  return Color(hEngine.sBox.get('BackShadeColor', defaultValue: 0xff381e58));
}

RoundedRectangleBorder roundedRectangleBorder(size){
  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(size));
}

TextStyle textStyle(size){
  return TextStyle(fontSize: size);
}

InputBorder txtfieldborwhite() {
  return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blue, width: 2.0),
      borderRadius: BorderRadius.circular(4.0));
}
Color primarycolor = Colors.purple;

void setPrimaryColor(Color data){
  primarycolor = data;
}

TextStyle textStylebold(){
  return TextStyle(fontWeight: FontWeight.bold);
}
