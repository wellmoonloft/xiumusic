import 'package:flutter/material.dart';
import '../../models/notifierValue.dart';
import '../../util/baseDB.dart';
import '../../models/myModel.dart';
import '../../util/util.dart';
import '../common/baseCSS.dart';
import '../../util/httpClient.dart';
import '../../util/localizations.dart';
import '../common/myTextInput.dart';
import '../common/myStructure.dart';
import '../common/textButtom.dart';

class SearchLyricScreen extends StatefulWidget {
  const SearchLyricScreen({Key? key}) : super(key: key);
  @override
  _SearchLyricScreenState createState() => _SearchLyricScreenState();
}

class _SearchLyricScreenState extends State<SearchLyricScreen> {
  final searchController = new TextEditingController();
  final songController = new TextEditingController();
  final artistController = new TextEditingController();
  List? _songs;
  List _isLyric = [];

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
    //print("object");
  }

  @override
  void dispose() {
    searchController.dispose();
    artistController.dispose();
    songController.dispose();
    super.dispose();
  }

  Future<void> changeLanguage(Songs song) async {
    int? i = await showDialog<int>(
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
                      Navigator.pop(context, 1);
                    },
                  ),
                  TextButtom(
                    title: "搜索",
                    isActive: false,
                    press: () async {
                      final _lric = await getLyric(
                          songController.text + " " + artistController.text);
                      if (_lric != null && _lric != "") {
                        SongsAndLyric _songandlyric =
                            SongsAndLyric(lyric: _lric, songId: song.id);
                        await BaseDB.instance
                            .addSongsAndLyricTable(_songandlyric);
                      }
                      Navigator.pop(context, 1);
                    },
                  )
                ],
              )
            ],
          );
        });

    if (i != null) {
      print("选择了：${i == 1 ? "中文简体" : "美国英语"}");
    }
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
              String _xx = _isLyric[index] ? "有" : "无";
              return ListTile(
                  title: InkWell(
                      onTap: () async {
                        artistController.text = _tem.artist;
                        songController.text = _tem.title;
                        changeLanguage(_tem);
                      },
                      child: ValueListenableBuilder<Map>(
                          valueListenable: activeSong,
                          builder: ((context, value, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _xx,
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
                                    _tem.artist,
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
            })
        : Container();
  }

  Widget _buildHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              child: Text(
                "歌词",
                textDirection: TextDirection.ltr,
                style: sublGrayText,
              ),
            )),
        Expanded(
            flex: 2,
            child: Container(
              child: Text(
                songLocal,
                textDirection: TextDirection.ltr,
                style: sublGrayText,
              ),
            )),
        Expanded(
          flex: 2,
          child: Container(
              child: Text(
            albumLocal,
            textDirection: TextDirection.rtl,
            style: sublGrayText,
          )),
        ),
        Expanded(
          flex: 1,
          child: Container(
              child: Text(
            artistLocal,
            textDirection: TextDirection.rtl,
            style: sublGrayText,
          )),
        ),
      ],
    );
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
        Container(
            child: (_songs != null && _songs!.length > 0)
                ? Text("结果:" + _songs!.length.toString(), style: nomalGrayText)
                : Text("结果: 0", style: nomalGrayText)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
      top: 125,
      headerWidget: Column(
        children: [
          _buildTopWidget(),
          SizedBox(height: 20),
          _buildHeaderWidget()
        ],
      ),
      contentWidget: _itemBuildWidget(),
    );
  }
}
