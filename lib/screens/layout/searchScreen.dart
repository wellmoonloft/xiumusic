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
import '../common/myToast.dart';

class SearchScreen extends StatefulWidget {
  final AudioPlayer player;
  const SearchScreen({Key? key, required this.player}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = new TextEditingController();
  late List<Tab> _myTabs;
  late TabController _tabController;
  List<Songs> _songs = [];
  List<Albums> _albums = [];
  List<Artists> _artists = [];
  List<bool> _starsong = [];
  List<bool> _staralbums = [];
  List<bool> _starartists = [];

  _getSongsbyName() async {
    String _title1 = _searchController.text;
    String _title2 = "";
    List<Songs> _listSong = [];
    List<Albums> _listAlbums = [];
    List<Artists> _listArtists = [];
    List<bool> _startem = [];
    List<bool> _staralbums1 = [];
    List<bool> _starartists1 = [];
    _title2 = await converToTraditional(_title1);
    final _searchData = await search3(_title1);
    final _searchDat2 = await search3(_title2);
    if (_searchData["song"] != null) {
      for (var _element in _searchData["song"]) {
        String _stream = getServerInfo("stream");
        String _url = getCoverArt(_element["id"]);
        _element["stream"] = _stream + '&id=' + _element["id"];
        _element["coverUrl"] = _url;
        if (_element["starred"] != null) {
          _startem.add(true);
        } else {
          _startem.add(false);
        }
        Songs _tem = Songs.fromJson(_element);
        _listSong.add(_tem);
      }
    }
    if (_searchData["album"] != null) {
      for (var _element in _searchData["album"]) {
        String _url = getCoverArt(_element["id"]);
        _element["coverUrl"] = _url;
        if (_element["starred"] != null) {
          _staralbums1.add(true);
        } else {
          _staralbums1.add(false);
        }
        Albums _tem = Albums.fromJson(_element);
        _listAlbums.add(_tem);
      }
    }
    if (_searchData["artist"] != null) {
      for (var _element in _searchData["artist"]) {
        String _url = getCoverArt(_element["id"]);
        _element["artistImageUrl"] = _url;
        if (_element["starred"] != null) {
          _starartists1.add(true);
        } else {
          _starartists1.add(false);
        }
        Artists _tem = Artists.fromJson(_element);
        _listArtists.add(_tem);
      }
    }
    if (_searchDat2["song"] != null) {
      for (var _element in _searchDat2["song"]) {
        String _stream = getServerInfo("stream");
        String _url = await getCoverArt(_element["id"]);
        _element["stream"] = _stream + '&id=' + _element["id"];
        _element["coverUrl"] = _url;

        Songs _tem = Songs.fromJson(_element);
        if (!_listSong.contains(_tem)) {
          _listSong.add(_tem);
          if (_element["starred"] != null) {
            _startem.add(true);
          } else {
            _startem.add(false);
          }
        }
      }
    }
    if (_searchDat2["album"] != null) {
      for (var _element in _searchDat2["album"]) {
        String _url = await getCoverArt(_element["id"]);
        _element["coverUrl"] = _url;
        Albums _tem = Albums.fromJson(_element);
        if (!_listAlbums.contains(_tem)) {
          _listAlbums.add(_tem);
          if (_element["starred"] != null) {
            _staralbums1.add(true);
          } else {
            _staralbums1.add(false);
          }
        }
      }
    }
    if (_searchDat2["artist"] != null) {
      for (var _element in _searchDat2["artist"]) {
        String _url = await getCoverArt(_element["id"]);
        _element["artistImageUrl"] = _url;
        Artists _tem = Artists.fromJson(_element);
        if (!_listArtists.contains(_tem)) {
          _listArtists.add(_tem);
          if (_element["starred"] != null) {
            _starartists1.add(true);
          } else {
            _starartists1.add(false);
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _songs = _listSong;
        _albums = _listAlbums;
        _artists = _listArtists;
        _starsong = _startem;
        _staralbums = _staralbums1;
        _starartists = _starartists1;
        _myTabs = <Tab>[
          Tab(text: S.current.song + "(" + _songs.length.toString() + ")"),
          Tab(text: S.current.album + "(" + _albums.length.toString() + ")"),
          Tab(text: S.current.artist + "(" + _artists.length.toString() + ")")
        ];
      });
    }
  }

  @override
  initState() {
    super.initState();
    _myTabs = <Tab>[
      Tab(text: S.current.song + "(0)"),
      Tab(text: S.current.album + "(0)"),
      Tab(text: S.current.artist + "(0)")
    ];
    _tabController = TabController(length: _myTabs.length, vsync: this);

    if (activeID.value != "1") {
      _searchController.text = activeID.value;
      _getSongsbyName();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Widget _songsWidget() {
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

  Widget _songHeader() {
    List<String> _title = [
      S.current.song,
      S.current.album,
      S.current.artist,
      S.current.dration,
      if (!isMobile) S.current.bitRange,
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
                    formatDuration(_song.duration),
                    if (!isMobile)
                      _song.suffix + "(" + _song.bitRate.toString() + ")",
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
                child: (_starsong[_index])
                    ? IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: badgeRed,
                          size: 16,
                        ),
                        onPressed: () async {
                          Favorite _favorite =
                              Favorite(id: _title[i], type: 'song');
                          await delStarred(_favorite);
                          MyToast.show(
                              context: context,
                              message: S.current.cancel + S.current.favorite);
                          setState(() {
                            _starsong[_index] = false;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.favorite_border,
                          color: textGray,
                          size: 16,
                        ),
                        onPressed: () async {
                          Favorite _favorite =
                              Favorite(id: _title[i], type: 'song');
                          await addStarred(_favorite);
                          MyToast.show(
                              context: context,
                              message: S.current.add + S.current.favorite);
                          setState(() {
                            _starsong[_index] = true;
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

  Widget _artistWidget() {
    return Column(
      children: [_artistsHeader(), _artistBody(_artists, context)],
    );
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
                                            child: (_starartists[index])
                                                ? IconButton(
                                                    icon: Icon(
                                                      Icons.favorite,
                                                      color: badgeRed,
                                                      size: 16,
                                                    ),
                                                    onPressed: () async {
                                                      Favorite _favorite =
                                                          Favorite(
                                                              id: _tem.id,
                                                              type: 'artist');
                                                      await delStarred(
                                                          _favorite);
                                                      MyToast.show(
                                                          context: context,
                                                          message: S.current
                                                                  .cancel +
                                                              S.current
                                                                  .favorite);
                                                      setState(() {
                                                        _starartists[index] =
                                                            false;
                                                      });
                                                    },
                                                  )
                                                : IconButton(
                                                    icon: Icon(
                                                      Icons.favorite_border,
                                                      color: textGray,
                                                      size: 16,
                                                    ),
                                                    onPressed: () async {
                                                      Favorite _favorite =
                                                          Favorite(
                                                              id: _tem.id,
                                                              type: 'artist');
                                                      await addStarred(
                                                          _favorite);
                                                      MyToast.show(
                                                          context: context,
                                                          message: S
                                                                  .current.add +
                                                              S.current
                                                                  .favorite);
                                                      setState(() {
                                                        _starartists[index] =
                                                            true;
                                                      });
                                                    },
                                                  ))),
                                  ])));
                    }))
            : Container());
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
                                            child: (_staralbums[index])
                                                ? IconButton(
                                                    icon: Icon(
                                                      Icons.favorite,
                                                      color: badgeRed,
                                                      size: 16,
                                                    ),
                                                    onPressed: () async {
                                                      Favorite _favorite =
                                                          Favorite(
                                                              id: _tem.id,
                                                              type: 'album');
                                                      await delStarred(
                                                          _favorite);
                                                      MyToast.show(
                                                          context: context,
                                                          message: S.current
                                                                  .cancel +
                                                              S.current
                                                                  .favorite);
                                                      setState(() {
                                                        _staralbums[index] =
                                                            false;
                                                      });
                                                    },
                                                  )
                                                : IconButton(
                                                    icon: Icon(
                                                      Icons.favorite_border,
                                                      color: textGray,
                                                      size: 16,
                                                    ),
                                                    onPressed: () async {
                                                      Favorite _favorite =
                                                          Favorite(
                                                              id: _tem.id,
                                                              type: 'album');
                                                      await addStarred(
                                                          _favorite);
                                                      MyToast.show(
                                                          context: context,
                                                          message: S
                                                                  .current.add +
                                                              S.current
                                                                  .favorite);
                                                      setState(() {
                                                        _staralbums[index] =
                                                            true;
                                                      });
                                                    },
                                                  )))
                                  ])));
                    }))
            : Container());
  }

  Widget _buildTopWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextInput(
          control: _searchController,
          label: S.current.search,
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
      ],
    );
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
                    tabs: _myTabs,
                    isScrollable: true,
                    indicatorColor: badgeRed)),
          ],
        ),
        contentWidget: TabBarView(controller: _tabController, children: [
          _songsWidget(),
          _itemAlbumsWidget(),
          _artistWidget(),
        ]));
  }
}
