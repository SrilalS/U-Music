import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:umusicv2/Classes/PlayInfo.dart';
import 'package:umusicv2/Engine/PlayerEngine.dart';

class SongsListUi extends StatefulWidget {
  final PlayerEngine pE;

  const SongsListUi({Key key, this.pE}) : super(key: key);

  @override
  _SongsListUiState createState() => _SongsListUiState();
}

class _SongsListUiState extends State<SongsListUi>
    with AutomaticKeepAliveClientMixin {
  RxBool search = false.obs;
  TextEditingController searchText = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        title: Obx(() {
          return Visibility(
            visible: search.value,
            child: TextField(
              controller: searchText,
              autofocus: true,
              maxLines: 1,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 8, top: 16, right: 15),
                  hintText: 'Search...',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          searchText.clear();
                        });
                      },
                      color: Colors.white,
                      icon: Icon(Icons.highlight_remove))),
              onChanged: (val) {
                setState(() {});
              },
            ),
          );
        }),
        actions: [
          Obx(() {
            return Visibility(
              visible: !search.value,
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  search.value = !search.value;
                },
              ),
            );
          }),
          Obx(() {
            return Visibility(
              visible: search.value,
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  search.value = !search.value;
                  setState(() {
                    searchText.clear();
                  });
                },
              ),
            );
          }),

        ],
      ),
      backgroundColor: Colors.black.withOpacity(0.75),
      body: GetX(
        tag: 'MusicList',
        builder: (context) {
          return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                if (searchText.text.length > 0 &&
                    songs[index]
                            .title
                            .toLowerCase()
                            .similarityTo(searchText.text.toLowerCase()) <
                        0.1) {
                  print(songs[index].title.similarityTo(searchText.text));
                  return Container();
                }

                return Container(
                  //height: 64,
                  child: Obx(() {
                    return Card(
                        color: index == currentIndex.value
                            ? Colors.blue
                            : Colors.grey.shade800,
                        child: ListTile(
                          dense: true,
                          onTap: () {
                            pEngine.play(index);
                          },
                          title: Text(
                            songs[index].title,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            songs[index].artist,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            Duration(milliseconds: songs[index].length).toString().split('.')[0],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ));
                  }),
                );
              });
        },
      ),
    );
  }

  @override
  bool wantKeepAlive = true;
}
