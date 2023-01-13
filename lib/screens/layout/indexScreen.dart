import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/baseDB.dart';
import '../../util/httpClient.dart';
import '../../util/localizations.dart';
import '../../util/util.dart';
import '../common/baseCSS.dart';
import '../common/mySliverControlBar.dart';
import '../common/mySliverControlList.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({Key? key}) : super(key: key);
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  ScrollController _lastSongcontroller = ScrollController();
  ScrollController _lastAlbumcontroller = ScrollController();
  ScrollController _randomAlbumcontroller = ScrollController();
  List<Albums>? _albums;
  List<String>? _imageURL;
  List<Albums>? _lastalbums;
  List<String>? _lastimageURL;
  List<Songs>? _songs;

  _getRandomAlbums() async {
    final _albumsList = await BaseDB.instance.getAllAlbums();
    List<Albums> _list = [];
    List<String> _listURL = [];
    List<int> _indexList = [];
    int _count = 0;
    while (_count < 10) {
      int _index = Random().nextInt(_albumsList.length);
      if (!_indexList.contains(_index)) {
        _indexList.add(_index);
        _count++;
      }
    }

    for (var element in _indexList) {
      Albums _xx = _albumsList[element];
      String _yy = await getCoverArt(_xx.id);
      _list.add(_xx);
      _listURL.add(_yy);
    }
    if (mounted) {
      setState(() {
        _albums = _list;
        _imageURL = _listURL;
      });
    }
  }

  _getLastAlbums() async {
    final _albumsList = await BaseDB.instance.getAlbumsByOrder(1);
    List<Albums> _list = [];
    List<String> _listURL = [];

    for (var element in _albumsList) {
      Albums _xx = element;
      String _yy = await getCoverArt(_xx.id);
      _list.add(_xx);
      _listURL.add(_yy);
    }
    if (mounted) {
      setState(() {
        _lastalbums = _list;
        _lastimageURL = _listURL;
      });
    }
  }

  _getRandomSongs() async {
    final _songsList = await BaseDB.instance.getSongsByOrder(0);
    List<Songs> _list = [];
    List<String> _listURL = [];

    for (var element in _songsList) {
      Songs _xx = element;
      String _yy = await getCoverArt(_xx.id);
      _list.add(_xx);
      _listURL.add(_yy);
    }
    if (mounted) {
      setState(() {
        _songs = _list;
      });
    }
  }

  @override
  initState() {
    super.initState();
    _getRandomAlbums();
    _getLastAlbums();
    _getRandomSongs();
  }

  @override
  void dispose() {
    _lastSongcontroller.dispose();
    _lastAlbumcontroller.dispose();
    _randomAlbumcontroller.dispose();
    super.dispose();
  }

  //TODO 数据库：新增歌曲10，接口：歌手热歌getTopSongs，星标？
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
              padding: leftrightPadding,
              child: Text(indexLocal, style: titleText1)),
        ),
        if (_albums != null && _albums!.length > 0)
          SliverToBoxAdapter(
              child: MySliverControlBar(
            title: "随机专辑",
            controller: _randomAlbumcontroller,
          )),
        if (_albums != null && _albums!.length > 0)
          SliverToBoxAdapter(
              child: MySliverControlList(
            controller: _randomAlbumcontroller,
            albums: _albums!,
            url: _imageURL!,
          )),
        if (_songs != null && _songs!.length > 0)
          SliverToBoxAdapter(
              child: Container(
            padding: allPadding,
            child: Text(
              "最多播放歌曲",
              style: titleText2,
            ),
          )),
        if (_songs != null && _songs!.length > 0)
          SliverList(
            delegate: SliverChildBuilderDelegate((content, index) {
              Songs _tem = _songs![index];
              return Container(
                  padding: leftrightPadding,
                  height: 50,
                  alignment: Alignment.center,
                  child: InkWell(
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
            }, childCount: _songs!.length),
          ),
        if (_lastalbums != null && _lastalbums!.length > 0)
          SliverToBoxAdapter(
              child: MySliverControlBar(
            title: "最近添加专辑",
            controller: _lastAlbumcontroller,
          )),
        if (_lastalbums != null && _lastalbums!.length > 0)
          SliverToBoxAdapter(
            child: MySliverControlList(
              controller: _lastAlbumcontroller,
              albums: _lastalbums!,
              url: _lastimageURL!,
            ),
          ),
      ],
    );
  }
}
