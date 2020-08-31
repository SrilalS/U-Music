import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umusicv2/Secrets/APIKEYS.dart';
import 'package:umusicv2/ServiceModules/AudioEngine.dart';
import 'package:umusicv2/ServiceModules/Lyrics.dart';
import 'package:umusicv2/Styles/Styles.dart';
import 'package:http/http.dart' as http;

class LyricsUI extends StatefulWidget {
  @override
  _LyricsUIState createState() => _LyricsUIState();
}

class _LyricsUIState extends State<LyricsUI>
    with AutomaticKeepAliveClientMixin {
      
  final artistnamecontroller =
      TextEditingController(text: musicArtists[nowPlayingSongIndex]);
  final songnamecontroller =
      TextEditingController(text: musicTitles[nowPlayingSongIndex]);

  
  bool progress = false;

  void getLyrics() async {
    var apikey = musixmatchapikey;
    await http
        .get(
            'https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?format=json&callback=callback&q_track=' +
                songnamecontroller.text +
                '&q_artist=' +
                artistnamecontroller.text +
                '&apikey=$apikey')
        .then((response) {
      if (response.statusCode == 200) {
        
        var datapack = jsonDecode(response.body);
        if (datapack['message']['header']['status_code'] != 200) {
          setState(() {
            
            setLyrics('Lyrics Not Found');
            setisLyriced(true);
            setLyricedIndex(nowPlayingSongIndex);
            progress = false;

          });
        } else {
          setState(() {
            setLyrics(datapack['message']['body']['lyrics']['lyrics_body']);
            setisLyriced(true);
            setLyricedIndex(nowPlayingSongIndex);
            progress = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //artistnamecontroller.text = musicList[nowPlayingSongIndex].title;
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Center(
            child: (isLyriced && (nowPlayingSongIndex == lyricedindex))
                ? lyScreen()
                : Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Lyrics',
                          style: textStyle(24.0),
                        ),
                        Text('Lyrics Provided by MusixMatch. ❤'),
                        SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                              helperText: 'Artist Name',
                              enabledBorder: txtfieldborwhite(),
                              focusedBorder: txtfieldborwhite()),
                          controller: artistnamecontroller,
                        ),
                        SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                              helperText: 'Song Name',
                              enabledBorder: txtfieldborwhite(),
                              focusedBorder: txtfieldborwhite()),
                          controller: songnamecontroller,
                        ),
                        SizedBox(height: 8),
                        RaisedButton(
                            color: Colors.blue,
                            splashColor: Colors.blueAccent,
                            child: Text(
                              'Search',
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: roundedRectangleBorder(64.0),
                            onPressed: () {
                              setState(() {
                                progress = true;
                                getLyrics();
                              });
                            })
                      ],
                    ),
                  ),
          ),
        ),
        progress ? Container(
          color: Colors.blue.withOpacity(0.5),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)
            ),
          ),
        ) : Container()
      ],
    );
  }

  @override
  bool wantKeepAlive = true;

  Widget lyScreen() {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(8),
          child: Text(
            lyrics,
            style: textStyle(16.0),
          )),
    );
  }
}
