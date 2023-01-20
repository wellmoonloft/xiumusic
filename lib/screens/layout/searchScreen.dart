import 'package:flutter/material.dart';
import '../../models/notifierValue.dart';
import '../../util/dbProvider.dart';
import '../../models/myModel.dart';
import '../../util/util.dart';
import '../../util/mycss.dart';
import '../../util/localizations.dart';
import '../common/myTextInput.dart';
import '../common/myStructure.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = new TextEditingController();
  List? _songs;

  _getSongsbyName() async {
    String _title1 = searchController.text;
    String _title2 = "";
    List<Songs> _list = [];
    _title2 = await converToTraditional(_title1);
    final _songsList =
        await DbProvider.instance.getSongByName(_title1, _title2);
    if (_songsList != null) {
      for (var element in _songsList) {
        Songs _tem = element;
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
    //print("object");
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                  List<String> _title = [
                    _tem.title,
                    _tem.album,
                    _tem.artist,
                    if (!isMobile) formatDuration(_tem.duration),
                    if (!isMobile) _tem.bitRate.toString(),
                    if (!isMobile) _tem.playCount.toString(),
                  ];
                  return ListTile(
                      title: InkWell(
                          onTap: () async {
                            activeSongValue.value = _tem.id;
                            //歌曲所在专辑歌曲List
                            activeList.value = _songs!;
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
                                        : nomalText);
                              }))));
                }))
        : Container();
  }

  Widget _buildHeaderWidget() {
    List<String> _title = [
      songLocal,
      albumLocal,
      artistLocal,
      if (!isMobile) drationLocal,
      if (!isMobile) bitRangeLocal,
      if (!isMobile) playCountLocal
    ];
    return myRowList(_title, subText);
  }

  Widget _buildTopWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextInput(
          control: searchController,
          label: searchLocal,
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
                ? Text("结果:" + _songs!.length.toString(), style: nomalText)
                : Text("结果: 0", style: nomalText)),
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
