import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xiumusic/models/myModel.dart';
import '../../generated/l10n.dart';

import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';
import '../common/myAlertDialog.dart';
import '../common/myStructure.dart';
import '../common/myTextButton.dart';
import '../common/myToast.dart';

class AlbumDetailScreen extends StatefulWidget {
  final AudioPlayer player;
  const AlbumDetailScreen({
    Key? key,
    required this.player,
  }) : super(key: key);
  @override
  _AlbumDetailScreenState createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  List<Songs> _songs = [];
  int _songsnum = 0;
  int _playCount = 0;
  int _duration = 0;
  String _albumsname = "";
  String _artistID = "";
  String _genre = "";
  String? _arturl;
  String _artist = "";
  int _year = 0;
  bool _staralbum = false;
  List<bool> _starsong = [];
  String _biography = "";
  bool _isbiography = true;

  _getSongs(String albumId) async {
    final _albumtem = await getSongs(albumId);
    if (_albumtem != null && _albumtem.length > 0) {
      final _songsList = _albumtem["song"];
      String _url = getCoverArt(_albumtem["id"]);
      _albumtem["coverUrl"] = _url;
      _albumtem["title"] = _albumtem["name"];
      Albums _albums = Albums.fromJson(_albumtem);

      if (_songsList != null) {
        List<Songs> _songtem = [];
        List<bool> _startem = [];
        for (var _element in _songsList) {
          String _stream = getServerInfo("stream");
          String _url = await getCoverArt(_element["id"]);
          _element["stream"] = _stream + '&id=' + _element["id"];
          _element["coverUrl"] = _url;
          if (_element["starred"] != null) {
            _startem.add(true);
          } else {
            _startem.add(false);
          }
          Songs _song = Songs.fromJson(_element);
          _songtem.add(_song);
        }
        if (_albumtem["starred"] != null) {
          _staralbum = true;
        } else {
          _staralbum = false;
        }

        if (mounted) {
          setState(() {
            _songs = _songtem;
            _songsnum = _albums.songCount;
            _albumsname = _albums.title;
            _playCount = _albums.playCount;
            _duration = _albums.duration;
            _year = _albums.year;
            _artist = _albums.artist;
            _artistID = _albums.artistId;
            _genre = _albums.genre;
            _arturl = _albums.coverUrl;
            _starsong = _startem;
          });
        }
      }
    }
  }

  _getAlbumInfo2(String albumId) async {
    final _albumIofo = await getAlbumInfo2(albumId);
    if (_albumIofo != null) {
      if (_albumIofo["notes"] != null) {
        String _tem = _albumIofo["notes"];
        while (_tem.contains("<a") && _tem.contains("a>")) {
          String _sub1 = "";
          String _sub2 = "";
          _sub1 = _tem.substring(0, _tem.indexOf("<a"));
          _sub2 = _tem.substring(_tem.indexOf("a>") + 2, _tem.length);
          _tem = _sub1 + _sub2;
        }
        if (mounted) {
          setState(() {
            _biography = _tem;
          });
        }
      }
    }
  }

  List<Widget> mylistView(List<String> _title) {
    List<Widget> _list = [];
    for (var i = 0; i < _title.length; i++) {
      _list.add(Container(
        padding: EdgeInsets.only(left: 5),
        child: MyTextButton(
            press: () {
              activeID.value = _title[i];
              indexValue.value = 4;
            },
            title: _title[i]),
      ));
    }
    return _list;
  }

  @override
  initState() {
    super.initState();
    _getSongs(activeID.value);
    _getAlbumInfo2(activeID.value);
  }

  Widget _buildTopWidget() {
    double _toprightwidth = isMobile
        ? windowsWidth.value - screenImageWidthAndHeight - 40 - 15
        : windowsWidth.value -
            drawerWidth -
            screenImageWidthAndHeight -
            40 -
            15;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
            height: screenImageWidthAndHeight,
            width: screenImageWidthAndHeight,
            child: (_arturl != null)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: _arturl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return AnimatedSwitcher(
                          child: Image.asset(mylogoAsset),
                          duration: const Duration(milliseconds: imageMilli),
                        );
                      },
                    ),
                  )
                : Container()),
        SizedBox(
          width: 15,
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  constraints: BoxConstraints(
                    maxWidth: _toprightwidth,
                  ),
                  child: Text(_albumsname,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: titleText2)),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        constraints: BoxConstraints(
                          maxWidth: _toprightwidth,
                        ),
                        child: MyTextButton(
                            press: () {
                              activeID.value = _artistID;
                              indexValue.value = 9;
                            },
                            title: _artist)),
                    Container(
                      height: 20,
                      width: 25,
                      child: (_staralbum)
                          ? IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.favorite,
                                color: badgeRed,
                                size: 16,
                              ),
                              onPressed: () async {
                                Favorite _favorite =
                                    Favorite(id: activeID.value, type: 'album');
                                await delStarred(_favorite);

                                setState(() {
                                  _staralbum = false;
                                });
                              },
                            )
                          : IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.favorite_border,
                                color: textGray,
                                size: 16,
                              ),
                              onPressed: () async {
                                Favorite _favorite =
                                    Favorite(id: activeID.value, type: 'album');
                                await addStarred(_favorite);

                                setState(() {
                                  _staralbum = true;
                                });
                              },
                            ),
                    ),
                    Container(
                      height: 20,
                      width: 20,
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(
                          Icons.share,
                          color: textGray,
                          size: 16,
                        ),
                        onPressed: () async {
                          final _sharelists = await createShare(activeID.value);
                          if (_sharelists != null && _sharelists.length > 0) {
                            Sharelist _share =
                                Sharelist.fromJson(_sharelists[0]);
                            showShareDialog(_share, context);
                          } else {
                            showMyAlertDialog(
                                context, S.current.failure, S.current.failure);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              if (_genre != "")
                Container(
                    width: _toprightwidth,
                    child: Row(
                      children: [
                        MyTextButton(
                            press: () {
                              indexValue.value = 6;
                            },
                            title: S.current.genres),
                        SizedBox(
                          width: 5,
                        ),
                        MyTextButton(
                            press: () {
                              activeID.value = _genre;
                              indexValue.value = 4;
                            },
                            title: _genre),
                      ],
                    )),
              if (_year != 0)
                Container(
                  width: _toprightwidth,
                  child: Text(
                    S.current.year + ": " + _year.toString(),
                    style: nomalText,
                  ),
                ),
              Container(
                width: _toprightwidth,
                child: Text(
                  S.current.song + ": " + _songsnum.toString(),
                  style: nomalText,
                ),
              ),
              Container(
                width: _toprightwidth,
                child: Text(
                  S.current.dration + ": " + formatDuration(_duration),
                  style: nomalText,
                ),
              ),
              Container(
                width: _toprightwidth,
                child: Text(
                  S.current.playCount + ": " + _playCount.toString(),
                  style: nomalText,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _songsHeader() {
    List<String> _title = [
      S.current.song,
      S.current.dration,
      if (!isMobile) S.current.bitRange,
      if (!isMobile) S.current.playCount,
      S.current.favorite
    ];
    return myRowList(_title, subText);
  }

  Widget _songsBody(
      List<Songs> _songs, BuildContext _context, AudioPlayer _player) {
    return _songs.length > 0
        ? MediaQuery.removePadding(
            context: _context,
            removeTop: true,
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _songs.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  Songs _song = _songs[index];
                  List<String> _title = [
                    _song.title,
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
                              _player.seek(Duration.zero, index: index);
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                (_starsong[_index])
                    ? IconButton(
                        padding: EdgeInsets.all(0),
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
                        padding: EdgeInsets.all(0),
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
                      ),
                IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(
                    Icons.share,
                    color: textGray,
                    size: 16,
                  ),
                  onPressed: () async {
                    final _sharelists = await createShare(_title[i]);
                    if (_sharelists != null && _sharelists.length > 0) {
                      Sharelist _share = Sharelist.fromJson(_sharelists[0]);
                      showShareDialog(_share, context);
                    } else {
                      showMyAlertDialog(
                          context, S.current.failure, S.current.failure);
                    }
                  },
                ),
              ],
            )));
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

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverToBoxAdapter(
          child:
              Container(padding: leftrightPadding, child: _buildTopWidget())),
      if (_biography != "")
        SliverToBoxAdapter(
          child: InkWell(
              onTap: () {
                if (_isbiography) {
                  setState(() {
                    _isbiography = false;
                  });
                } else {
                  setState(() {
                    _isbiography = true;
                  });
                }
              },
              child: Container(
                padding: nobottomPadding,
                width: isMobile
                    ? windowsWidth.value
                    : windowsWidth.value - drawerWidth,
                child: _isbiography
                    ? Text(
                        _biography,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: nomalText,
                      )
                    : Text(
                        _biography,
                        style: nomalText,
                      ),
              )),
        ),
      SliverToBoxAdapter(
          child: Container(
        padding: nobottomPadding,
        child: _songsHeader(),
      )),
      SliverToBoxAdapter(child: _songsBody(_songs, context, widget.player))
    ]);
  }
}
