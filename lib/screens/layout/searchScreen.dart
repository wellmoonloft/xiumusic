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
    final _songsList = await BaseDB.instance.getSongByName(_title1, _title2);
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
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _songs!.length,
            itemExtent: 50.0, //强制高度为50.0
            itemBuilder: (BuildContext context, int index) {
              Songs _tem = _songs![index];
              return ListTile(
                  title: InkWell(
                      onTap: () async {
                        activeSongValue.value = _tem.id;

                        //歌曲所在专辑歌曲List
                        activeList.value = _songs!;

                        //当前歌曲队列
                        activeIndex.value = index;

                        //拼装当前歌曲
                        Map _activeSong = new Map();
                        String _url = await getCoverArt(_tem.id);
                        _activeSong["value"] = _tem.id;
                        _activeSong["artist"] = _tem.artist;
                        _activeSong["url"] = _url;
                        _activeSong["title"] = _tem.title;
                        _activeSong["album"] = _tem.album;
                        _activeSong["albumId"] = _tem.albumId;
                        activeSong.value = _activeSong;
                      },
                      child: ValueListenableBuilder<Map>(
                          valueListenable: activeSong,
                          builder: ((context, value, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                if (!isMobile.value)
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
                                      _tem.bitRate.toString(),
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
            })
        : Container();
  }

  Widget _buildHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
        if (!isMobile.value)
          Expanded(
            flex: 1,
            child: Container(
                child: Text(
              drationLocal,
              textDirection: TextDirection.rtl,
              style: sublGrayText,
            )),
          ),
        if (!isMobile.value)
          Expanded(
            flex: 1,
            child: Container(
                child: Text(
              bitRangeLocal,
              textDirection: TextDirection.rtl,
              style: sublGrayText,
            )),
          ),
        if (!isMobile.value)
          Expanded(
            flex: 1,
            child: Container(
                child: Text(
              playCountLocal,
              textDirection: TextDirection.rtl,
              style: sublGrayText,
            )),
          )
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
