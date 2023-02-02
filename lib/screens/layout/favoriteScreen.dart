import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/httpClient.dart';
import '../../util/mycss.dart';
import '../../util/util.dart';
import '../common/myStructure.dart';
import '../common/myToast.dart';

class FavoriteScreen extends StatefulWidget {
  final AudioPlayer player;
  const FavoriteScreen({Key? key, required this.player}) : super(key: key);
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Tab> myTabs = <Tab>[Tab(text: ''), Tab(text: ''), Tab(text: '')];
  List<Songs> _songs = [];
  List<Albums> _albums = [];
  List<Artists> _artists = [];
  List<bool> _starsongs = [];
  List<bool> _staralbums = [];
  List<bool> _starartists = [];

  _getFavorite() async {
    final _favoriteList = await getStarred();
    if (_favoriteList != null) {
      var songs = _favoriteList["song"];
      var albums = _favoriteList["album"];
      var artists = _favoriteList["artist"];
      List<Songs> _songs1 = [];
      List<Albums> _albums1 = [];
      List<Artists> _artists1 = [];
      List<bool> _starsongs1 = [];
      List<bool> _staralbums1 = [];
      List<bool> _starartists1 = [];

      if (songs != null && songs.length > 0) {
        for (var _song in songs) {
          String _stream = await getServerInfo("stream");
          String _url = await getCoverArt(_song["id"]);
          _song["stream"] = _stream + '&id=' + _song["id"];
          _song["coverUrl"] = _url;
          if (_song["starred"] != null) {
            _starsongs1.add(true);
          } else {
            _starsongs1.add(false);
          }
          _songs1.add(Songs.fromJson(_song));
        }
      }
      if (albums != null && albums.length > 0) {
        for (var _album in albums) {
          String _url = await getCoverArt(_album["id"]);
          _album["coverUrl"] = _url;
          if (_album["starred"] != null) {
            _staralbums1.add(true);
          } else {
            _staralbums1.add(false);
          }
          _albums1.add(Albums.fromJson(_album));
        }
      }
      if (artists != null && artists.length > 0) {
        for (var _artist in artists) {
          String _url = await getCoverArt(_artist["id"]);
          _artist["artistImageUrl"] = _url;
          if (_artist["starred"] != null) {
            _starartists1.add(true);
          } else {
            _starartists1.add(false);
          }
          _artists1.add(Artists.fromJson(_artist));
        }
      }
      if (mounted) {
        setState(() {
          _songs = _songs1;
          _albums = _albums1;
          _artists = _artists1;
          _starsongs = _starsongs1;
          _staralbums = _staralbums1;
          _starartists = _starartists1;
          myTabs = <Tab>[
            Tab(text: S.current.song + "(" + _songs.length.toString() + ")"),
            Tab(text: S.current.album + "(" + _albums.length.toString() + ")"),
            Tab(text: S.current.artist + "(" + _artists.length.toString() + ")")
          ];
        });
      }
    }
  }

  @override
  initState() {
    super.initState();
    myTabs = <Tab>[
      Tab(text: S.current.song + "(0)"),
      Tab(text: S.current.album + "(0)"),
      Tab(text: S.current.artist + "(0)")
    ];
    _tabController = TabController(length: myTabs.length, vsync: this);
    _getFavorite();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _songHeader() {
    List<String> _title = [
      S.current.song,
      S.current.album,
      S.current.artist,
      if (!isMobile) S.current.bitRange,
      if (!isMobile) S.current.dration,
      if (!isMobile) S.current.playCount,
      S.current.favorite
    ];
    return Container(
        height: 30,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        color: bkColor,
        child: myRowList(_title, subText));
  }

  Widget _songsBody() {
    return _songs.length > 0
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _songs.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  Songs _song = _songs[index];
                  List<String> _title = [
                    _song.title,
                    _song.album,
                    _song.artist,
                    if (!isMobile)
                      _song.suffix + "(" + _song.bitRate.toString() + ")",
                    formatDuration(_song.duration),
                    if (!isMobile) _song.playCount.toString(),
                    _song.id
                  ];
                  return ListTile(
                      title: InkWell(
                          onTap: () async {
                            if (listEquals(activeList.value, _songs)) {
                              widget.player.seek(Duration.zero, index: index);
                            } else {
                              //当前歌曲队列
                              activeIndex.value = index;
                              activeSongValue.value = _song.id;
                              //歌曲所在专辑歌曲List
                              activeList.value = _songs;
                            }
                          },
                          child: ValueListenableBuilder<Map>(
                              valueListenable: activeSong,
                              builder: ((context, value, child) {
                                return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: _songlistView(
                                        _title,
                                        (value.isNotEmpty &&
                                                value["value"] == _song.id)
                                            ? activeText
                                            : nomalText,
                                        index));
                              }))));
                }))
        : Container();
  }

  List<Widget> _songlistView(
      List<String> _title, TextStyle _style, int _index) {
    List<Widget> _list = [];
    for (var i = 0; i < _title.length; i++) {
      if (i == _title.length - 1) {
        _list.add(Expanded(
            flex: 1,
            child: Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: badgeRed,
                    size: 16,
                  ),
                  onPressed: () async {
                    Favorite _favorite = Favorite(id: _title[i], type: 'song');
                    await delStarred(_favorite);
                    MyToast.show(
                        context: context,
                        message: S.current.cancel + S.current.favorite);
                    setState(() {
                      _songs.removeAt(_index);
                      _starsongs.removeAt(_index);
                      myTabs = <Tab>[
                        Tab(
                            text: S.current.song +
                                "(" +
                                _songs.length.toString() +
                                ")"),
                        Tab(
                            text: S.current.album +
                                "(" +
                                _albums.length.toString() +
                                ")"),
                        Tab(
                            text: S.current.artist +
                                "(" +
                                _artists.length.toString() +
                                ")")
                      ];
                    });
                  },
                ))));
      } else {
        _list.add(Expanded(
          flex: (i == 0) ? 2 : 1,
          child: Text(
            _title[i],
            textDirection: (i == 0) ? TextDirection.ltr : TextDirection.rtl,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _style,
          ),
        ));
      }
    }
    return _list;
  }

  Widget _itemSongsWidget() {
    return Column(
      children: [
        _songHeader(),
        Container(
            height: (isMobile)
                ? windowsHeight.value - (106 + bottomHeight + 50 + 25 + 40 + 30)
                : windowsHeight.value - (106 + bottomHeight + 50 + 30),
            child: _songsBody())
      ],
    );
  }

  Widget _itemAlbumsWidget() {
    return Column(
      children: [_albumHeader(), _albumBody(_albums, context)],
    );
  }

  Widget _albumHeader() {
    List<String> _title = [
      S.current.album,
      S.current.artist,
      S.current.song,
      if (!isMobile) S.current.dration,
      if (!isMobile) S.current.playCount,
      S.current.favorite
    ];
    return Container(
        height: 30,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        color: bkColor,
        child: myRowList(_title, subText));
  }

  Widget _albumBody(List<Albums> _albums, BuildContext _context) {
    return Container(
        height: (isMobile)
            ? windowsHeight.value - (106 + bottomHeight + 50 + 25 + 40 + 30)
            : windowsHeight.value - (106 + bottomHeight + 50 + 30),
        child: _albums.length > 0
            ? MediaQuery.removePadding(
                context: _context,
                removeTop: true,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _albums.length,
                    itemExtent: 50.0, //强制高度为50.0
                    itemBuilder: (BuildContext context, int index) {
                      Albums _tem = _albums[index];
                      return ListTile(
                          title: InkWell(
                              onTap: () {
                                activeID.value = _tem.id;
                                indexValue.value = 8;
                              },
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _tem.title,
                                        textDirection: TextDirection.ltr,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: nomalText,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        _tem.artist.toString(),
                                        textDirection: TextDirection.rtl,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: nomalText,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        _tem.songCount.toString(),
                                        textDirection: TextDirection.rtl,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: nomalText,
                                      ),
                                    ),
                                    if (!isMobile)
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          formatDuration(_tem.duration),
                                          textDirection: TextDirection.rtl,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: nomalText,
                                        ),
                                      ),
                                    if (!isMobile)
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          _tem.playCount.toString(),
                                          textDirection: TextDirection.rtl,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: nomalText,
                                        ),
                                      ),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.favorite,
                                                color: badgeRed,
                                                size: 16,
                                              ),
                                              onPressed: () async {
                                                Favorite _favorite = Favorite(
                                                    id: _tem.id, type: 'album');
                                                await delStarred(_favorite);
                                                MyToast.show(
                                                    context: context,
                                                    message: S.current.cancel +
                                                        S.current.favorite);
                                                setState(() {
                                                  _albums.removeAt(index);
                                                  _staralbums.removeAt(index);
                                                });
                                              },
                                            )))
                                  ])));
                    }))
            : Container());
  }

  Widget _artistsHeader() {
    List<String> _title = [
      S.current.artist,
      S.current.album,
      S.current.favorite
    ];
    return Container(
        height: 30,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        color: bkColor,
        child: myRowList(_title, subText));
  }

  Widget _artistBody(List<Artists> _artists, BuildContext _context) {
    return Container(
        height: (isMobile)
            ? windowsHeight.value - (106 + bottomHeight + 50 + 25 + 40 + 30)
            : windowsHeight.value - (106 + bottomHeight + 50 + 30),
        child: _artists.length > 0
            ? MediaQuery.removePadding(
                context: _context,
                removeTop: true,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _artists.length,
                    itemExtent: 50.0, //强制高度为50.0
                    itemBuilder: (BuildContext context, int index) {
                      Artists _tem = _artists[index];
                      return ListTile(
                          title: InkWell(
                              onTap: () {
                                activeID.value = _tem.id;
                                indexValue.value = 9;
                              },
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _tem.name,
                                        textDirection: TextDirection.ltr,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: nomalText,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        _tem.albumCount.toString(),
                                        textDirection: TextDirection.rtl,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: nomalText,
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.favorite,
                                                color: badgeRed,
                                                size: 16,
                                              ),
                                              onPressed: () async {
                                                Favorite _favorite = Favorite(
                                                    id: _tem.id,
                                                    type: 'artist');
                                                await delStarred(_favorite);
                                                MyToast.show(
                                                    context: context,
                                                    message: S.current.cancel +
                                                        S.current.favorite);
                                                setState(() {
                                                  _starartists.removeAt(index);
                                                  _artists.removeAt(index);
                                                });
                                              },
                                            ))),
                                  ])));
                    }))
            : Container());
  }

  Widget _itemArtistsWidget() {
    return Column(
      children: [_artistsHeader(), _artistBody(_artists, context)],
    );
  }

  Widget _buildTopWidget() {
    return Container(
        alignment: Alignment.centerLeft,
        child: Text(S.current.favorite, style: titleText1));
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 106,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
            Container(
                alignment: Alignment.topLeft,
                child: TabBar(
                    controller: _tabController,
                    labelColor: textGray,
                    unselectedLabelColor: borderColor,
                    tabs: myTabs,
                    labelStyle: nomalText,
                    isScrollable: true,
                    indicatorColor: badgeRed)),
          ],
        ),
        contentWidget: TabBarView(controller: _tabController, children: [
          _itemSongsWidget(),
          _itemAlbumsWidget(),
          _itemArtistsWidget()
        ]));
  }
}
