import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/dbProvider.dart';
import '../../util/localizations.dart';
import '../../util/mycss.dart';
import '../common/mySliverControlBar.dart';
import '../common/mySliverControlList.dart';

class IndexScreen extends StatefulWidget {
  final AudioPlayer player;
  const IndexScreen({Key? key, required this.player}) : super(key: key);
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  ScrollController _lastSongcontroller = ScrollController();
  ScrollController _lastAlbumcontroller = ScrollController();
  ScrollController _randomAlbumcontroller = ScrollController();
  List<Albums>? _albums;
  List<Albums>? _lastalbums;
  List<Songs>? _songs;

  _getRandomAlbums() async {
    final _albumsList = await DbProvider.instance.getAllAlbums();
    List<Albums> _list = [];
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
      _list.add(_xx);
    }
    if (mounted) {
      setState(() {
        _albums = _list;
      });
    }
  }

  _getLastAlbums() async {
    final _albumsList = await DbProvider.instance.getAlbumsByOrder(1);
    List<Albums> _list = [];

    for (var element in _albumsList) {
      Albums _xx = element;
      _list.add(_xx);
    }
    if (mounted) {
      setState(() {
        _lastalbums = _list;
      });
    }
  }

  _getRandomSongs() async {
    final _songsList = await DbProvider.instance.getSongsByOrder(0);
    List<Songs> _list = [];

    for (var element in _songsList) {
      Songs _xx = element;
      _list.add(_xx);
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
                  controller: _randomAlbumcontroller, albums: _albums!)),
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
              List<String> _title = [
                _tem.title,
                _tem.album,
                _tem.artist,
                _tem.playCount.toString(),
              ];
              return Container(
                  padding: leftrightPadding,
                  height: 50,
                  alignment: Alignment.center,
                  child: InkWell(
                      onTap: () async {
                        if (listEquals(activeList.value, _songs!)) {
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
                                (value.isNotEmpty && value["value"] == _tem.id)
                                    ? activeText
                                    : nomalText);
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
                controller: _lastAlbumcontroller, albums: _lastalbums!),
          ),
      ],
    );
  }
}
