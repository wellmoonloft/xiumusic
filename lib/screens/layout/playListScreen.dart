import 'package:flutter/material.dart';
import 'package:xiumusic/screens/common/myTextButton.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/baseDB.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';
import '../common/baseCSS.dart';
import '../common/myAlertDialog.dart';
import '../common/myStructure.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({Key? key}) : super(key: key);
  @override
  _PlayListScreenState createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  final inputController = new TextEditingController();

  List<Playlist> _playlistsList = [];
  int _playlistnum = 0;

  _getPlaylist() async {
    final _playlists = await BaseDB.instance.getPlaylists();
    _playlistsList.clear();
    if (_playlists != null && _playlists.length > 0) {
      for (var element in _playlists) {
        Playlist _playlist = element;
        _playlistsList.add(_playlist);
      }
      setState(() {
        _playlistnum = _playlistsList.length;
      });
    }
  }

  Future<int> _newDialog() async {
    var sss = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: UnconstrainedBox(
                  child: Container(
                width: 250,
                height: 120,
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
                      Container(
                        padding: allPadding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyTextButton(
                              isActive: false,
                              press: () async {
                                Navigator.of(context).pop(3);
                              },
                              title: '取消',
                            ),
                            MyTextButton(
                              isActive: false,
                              press: () async {
                                if (inputController.text.isNotEmpty) {
                                  var _response = await createPlaylist(
                                      0, inputController.text, "");
                                  if (_response != null &&
                                      _response["status"] == "ok") {
                                    var _playlist = _response["playlist"];
                                    String _url =
                                        await getCoverArt(_playlist['id']);
                                    Playlist _tem = Playlist(
                                        changed: _playlist["changed"],
                                        created: _playlist["created"],
                                        duration: _playlist["duration"],
                                        id: _playlist["id"],
                                        name: _playlist["name"],
                                        owner: _playlist["owner"],
                                        public: _playlist["public"] ? 0 : 1,
                                        songCount: _playlist["songCount"],
                                        imageUrl: _url);
                                    await BaseDB.instance.addPlaylists(_tem);

                                    Navigator.of(context).pop(0);
                                  } else {
                                    Navigator.of(context).pop(1);
                                  }
                                } else {
                                  Navigator.of(context).pop(2);
                                }
                              },
                              title: '创建',
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )));
        });
    return sss;
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
    return _playlistsList.length > 0
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _playlistsList.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  Playlist _tem = _playlistsList[index];
                  List<String> _title = [
                    _tem.name,
                    _tem.songCount.toString(),
                    _tem.owner,
                    timeISOtoString(_tem.changed)
                  ];
                  return ListTile(
                      title: InkWell(
                          onTap: () async {
                            activeID.value = _tem.id;
                            indexValue.value = 12;
                          },
                          child: ValueListenableBuilder<Map>(
                              valueListenable: activeSong,
                              builder: ((context, value, child) {
                                return myRowList(_title, nomalGrayText);
                              }))));
                }))
        : Container();
  }

  Widget _buildHeaderWidget() {
    List<String> _title = ["名称", "歌曲数", "创建人", "修改时间"];
    return myRowList(_title, sublGrayText);
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 100,
        headerWidget: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: Text("播放列表", style: titleText1),
                ),
                Row(
                  children: [
                    MyTextButton(
                      isActive: false,
                      press: () async {
                        await _newDialog().then((value) {
                          _getPlaylist();
                          switch (value) {
                            case 0:
                              showMyAlertDialog(context, "成功", "新建成功");
                              break;
                            case 1:
                              showMyAlertDialog(context, "失败", "新建失败");
                              break;
                            case 2:
                              showMyAlertDialog(context, "提示", "请输入列表名称");
                              break;
                            case 3:
                              break;
                            default:
                              showMyAlertDialog(context, "成功", "新建成功");
                          }
                        });
                      },
                      title: '新建',
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      child: Text(
                        "播放列表: " + _playlistnum.toString(),
                        style: nomalGrayText,
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _buildHeaderWidget(),
          ],
        ),
        contentWidget: _playlistBuildWidget());
  }
}
