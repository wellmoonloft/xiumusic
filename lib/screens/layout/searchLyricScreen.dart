import 'package:flutter/material.dart';
import '../../models/notifierValue.dart';
import '../../util/baseDB.dart';
import '../../models/myModel.dart';
import '../../util/util.dart';
import '../common/baseCSS.dart';
import '../../util/httpClient.dart';
import '../../util/localizations.dart';
import '../common/myAlertDialog.dart';
import '../common/myLoadingDialog.dart';
import '../common/myTextInput.dart';
import '../common/myStructure.dart';
import '../common/textButtom.dart';

class SearchLyricScreen extends StatefulWidget {
  const SearchLyricScreen({Key? key}) : super(key: key);
  @override
  _SearchLyricScreenState createState() => _SearchLyricScreenState();
}

class _SearchLyricScreenState extends State<SearchLyricScreen>
    with SingleTickerProviderStateMixin {
  final searchController = new TextEditingController();
  final songController = new TextEditingController();
  final artistController = new TextEditingController();
  late TabController tabController;
  static const List<Tab> myTabs = <Tab>[
    Tab(text: '我的歌曲'),
    Tab(text: '云端歌曲'),
    Tab(text: '歌词'),
  ];
  List? _songs;
  List? _netsongs;
  List _isLyric = [];
  String _lyric = "";
  List<bool> _isChecked = [];

  _getSongsbyName() async {
    String _title1 = searchController.text;
    String _title2 = "";
    List<Songs> _list = [];
    _title2 = await converToTraditional(_title1);
    final _songsList = await BaseDB.instance.getSongByName(_title1, _title2);
    if (_songsList != null) {
      for (var element in _songsList) {
        Songs _tem = element;

        _list.add(_tem);

        final _lyric = await BaseDB.instance.getLyricById(_tem.id);
        if (_lyric != null && _lyric!.isNotEmpty) {
          _isLyric.add(true);
        } else {
          _isLyric.add(false);
        }
      }
      if (mounted) {
        setState(() {
          _songs = _list;
        });
      }
    }
  }

  @override
  initState() {
    super.initState();
    tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    searchController.dispose();
    artistController.dispose();
    songController.dispose();
    tabController.dispose();
    super.dispose();
  }

  findNetSong(Songs song) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('请确认查询信息'),
            children: <Widget>[
              MyTextInput(
                control: songController,
                label: "歌曲名",
                hintLabel: "请输入歌曲名...",
                hideText: false,
                icon: Icons.search,
                press: () {},
                titleStyle: nomalGrayText,
                mainaxis: MainAxisAlignment.start,
                crossaxis: CrossAxisAlignment.end,
              ),
              MyTextInput(
                control: artistController,
                label: "艺人名",
                hintLabel: "请输入艺人名...",
                hideText: false,
                icon: Icons.search,
                press: () {},
                titleStyle: nomalGrayText,
                mainaxis: MainAxisAlignment.start,
                crossaxis: CrossAxisAlignment.end,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButtom(
                    title: "取消",
                    isActive: false,
                    press: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButtom(
                    title: "搜索",
                    isActive: false,
                    press: () async {
                      var _result = await searchNeteasAPI(
                          songController.text + " " + artistController.text,
                          "1");
                      if (_result != null) {
                        var _netresult = _result["songs"];
                        setState(() {
                          _netsongs = _netresult;
                        });
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget _itemSongsWidget() {
    return (_netsongs != null && _netsongs!.length > 0)
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _netsongs!.length,
            itemExtent: 50.0, //强制高度为50.0
            itemBuilder: (BuildContext context, int index) {
              Map _tem = _netsongs![index];

              var _artistlist = _tem["artists"];
              Map _artist = _artistlist[0];

              return ListTile(
                  title: InkWell(
                      onTap: () async {
                        var _lyritem = await getLyric(_tem["id"].toString());
                        if (_lyritem != null) {
                          print(_lyritem);
                          setState(() {
                            _lyric = _lyritem;
                          });
                          tabController.animateTo(0);
                          showMyAlertDialog(context, "成功", "歌词下载成功，请检查并绑定");
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              _tem["name"],
                              textDirection: TextDirection.ltr,
                              style: nomalGrayText,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              _artist["name"],
                              textDirection: TextDirection.ltr,
                              style: nomalGrayText,
                            ),
                          ),
                        ],
                      )));
            })
        : Container();
  }

  Widget _itemBuildWidget() {
    return _songs != null && _songs!.length > 0
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _songs!.length,
            itemExtent: 50.0, //强制高度为50.0
            itemBuilder: (BuildContext context, int index) {
              Songs _tem = _songs![index];
              String _islyr = _isLyric[index] ? "有" : "无";
              _isChecked.add(false);

              return ListTile(
                  title: InkWell(
                      onTap: () async {
                        artistController.text = _tem.artist;
                        songController.text = _tem.title;
                        await findNetSong(_tem);
                        tabController.animateTo(1);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Checkbox(
                              value: _isChecked[index],
                              onChanged: (value) {
                                setState(() {
                                  _isChecked[index] = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              _islyr,
                              textDirection: TextDirection.ltr,
                              style: nomalGrayText,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              _tem.title,
                              textDirection: TextDirection.ltr,
                              style: nomalGrayText,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              _tem.album,
                              textDirection: TextDirection.rtl,
                              style: nomalGrayText,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              _tem.artist,
                              textDirection: TextDirection.rtl,
                              style: nomalGrayText,
                            ),
                          ),
                        ],
                      )));
            })
        : Container();
  }

  Widget _buildTopWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextInput(
          control: searchController,
          label: "搜索歌词",
          hintLabel: "请输入歌曲名...",
          hideText: false,
          icon: Icons.search,
          press: () {
            _getSongsbyName();
          },
          titleStyle: titleText1,
          mainaxis: MainAxisAlignment.start,
          crossaxis: CrossAxisAlignment.end,
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                child: (_songs != null && _songs!.length > 0)
                    ? Text("结果:" + _songs!.length.toString(),
                        style: nomalGrayText)
                    : Text("结果: 0", style: nomalGrayText)),
            TextButtom(
              isActive: false,
              title: "绑定歌词",
              press: () async {
                if (_lyric == "") {
                  showMyAlertDialog(context, "错误", "没有歌词");
                } else {
                  for (var i = 0; i < _isChecked.length; i++) {
                    if (_isChecked[i]) {
                      Songs _song = _songs![i];
                      SongsAndLyric _songsAndLyric =
                          SongsAndLyric(lyric: _lyric, songId: _song.id);
                      await BaseDB.instance
                          .addSongsAndLyricTable(_songsAndLyric);
                      showMyAlertDialog(context, "成功", "绑定成功");
                    }
                  }
                }
              },
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 140,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
            //SizedBox(height: 20),
            Container(
                alignment: Alignment.topLeft,
                child: TabBar(
                    controller: tabController,
                    labelColor: kGrayColor,
                    unselectedLabelColor: borderColor,
                    tabs: myTabs,
                    isScrollable: true,
                    indicatorColor: badgeDark)),
          ],
        ),
        contentWidget: TabBarView(controller: tabController, children: [
          _itemBuildWidget(),
          _itemSongsWidget(),
          Container(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  _lyric,
                  style: nomalGrayText,
                )),
          )
        ]));
  }
}
