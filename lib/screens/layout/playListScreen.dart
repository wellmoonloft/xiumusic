import 'package:flutter/material.dart';
import 'package:xiumusic/screens/common/textButtom.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/baseDB.dart';
import '../../util/util.dart';
import '../common/baseCSS.dart';
import '../common/myStructure.dart';

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
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _tem.title,
                                        textDirection: TextDirection.ltr,
                                        style: (value.isNotEmpty &&
                                                value["value"] == _tem.id)
                                            ? activeText
                                            : nomalGrayText,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _tem.album,
                                        textDirection: TextDirection.ltr,
                                        style: (value.isNotEmpty &&
                                                value["value"] == _tem.id)
                                            ? activeText
                                            : nomalGrayText,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        _tem.artist,
                                        textDirection: TextDirection.rtl,
                                        style: (value.isNotEmpty &&
                                                value["value"] == _tem.id)
                                            ? activeText
                                            : nomalGrayText,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        formatDuration(_tem.duration),
                                        textDirection: TextDirection.rtl,
                                        style: (value.isNotEmpty &&
                                                value["value"] == _tem.id)
                                            ? activeText
                                            : nomalGrayText,
                                      ),
                                    ),
                                    if (!isMobile.value)
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          _tem.playCount.toString(),
                                          textDirection: TextDirection.rtl,
                                          style: (value.isNotEmpty &&
                                                  value["value"] == _tem.id)
                                              ? activeText
                                              : nomalGrayText,
                                        ),
                                      ),
                                  ],
                                );
                              }))));
                }))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 120,
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
                      ? DropdownButton(
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
                        )
                      : Container(),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: TextButtom(
                    isActive: false,
                    press: () {},
                    title: '新建',
                  ),
                )
              ],
            ),
          ],
        ),
        contentWidget: _itemBuildWidget());
  }
}
