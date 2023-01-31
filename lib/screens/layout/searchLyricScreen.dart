import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../models/notifierValue.dart';
import '../../util/dbProvider.dart';
import '../../models/myModel.dart';
import '../../util/util.dart';
import '../../util/mycss.dart';
import '../../util/httpClient.dart';
import '../common/myAlertDialog.dart';
import '../common/myLoadingDialog.dart';
import '../common/myTextInput.dart';
import '../common/myStructure.dart';
import '../common/myTextButton.dart';

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
  late List<Tab> myTabs;
  List? _songs;
  List? _netsongs;
  String _lyric = "";
  List<bool> _isChecked = [];

  _getSongsbyName() async {
    String _title1 = searchController.text;
    String _title2 = "";
    List<Songs> _list = [];
    _title2 = await converToTraditional(_title1);
    final _songsList = await search3(_title1);
    final _songsList2 = await search3(_title2);
    if (_songsList["song"] != null) {
      for (var _element in _songsList["song"]) {
        String _stream = getServerInfo("stream");
        String _url = await getCoverArt(_element["id"]);
        _element["stream"] = _stream + '&id=' + _element["id"];
        _element["coverUrl"] = _url;
        Songs _tem = Songs.fromJson(_element);
        _list.add(_tem);
      }
      if (mounted) {
        setState(() {
          _songs = _list;
        });
      }
    }
    if (_songsList2["song"] != null) {
      for (var _element in _songsList2["song"]) {
        String _stream = getServerInfo("stream");
        String _url = await getCoverArt(_element["id"]);
        _element["stream"] = _stream + '&id=' + _element["id"];
        _element["coverUrl"] = _url;
        Songs _tem = Songs.fromJson(_element);
        _list.add(_tem);
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
    myTabs = <Tab>[
      Tab(text: S.current.my + S.current.song),
      Tab(text: S.current.net + S.current.song),
      Tab(text: S.current.lyric),
    ];
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
            backgroundColor: rightColor,
            title: Text(S.current.confrim + S.current.search + S.current.info,
                style: nomalText),
            contentPadding: EdgeInsets.only(left: 20, bottom: 20),
            children: <Widget>[
              MyTextInput(
                control: songController,
                label: S.current.song + S.current.name,
                hintLabel:
                    S.current.pleaseInput + S.current.song + S.current.name,
                hideText: false,
                icon: Icons.search,
                press: () {},
                titleStyle: nomalText,
                mainaxis: MainAxisAlignment.start,
                crossaxis: CrossAxisAlignment.center,
              ),
              MyTextInput(
                control: artistController,
                label: S.current.artist + S.current.name,
                hintLabel:
                    S.current.pleaseInput + S.current.artist + S.current.name,
                hideText: false,
                icon: Icons.search,
                press: () {},
                titleStyle: nomalText,
                mainaxis: MainAxisAlignment.start,
                crossaxis: CrossAxisAlignment.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyTextButton(
                    title: S.current.cancel,
                    press: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MyTextButton(
                    title: S.current.search,
                    press: () async {
                      showMyLoadingDialog(context, S.current.search + "...");
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
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _netsongs!.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  //别妄想拿时间了，搜索接口里面的是专辑的时间
                  Map _tem = _netsongs![index];
                  var _artistlist = _tem["artists"];
                  Map _artist = _artistlist[0];
                  return ListTile(
                      title: InkWell(
                          onTap: () async {
                            showMyLoadingDialog(
                                context, S.current.search + "...");
                            var _lyritem =
                                await getLyric(_tem["id"].toString());
                            Navigator.pop(context);
                            if (_lyritem != null) {
                              setState(() {
                                _lyric = _lyritem;
                              });
                              tabController.animateTo(0);
                              showMyAlertDialog(context, S.current.success,
                                  S.current.lyricDownloadSuccess);
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
                                  style: nomalText,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  _artist["name"],
                                  textDirection: TextDirection.ltr,
                                  style: nomalText,
                                ),
                              ),
                            ],
                          )));
                }))
        : Container();
  }

  Widget _itemBuildWidget() {
    return _songs != null && _songs!.length > 0
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _songs!.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  Songs _tem = _songs![index];

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
                                  activeColor: badgeRed,
                                  onChanged: (value) {
                                    setState(() {
                                      _isChecked[index] = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  _tem.title,
                                  textDirection: TextDirection.ltr,
                                  style: nomalText,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  _tem.album,
                                  textDirection: TextDirection.rtl,
                                  style: nomalText,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  _tem.artist,
                                  textDirection: TextDirection.rtl,
                                  style: nomalText,
                                ),
                              ),
                            ],
                          )));
                }))
        : Container();
  }

  Widget _buildTopWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextInput(
          control: searchController,
          label: S.current.search + S.current.lyric,
          hintLabel: S.current.pleaseInput + S.current.song + S.current.name,
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
                    ? Text(S.current.result + ":" + _songs!.length.toString(),
                        style: nomalText)
                    : Text(S.current.result + ": 0", style: nomalText)),
            MyTextButton(
              title: S.current.binding + S.current.lyric,
              press: () async {
                if (_lyric == "") {
                  showMyAlertDialog(context, S.current.notive,
                      S.current.no + S.current.lyric);
                } else {
                  for (var i = 0; i < _isChecked.length; i++) {
                    if (_isChecked[i]) {
                      Songs _song = _songs![i];
                      SongsAndLyric _songsAndLyric =
                          SongsAndLyric(lyric: _lyric, songId: _song.id);
                      await DbProvider.instance
                          .addSongsAndLyricTable(_songsAndLyric);
                      if (_song.id == activeSong.value["value"]) {
                        activeLyric.value = _lyric;
                      }
                    }
                  }
                  showMyAlertDialog(context, S.current.success,
                      S.current.binding + S.current.success);
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
        top: 138,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
            //SizedBox(height: 20),
            Container(
                alignment: Alignment.topLeft,
                child: TabBar(
                    controller: tabController,
                    labelColor: textGray,
                    unselectedLabelColor: borderColor,
                    tabs: myTabs,
                    isScrollable: true,
                    indicatorColor: badgeRed)),
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
                  style: nomalText,
                )),
          )
        ]));
  }
}
