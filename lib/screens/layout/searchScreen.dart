import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../generated/l10n.dart';
import '../../models/notifierValue.dart';
import '../../models/myModel.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';
import '../../util/mycss.dart';
import '../common/myTextInput.dart';
import '../common/myStructure.dart';

class SearchScreen extends StatefulWidget {
  final AudioPlayer player;
  const SearchScreen({Key? key, required this.player}) : super(key: key);
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
                    if (!isMobile)
                      _tem.suffix + "(" + _tem.bitRate.toString() + ")",
                    if (!isMobile) _tem.playCount.toString(),
                  ];
                  return ListTile(
                      title: InkWell(
                          onTap: () async {
                            if (listEquals(activeList.value, _songs)) {
                              widget.player.seek(Duration.zero, index: index);
                            } else {
                              //当前歌曲队列
                              activeIndex.value = index;
                              activeSongValue.value = _tem.id;
                              //歌曲所在专辑歌曲List
                              activeList.value = _songs!;
                            }
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
      S.of(context).song,
      S.of(context).album,
      S.of(context).artist,
      if (!isMobile) S.of(context).dration,
      if (!isMobile) S.of(context).bitRange,
      if (!isMobile) S.of(context).playCount
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
          label: S.of(context).search,
          hintLabel: S.of(context).pleaseInput +
              S.of(context).song +
              S.of(context).name,
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
                ? Text(S.of(context).result + ":" + _songs!.length.toString(),
                    style: nomalText)
                : Text(S.of(context).result + ": 0", style: nomalText)),
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
