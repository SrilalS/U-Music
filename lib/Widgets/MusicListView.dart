import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';
import 'package:umusicv2/ServiceModules/PlayLists.dart';
import 'package:umusicv2/UI/PlayUi.dart';

ListView mainMusicList() {
  return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: musicList.length,
      itemBuilder: (context, index) {
        return Card(
          color:
              playListTemp.contains(index) ? Colors.blue : (index == nowPlayingSongIndex ? Colors.purple : Colors.grey[800]),
          child: InkWell(
            onTap: () {
              if (audioPlayer.state == AudioPlayerState.PLAYING) {
                nowPlayingSongIndex == index
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PlayUi()))
                    : play(index);
              } else if (audioPlayer.state == AudioPlayerState.PAUSED) {
                nowPlayingSongIndex == index
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PlayUi()))
                    : play(index);
              } else {
                nowPossition == 0 ? play(index) : playpause(nowPossition);
              }
            },
            onLongPress: (){
              playListTemp.contains(index) ? playListTemp.remove(index) : addtoTmpList(index);
            },
            child: ListTile(
              title: Text(musicList[index].title),
            ),
          ),
        );
      });
}
