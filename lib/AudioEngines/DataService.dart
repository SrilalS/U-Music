
import 'package:umusic/AudioEngines/MainEngine.dart';

var title;
var currentposition;
var curentIndex;
var currentArt;

var nowpossi;

var currentdata;
void setnpossi(data){
  nowpossi = data;
}

void setTitle(data){
  title = data;
}

void setPosi(data){
  currentposition = data;
}

void setCurrentIndex(data){
  currentposition = data;
}

void setCurrentArt(data){
  currentArt = data;
  print(data);
}

Stream setdata(){
  return audioEngine.onAudioPositionChanged.asBroadcastStream();
}

Stream playerState(){
  return audioEngine.onPlayerStateChanged.asBroadcastStream();
}