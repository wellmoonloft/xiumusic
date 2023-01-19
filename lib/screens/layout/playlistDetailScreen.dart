import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xiumusic/models/myModel.dart';
import '../../util/baseDB.dart';
import '../../models/notifierValue.dart';
import '../../util/httpClient.dart';
import '../common/baseCSS.dart';
import '../../util/localizations.dart';
import '../../util/util.dart';
import '../common/myAlertDialog.dart';
import '../common/myStructure.dart';
import '../common/myTextButton.dart';

class PlaylistDetailScreen extends StatefulWidget {
  const PlaylistDetailScreen({
    Key? key,
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
  int _year = 0;
  String _changed = "2023-01-18T16:37:18Z";

  _getSongs(String _playlistId) async {
    final _playlisttem = await BaseDB.instance.getPlaylistById(_playlistId);
    if (_playlisttem != null) {
      Playlist _playlist = _playlisttem;
      final _songlist = await BaseDB.instance.getPlaylistSongs(_playlisttem.id);
      setState(() {
        _songsnum = _playlist.songCount;
        _albumsname = _playlist.name;
        _duration = _playlist.duration;
        _artist = _playlist.owner;
        _changed = _playlist.changed;
        _arturl = _playlist.imageUrl;
        _palylistId = _playlist.id;
      });
      if (_songlist != null && _songlist.length > 0) {
        setState(() {
          _songslist = _songlist;
        });
      }
    }
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
                        child: Image.asset("assets/images/logo.jpg"),
                        duration: const Duration(milliseconds: imageMilli),
                      );
                    },
                  ),
                )),
            Container(
              //padding: EdgeInsets.only(left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: windowsWidth.value / 2,
                      padding: leftrightPadding,
                      child: Text(_albumsname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titleText1)),
                  Container(
                    padding: leftrightPadding,
                    child: Row(
                      children: [
                        MyTextButton(
                          press: () {
                            indexValue.value = 2;
                          },
                          title: "$playlistLocal",
                          isActive: false,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "创建人: " + _artist,
                          style: nomalGrayText,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: leftrightPadding,
                    child: Row(
                      children: [
                        Text(
                          "$songLocal: " + _songsnum.toString(),
                          style: nomalGrayText,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "$drationLocal: " + formatDuration(_duration),
                          style: nomalGrayText,
                        ),
                      ],
                    ),
                  ),
                  if (isMobile.value)
                    SizedBox(
                      height: 5,
                    ),
                  if (isMobile.value)
                    Container(
                      padding: leftrightPadding,
                      child: Row(
                        children: [
                          Text(
                            "$playCountLocal: " + _playCount.toString(),
                            style: nomalGrayText,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "$yearLocal: " + _year.toString(),
                            style: nomalGrayText,
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: leftrightPadding,
                    child: Row(
                      children: [
                        Text(
                          "修改日期: " + timeISOtoString(_changed),
                          style: nomalGrayText,
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
                                  titleTextStyle: nomalGrayText,
                                  contentTextStyle: nomalGrayText,
                                  backgroundColor: badgeDark,
                                  title: Text(
                                    "删除",
                                  ),
                                  content: Text(
                                    "是否删除" + _albumsname + "?",
                                  ),
                                  actions: <Widget>[
                                    MyTextButton(
                                      title: cancelLocal,
                                      isActive: false,
                                      press: () {
                                        Navigator.of(_context).pop();
                                      },
                                    ),
                                    MyTextButton(
                                      title: confirmLocal,
                                      isActive: false,
                                      press: () async {
                                        await deletePlaylist(_palylistId);
                                        await BaseDB.instance
                                            .delPlaylistById(_palylistId);
                                        Navigator.of(_context).pop();
                                        indexValue.value = 2;
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          title: "删除",
                          isActive: false,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderWidget() {
    List<String> _title = [
      songLocal,
      drationLocal,
      bitRangeLocal,
      playCountLocal
    ];
    return myRowList(_title, sublGrayText);
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
                    _song.bitRate.toString(),
                    _song.playCount.toString(),
                  ];
                  return ListTile(
                      title: InkWell(
                          onTap: () async {
                            activeSongValue.value = _song.id;
                            //歌曲所在专辑歌曲List
                            activeList.value = _songslist;
                            //当前歌曲队列
                            activeIndex.value = index;
                          },
                          child: ValueListenableBuilder<Map>(
                              valueListenable: activeSong,
                              builder: ((context, value, child) {
                                return myRowList(
                                    _title,
                                    (value.isNotEmpty &&
                                            value["value"] == _song.id)
                                        ? activeText
                                        : nomalGrayText);
                              }))));
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
            _buildHeaderWidget()
          ],
        ),
        contentWidget: _itemBuildWidget());
  }
}