import 'package:flutter/material.dart';
import 'package:xiumusic/screens/common/myTextButton.dart';
import 'package:xiumusic/screens/common/myTextInput.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/baseDB.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';
import '../common/baseCSS.dart';
import '../common/myAlertDialog.dart';
import '../common/myStructure.dart';
import '../common/myToast.dart';

class PlayListScreen1 extends StatefulWidget {
  const PlayListScreen1({Key? key}) : super(key: key);
  @override
  _PlayListScreenState createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen1> {
  final inputController = new TextEditingController();
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

  Widget _newDialog() {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: UnconstrainedBox(
            child: Container(
          width: 250,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: badgeDark,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 200,
                    height: 35,
                    margin: EdgeInsets.all(5),
                    child: TextField(
                      controller: inputController,
                      style: nomalGrayText,
                      cursorColor: kGrayColor,
                      onSubmitted: (value) {},
                      decoration: InputDecoration(
                          hintText: "请输入播放列表名称...",
                          labelStyle: nomalGrayText,
                          border: InputBorder.none,
                          hintStyle: nomalGrayText,
                          filled: true,
                          fillColor: badgeDark,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10.0),
                          prefixIcon: Icon(
                            Icons.edit_note,
                            color: kGrayColor,
                            size: 14,
                          )),
                    )),
                SizedBox(
                  height: 10,
                ),
                MyTextButton(
                  isActive: false,
                  press: () async {
                    // if (inputController.text.isNotEmpty) {
                    //   var _response =
                    //       await createPlaylist(0, inputController.text, "");
                    //   if (_response != null && _response["status"] == "ok") {
                    //     var _playlist = _response["playlist"];
                    //     Playlist _tem = Playlist(
                    //       changed: _playlist["changed"],
                    //       created: _playlist["created"],
                    //       duration: _playlist["duration"],
                    //       id: _playlist["id"],
                    //       name: _playlist["name"],
                    //       owner: _playlist["owner"],
                    //       public: _playlist["public"] ? 0 : 1,
                    //       songCount: _playlist["songCount"],
                    //     );
                    //     await BaseDB.instance.addPlaylists(_tem);
                    //     showMyAlertDialog(context, "成功", "新建成功");
                    //   } else {
                    //     showMyAlertDialog(context, "失败", "新建失败");
                    //   }
                    // } else {
                    //   showMyAlertDialog(context, "提示", "请输入列表名称");
                    // }
                  },
                  title: '创建',
                )
              ],
            ),
          ),
        )));
  }

  @override
  initState() {
    super.initState();
    _getPlaylist();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  Widget _playlistBuildWidget() {
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
                Container(
                  padding: EdgeInsets.all(15),
                  child: MyTextButton(
                    isActive: false,
                    press: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (_context) {
                          return _newDialog();
                        },
                      );
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
