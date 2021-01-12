import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umusicv2/ServiceModules/NewEngine.dart';
import 'package:umusicv2/Styles/Styles.dart';

Column controlls() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Obx((){
        return Text(pc.name.value);
      }),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx((){
            return Text(timeEngine(pc.timeinmils.value));
          }),
          Text("|"),
          Text(player.current.value ==null ? "00:00" : timeEngine(player.current.value.audio.duration.inMilliseconds)),
        ],
      ),
      Obx((){
        return Slider(value: pc.progress.value, onChanged: (value) {
          try {
            seek(value);
          } catch (e) {}
        });
      }),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: Get.height * 0.1,
            child: RaisedButton(
                color: Colors.blue,
                child: Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                ),
                shape: roundedRectangleBorder(256.0),
                onPressed: () {
                  if (nowPlayingIndex == 0){
                    play(indexofSong:  (songsList.length-1));
                  } else {
                    play(indexofSong: nowPlayingIndex -1);
                  }
                }),
          ),
          Container(
            height: Get.height * 0.1,
            width: Get.height * 0.1,
            child: Obx((){
              print(pc.isPlaying);
              return RaisedButton(
                color: Colors.blue,
                child: pc.isPlaying.value
                    ? Icon(
                        Icons.pause,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                shape: roundedRectangleBorder(256.0),
                onPressed: () {
                    play();
                  });
            }),
          ),
          Container(
            width: Get.height * 0.1,
            child: RaisedButton(
                color: Colors.blue,
                child: Icon(
                  Icons.skip_next,
                  color: Colors.white,
                ),
                shape: roundedRectangleBorder(256.0),
                onPressed: () {
                  if (nowPlayingIndex == 0){
                    play(indexofSong: 1);
                  } else if (nowPlayingIndex == (songsList.length-1)){
                    play(indexofSong: 0);
                  } else {
                    play(indexofSong: nowPlayingIndex +1);
                  }
                }),
          ),
        ],
      )
    ],
  );
}
