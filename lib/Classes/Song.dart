class Song{
  String id;
  String title;
  String album;
  String artist;

  String uri;
  String albumArt;
  int length;

  Song(){
    this.id = '0';
    this.title = 'Loading...';
    this.album = 'Loading...';
    this.artist = 'Loading...';
    this.uri = 'Loading...';
    this.albumArt = 'Loading...';
    this.length = 0;
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
