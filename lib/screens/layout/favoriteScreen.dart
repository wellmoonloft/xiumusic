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
  late TabController tabController;
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
      setState(() {
        _songs = _songs1;
        _albums = _albums1;
        _artists = _artists1;
        _starsongs = _starsongs1;
        _staralbums = _staralbums1;
        _starartists = _starartists1;
      });
    }
  }

  @override
  initState() {
    super.initState();
    myTabs = <Tab>[
      Tab(text: S.current.song),
      Tab(text: S.current.album),
      Tab(text: S.current.artist)
    ];
    tabController = TabController(length: myTabs.length, vsync: this);
    _getFavorite();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget _songHeader() {
    List<String> _title = [
      S.current.song,
      S.current.album,
      S.current.artist,
      if (!isMobile) S.current.dration,
      S.of(context).favorite
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
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          _song.title,
                                          textDirection: TextDirection.ltr,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: nomalText,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          _song.album,
                                          textDirection: TextDirection.rtl,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: nomalText,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          _song.artist,
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
                                            formatDuration(_song.duration),
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
                                                      id: _song.id,
                                                      type: 'song');
                                                  await delStarred(_favorite);
                                                  MyToast.show(
                                                      context: context,
                                                      message: S
                                                              .current.cancel +
                                                          S.current.favorite);
                                                  setState(() {
                                                    _songs.removeAt(index);
                                                    _starsongs.removeAt(index);
                                                  });
                                                },
                                              ))),
                                    ]);
                              }))));
                }))
        : Container();
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
      S.of(context).favorite
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(child: Text(S.of(context).favorite, style: titleText1)),
        Row(
          children: [
            Text(
              S.of(context).song + ": " + _songs.length.toString(),
              style: nomalText,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              S.of(context).album + ": " + _albums.length.toString(),
              style: nomalText,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              S.of(context).artist + ": " + _artists.length.toString(),
              style: nomalText,
            ),
          ],
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
                    controller: tabController,
                    labelColor: textGray,
                    unselectedLabelColor: borderColor,
                    tabs: myTabs,
                    isScrollable: true,
                    indicatorColor: badgeRed)),
          ],
        ),
        contentWidget: TabBarView(controller: tabController, children: [
          _itemSongsWidget(),
          _itemAlbumsWidget(),
          _itemArtistsWidget()
        ]));
  }
}
