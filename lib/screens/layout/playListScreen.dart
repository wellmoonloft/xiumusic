import 'package:flutter/material.dart';
import 'package:xiumusic/screens/common/myTextButton.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/baseDB.dart';
import '../../util/util.dart';
import '../common/baseCSS.dart';
import '../common/myStructure.dart';
import '../common/myToast.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({Key? key}) : super(key: key);
  @override
  _PlayListScreenState createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  List<DropdownMenuItem<String>> _sortItems = [];
  String _selectedSort = '';
  List _songs = [];
  bool isInit = false;

  _getPlaylist() async {
    final _playlists = await BaseDB.instance.getPlaylists();
    if (_playlists != null && _playlists.length > 0) {
      for (var i = 0; i < _playlists.length; i++) {
        Playlist _playlist = _playlists[i];
        _sortItems.add(
            DropdownMenuItem(value: _playlist.id, child: Text(_playlist.name)));
        if (i == 0) {
          _selectedSort = _playlist.id;
          _getSongs(_playlist.id);
        }
      }
      setState(() {
        isInit = true;
      });
    }
  }

  _getSongs(String _playlistId) async {
    final _playlist1 = await BaseDB.instance.getPlaylistSongs(_playlistId);

    List<Songs> _songsList = _playlist1;

    if (_songsList.length > 0) {
      if (mounted) {
        setState(() {
          _songs = _songsList;
        });
      }
    }
  }

  @override
  initState() {
    super.initState();
    _getPlaylist();
  }

  Widget _itemBuildWidget() {
    return _songs.length > 0
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _songs.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  Songs _tem = _songs[index];
                  List<String> _title = [
                    _tem.title,
                    _tem.album,
                    _tem.artist,
                    formatDuration(_tem.duration),
                    if (!isMobile.value) _tem.playCount.toString(),
                  ];
                  return ListTile(
                      title: InkWell(
                          onTap: () async {
                            activeSongValue.value = _tem.id;
                            //歌曲所在专辑歌曲List
                            activeList.value = _songs;
                            //当前歌曲队列
                            activeIndex.value = index;
                          },
                          child: ValueListenableBuilder<Map>(
                              valueListenable: activeSong,
                              builder: ((context, value, child) {
                                return myRowList(
                                    _title,
                                    (value.isNotEmpty &&
                                            value["value"] == _tem.id)
                                        ? activeText
                                        : nomalGrayText);
                              }))));
                }))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 110,
        headerWidget: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: Text("播放列表", style: titleText1),
                ),
                Container(
                  child: Text(
                    "列表歌曲: " + _songs.length.toString(),
                    style: nomalGrayText,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: circularBorder,
                  padding:
                      EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
                  width: 200,
                  height: 35,
                  child: isInit
                      ? Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: rightColor,
                          ),
                          // DropdownButtonHideUnderline 没有下划线的下拉栏
                          child: DropdownButton(
                            value: _selectedSort,
                            items: _sortItems,
                            isDense: true,
                            isExpanded: true,
                            underline: Container(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSort = value.toString();
                                _getSongs(value.toString());
                              });
                            },
                          ))
                      : Container(),
                ),
                //TODO 新增播放列表
                Container(
                  padding: EdgeInsets.all(15),
                  child: MyTextButton(
                    isActive: false,
                    press: () {
                      showMenu(
                          context: context,
                          position: RelativeRect.fill,
                          items: <PopupMenuEntry>[
                            PopupMenuItem(child: Text('语文')),
                            PopupMenuDivider(),
                            CheckedPopupMenuItem(
                              child: Text('数学'),
                              checked: true,
                            ),
                            PopupMenuDivider(),
                            PopupMenuItem(child: Text('英语')),
                          ]);
                    },
                    title: '新建',
                  ),
                ),

                IconButton(
                  icon: Icon(
                    Icons.playlist_add_check,
                    color: kTextColor,
                    size: 16,
                  ),
                  onPressed: () {
                    MyToast.show(context: context, message: "message");
                  },
                )
              ],
            ),
          ],
        ),
        contentWidget: _itemBuildWidget());
  }
}
