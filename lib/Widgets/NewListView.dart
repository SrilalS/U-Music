import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umusicv2/ServiceModules/NewEngine.dart';

ListView newMainMusicList() {
  return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: songsList.length,
      itemBuilder: (context, index) {
        return Obx((){
          var x = (pc.progress.value);
          return Container(
          height: Get.height / 11,
          child: Card(
            elevation: 4,
              color: (nowPlayingIndex == index)
                  ? Colors.blue
                  : Colors.grey.shade200,
              child: InkWell(
                onTap: () {
                  if (nowPlayingIndex != index) {
                    play(indexofSong: index);
                  }
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        songsList[index].displayName,
                        style: TextStyle(
                            color: (nowPlayingIndex == index)
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )),
        );
        });
      });
}
