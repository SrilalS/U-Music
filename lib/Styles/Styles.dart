import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

RoundedRectangleBorder roundedRectangleBorder(size){
  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(size));
}

TextStyle textStyle(size){
  return TextStyle(fontSize: size);
}

InputBorder txtfieldborwhite() {
  return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(4.0));
}
Color primarycolor = Colors.purple;

void setPrimaryColor(Color data){
  primarycolor = data;
}