import 'package:hive/hive.dart';

part 'Song.g.dart';

@HiveType(typeId : 1)
class Song{
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String album;

  @HiveField(3)
  String artist;

  @HiveField(4)
  String uri;

  @HiveField(5)
  String albumArt;

  @HiveField(6)
  int length;

  Song(){
    this.id = '0';
    this.title = 'Loading...';
    this.album = 'Loading...';
    this.artist = 'Loading...';
    this.uri = 'Loading...';
    this.albumArt = 'Loading...';
    this.length = 620;
  }


  Song.name(this.id, this.title, this.album, this.artist, this.uri, this.albumArt, this.length);

  Song.fromJSON(Map<String, dynamic> json){
    this.id = json['id'];
    this.title = json['title'];
    this.album = json['album'];
    this.artist = json['artist'];
    this.uri = json['uri'];
    this.albumArt = json['albumArt'];
    this.length = json['length'];
  }

  Map<String, dynamic> toJson() =>
      {
        'id': this.id,
        'title': this.title,
        'album':this.album,
        'artist': this.artist,
        'uri': this.uri,
        'albumArt': this.albumArt,
        'length': this.length,
      };
}
