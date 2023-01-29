import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xiumusic/models/myModel.dart';
import '../../generated/l10n.dart';
import '../../models/notifierValue.dart';
import '../../util/httpClient.dart';
import '../../util/mycss.dart';
import '../../util/util.dart';
import '../common/myStructure.dart';
import '../common/myTextButton.dart';
import '../common/myToast.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final AudioPlayer player;
  const PlaylistDetailScreen({
    Key? key,
    required this.player,
  }) : super(key: key);
  @override
  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  List<Songs> _songslist = [];
  int _songsnum = 0;
  int _playCount = 0;
  int _duration = 0;
  String _albumsname = "";
  String _palylistId = "";
  String _arturl = "https://s2.loli.net/2023/01/08/8hBKyu15UDqa9Z2.jpg";
  String _artist = "";
  String _changed = "2023-01-18T16:37:18Z";

  _getSongs(String _playlistId) async {
    final _playlisttem = await getPlaylistbyId(_playlistId);
    if (_playlisttem != null) {
      String _url = await getCoverArt(_playlisttem['id']);
      _playlisttem["imageUrl"] = _url;
      Playlist _playlist = Playlist.fromJson(_playlisttem);
      List<Songs> _temsong = [];
      if (_playlisttem["entry"] != null && _playlisttem["entry"].length > 0) {
        for (var _element in _playlisttem["entry"]) {
          String _stream = getServerInfo("stream");
          String _url = await getCoverArt(_element["id"]);
          _element["stream"] = _stream + '&id=' + _element["id"];
          _element["coverUrl"] = _url;
          Songs _song = Songs.fromJson(_element);
          _temsong.add(_song);
        }
      }

      setState(() {
        _songsnum = _playlist.songCount;
        _albumsname = _playlist.name;
        _duration = _playlist.duration;
        _artist = _playlist.owner;
        _changed = _playlist.changed;
        _arturl = _playlist.imageUrl;
        _palylistId = _playlist.id;
        _songslist = _temsong;
      });
    }
  }

  _delSong(BuildContext context, double _x, double _y, int _index) {
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(_x, _y, _x, _y),
        items: [
          PopupMenuItem(
            child: Text(S.of(context).delete + S.of(context).song),
            value: _index.toString(),
          ),
        ]).then((value) async {
      if (value != null) {
        await delSongfromPlaylist(activeID.value, value);

        MyToast.show(
            context: context,
            message: S.of(context).delete + S.of(context).success);
        _getSongs(activeID.value);
      }
    });
  }

  @override
  initState() {
    super.initState();
    _getSongs(activeID.value);
  }

  Widget _buildTopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: screenImageWidthAndHeight,
                width: screenImageWidthAndHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: _arturl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return AnimatedSwitcher(
                        child: Image.asset(mylogoAsset),
                        duration: const Duration(milliseconds: imageMilli),
                      );
                    },
                  ),
                )),
            SizedBox(
              width: 15,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: isMobile
                          ? windowsWidth.value -
                              screenImageWidthAndHeight -
                              30 -
                              15
                          : windowsWidth.value -
                              drawerWidth -
                              screenImageWidthAndHeight -
                              30 -
                              15,
                      child: Text(_albumsname,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: titleText2)),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                      children: [
                        MyTextButton(
                          press: () {
                            indexValue.value = 2;
                          },
                          title: S.of(context).playlist,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          S.of(context).createuser + ": " + _artist,
                          style: nomalText,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          S.of(context).song + ": " + _songsnum.toString(),
                          style: nomalText,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          S.of(context).dration +
                              ": " +
                              formatDuration(_duration),
                          style: nomalText,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          S.of(context).udpateDate +
                              ": " +
                              timeISOtoString(_changed),
                          style: nomalText,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      child: Row(children: [
                    Text(
                      S.of(context).playCount + ": " + _playCount.toString(),
                      style: nomalText,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MyTextButton(
                        press: () async {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_context) {
                              return AlertDialog(
                                titlePadding: EdgeInsets.all(10),
                                contentPadding: EdgeInsets.all(10),
                                titleTextStyle: nomalText,
                                contentTextStyle: nomalText,
                                backgroundColor: badgeDark,
                                title: Text(
                                  S.of(context).delete,
                                ),
                                content: Text(
                                  S.of(context).delete + _albumsname + "?",
                                ),
                                actions: <Widget>[
                                  MyTextButton(
                                    title: S.of(_context).cancel,
                                    press: () {
                                      Navigator.of(_context).pop();
                                    },
                                  ),
                                  MyTextButton(
                                    title: S.of(_context).confrim,
                                    press: () async {
                                      await deletePlaylist(_palylistId);

                                      Navigator.of(_context).pop();
                                      indexValue.value = 2;
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                        title: S.of(context).delete)
                  ]))
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _itemBuildWidget() {
    return _songslist.length > 0
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _songslist.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  Songs _song = _songslist[index];
                  List<String> _title = [
                    _song.title,
                    formatDuration(_song.duration),
                    if (!isMobile)
                      _song.suffix + "(" + _song.bitRate.toString() + ")",
                    _song.playCount.toString(),
                  ];

                  return Dismissible(
                      // Key
                      key: Key(_song.id),
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          // 从右向左  也就是删除
                        } else if (direction == DismissDirection.startToEnd) {
                          //从左向右
                        }

                        await delSongfromPlaylist(
                            activeID.value, index.toString());

                        _getSongs(activeID.value);
                        MyToast.show(
                            context: context,
                            message:
                                S.of(context).delete + S.of(context).success);
                      },
                      background: Container(
                        color: badgeRed,
                        child: ListTile(
                          leading: Icon(
                            Icons.delete,
                            color: textGray,
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
                        color: badgeRed,
                        child: ListTile(
                          trailing: Icon(
                            Icons.delete,
                            color: textGray,
                          ),
                        ),
                      ),

                      // Child
                      child: ListTile(
                          title: GestureDetector(
                              onTap: () async {
                                if (listEquals(activeList.value, _songslist)) {
                                  widget.player
                                      .seek(Duration.zero, index: index);
                                } else {
                                  //当前歌曲队列
                                  activeIndex.value = index;
                                  activeSongValue.value = _song.id;
                                  //歌曲所在专辑歌曲List
                                  activeList.value = _songslist;
                                }
                              },
                              onSecondaryTapDown: (details) {
                                _delSong(context, details.globalPosition.dx,
                                    details.globalPosition.dy, index);
                              },
                              child: ValueListenableBuilder<Map>(
                                  valueListenable: activeSong,
                                  builder: ((context, value, child) {
                                    return myRowList(
                                        _title,
                                        (value.isNotEmpty &&
                                                value["value"] == _song.id)
                                            ? activeText
                                            : nomalText);
                                  })))));
                }))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 222,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
            SizedBox(
              height: 20,
            ),
            songsHeaderWidget()
          ],
        ),
        contentWidget: _itemBuildWidget());
  }
}
