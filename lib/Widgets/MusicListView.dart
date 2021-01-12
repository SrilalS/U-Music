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
          color: playListTemp.contains(index)
              ? Colors.blue
              : (index == nowPlayingSongIndex ? Colors.blue : Colors.grey[800]),
          child: InkWell(
            onTap: () {
              if (assetsAudioPlayer.isPlaying.value) {
                if (nowPlayingSongIndex == index) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PlayUi()));
                } else {
                  play(index);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PlayUi()));
                }
              } else if (!assetsAudioPlayer.isPlaying.value) {
                if (nowPlayingSongIndex == index) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PlayUi()));
                } else {
                  play(index);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PlayUi()));
                }
              } else {
                nowPossition == 0 ? play(index) : playpause(nowPossition);
              }
            },
            onLongPress: () {
              // playListTemp.contains(index) ? playListTemp.remove(index) : addtoTmpList(index);
            },
            child: ListTile(
              title: Text(
                musicTitles[index],
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      });
}
