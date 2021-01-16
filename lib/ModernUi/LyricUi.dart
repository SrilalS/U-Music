import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Secrets/APIKEYS.dart';
import 'package:umusicv2/ServiceModules/Lyrics.dart';
import 'package:http/http.dart' as http;

class LyricsUI extends StatefulWidget {
  @override
  _LyricsUIState createState() => _LyricsUIState();
}

bool haslyrics = false;
String lyric = '';
String lyricsTitle = '';

class _LyricsUIState extends State<LyricsUI>{
  bool progress = false;


  final artistnamecontroller =
  TextEditingController(text: currentSong.value.title);
  final songnamecontroller =
  TextEditingController(text: currentSong.value.title);
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
      setState(() {
        progress = false;
      });
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        //print(body['message']['header']['status_code']);
        if (body['message']['header']['status_code'] == 200){
          setState(() {
            haslyrics = true;
            lyrics = body['message']['body']['lyrics']['lyrics_body'];
            lyricsTitle = currentSong.value.title;
          });
        } else {
          Get.snackbar('Lyrics Not Found!', 'No Lyrics Matching this song is Found');
        }

      } else {
          Get.snackbar('Lyrics Not Found!', 'No Lyrics Matching this song is Found');
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.black.withOpacity(0.8),
          body: Obx((){
            artistnamecontroller.text = currentSong.value.title;
            songnamecontroller.text = currentSong.value.title;
            return Center(
              child: (haslyrics && (lyricsTitle == currentSong.value.title))
                  ? lyScreen()
                  : Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Lyrics Provided by MusixMatch. ❤'),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                          helperText: 'Artist Name',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white
                              )
                          ),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                              color: Colors.white
                          ))),
                      controller: artistnamecontroller,
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                          helperText: 'Song Name',
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(
                              color: Colors.white
                          )),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                              color: Colors.white
                          ))),
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
                        //shape: roundedRectangleBorder(64.0),
                        onPressed: () {
                          setState(() {
                            progress = true;
                            getLyrics();
                          });
                        })
                  ],
                ),
              ),
            );
          })
        ),
        progress ? Container(
          color: Colors.black45.withOpacity(0.5),
          child: Center(
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)
            ),
          ),
        ) : Container()
      ],
    );
  }

  Widget lyScreen() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(8),
            child: Text(
              lyrics,
              //style: textStyle(16.0),
            )),
      )
    );
  }
}
