// For Future Expanstions of Saving Lyrics
bool isLyriced = false;
String lyrics;
int lyricedindex;

void setisLyriced(bool data) {
  isLyriced = data;
}

void setLyrics(String data) {
  lyrics = data;
}

void setLyricedIndex(int data) {
  lyricedindex = data;
}

void emptylyrics() {
  isLyriced = false;
  lyrics = 'Lyrics Not Found';
  lyricedindex = -1;
}
