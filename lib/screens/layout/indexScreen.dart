import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../util/httpClient.dart';
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
  ScrollController _recentAlbumscontroller = ScrollController();
  ScrollController _lastAlbumcontroller = ScrollController();
  ScrollController _randomAlbumcontroller = ScrollController();
  ScrollController _mostAlbumscontroller = ScrollController();
  List<Albums>? _randomalbums;
  List<Albums>? _lastalbums;
  List<Albums>? _mostalbums;
  List<Albums>? _recentalbums;

  _getRandomAlbums() async {
    final _albumsList = await getAlbumList("random", "", 0, 10);
    List<Albums> _list = [];
    if (_albumsList != null && _albumsList.length > 0) {
      for (var _element in _albumsList) {
        String _url = getCoverArt(_element["id"]);
        _element["coverUrl"] = _url;
        Albums _album = Albums.fromJson(_element);
        _list.add(_album);
      }
      if (mounted) {
        setState(() {
          _randomalbums = _list;
        });
      }
    }
  }

  _getMostAlbums() async {
    final _albumsList = await getAlbumList("frequent", "", 0, 10);
    List<Albums> _list = [];
    if (_albumsList != null && _albumsList.length > 0) {
      for (var _element in _albumsList) {
        String _url = getCoverArt(_element["id"]);
        _element["coverUrl"] = _url;
        Albums _album = Albums.fromJson(_element);
        _list.add(_album);
      }
      if (mounted) {
        setState(() {
          _mostalbums = _list;
        });
      }
    }
  }

  _getLastAlbums() async {
    final _albumsList = await getAlbumList("newest", "", 0, 10);
    List<Albums> _list = [];
    if (_albumsList != null && _albumsList.length > 0) {
      for (var _element in _albumsList) {
        String _url = getCoverArt(_element["id"]);
        _element["coverUrl"] = _url;
        Albums _album = Albums.fromJson(_element);
        _list.add(_album);
      }
      if (mounted) {
        setState(() {
          _lastalbums = _list;
        });
      }
    }
  }

  _getrecentAlbums() async {
    final _albumsList = await getAlbumList("recent", "", 0, 10);
    List<Albums> _list = [];
    if (_albumsList != null && _albumsList.length > 0) {
      for (var _element in _albumsList) {
        String _url = getCoverArt(_element["id"]);
        _element["coverUrl"] = _url;
        Albums _album = Albums.fromJson(_element);
        _list.add(_album);
      }
      if (mounted) {
        setState(() {
          _recentalbums = _list;
        });
      }
    }
  }

  @override
  initState() {
    super.initState();
    _getRandomAlbums();
    _getMostAlbums();
    _getrecentAlbums();
    _getLastAlbums();
  }

  @override
  void dispose() {
    _recentAlbumscontroller.dispose();
    _lastAlbumcontroller.dispose();
    _randomAlbumcontroller.dispose();
    _mostAlbumscontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
              padding: leftrightPadding,
              child: Text(S.of(context).index, style: titleText1)),
        ),
        if (_randomalbums != null && _randomalbums!.length > 0)
          SliverToBoxAdapter(
              child: MySliverControlBar(
            title: S.of(context).random + S.of(context).album,
            controller: _randomAlbumcontroller,
          )),
        if (_randomalbums != null && _randomalbums!.length > 0)
          SliverToBoxAdapter(
              child: MySliverControlList(
                  controller: _randomAlbumcontroller, albums: _randomalbums!)),
        if (_mostalbums != null && _mostalbums!.length > 0)
          SliverToBoxAdapter(
              child: MySliverControlBar(
            title:
                S.of(context).play + S.of(context).most + S.of(context).album,
            controller: _mostAlbumscontroller,
          )),
        if (_mostalbums != null && _mostalbums!.length > 0)
          SliverToBoxAdapter(
              child: MySliverControlList(
                  controller: _mostAlbumscontroller, albums: _mostalbums!)),
        if (_recentalbums != null && _recentalbums!.length > 0)
          SliverToBoxAdapter(
              child: MySliverControlBar(
            title:
                S.of(context).last + S.of(context).play + S.of(context).album,
            controller: _recentAlbumscontroller,
          )),
        if (_recentalbums != null && _recentalbums!.length > 0)
          SliverToBoxAdapter(
              child: MySliverControlList(
                  controller: _recentAlbumscontroller, albums: _recentalbums!)),
        if (_lastalbums != null && _lastalbums!.length > 0)
          SliverToBoxAdapter(
              child: MySliverControlBar(
            title: S.of(context).last + S.of(context).add + S.of(context).album,
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
