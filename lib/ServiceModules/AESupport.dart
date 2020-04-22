import 'AudioEngine.dart';

void autonext(){
  nowPlayingSongIndex==(musicList.length-1) ? play(0):play(nowPlayingSongIndex+1);
}