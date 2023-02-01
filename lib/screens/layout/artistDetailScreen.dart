import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';
import '../common/mySliverControlBar.dart';
import '../common/mySliverControlList.dart';
import '../common/myStructure.dart';
import '../common/myTextButton.dart';

class ArtistDetailScreen extends StatefulWidget {
  final AudioPlayer player;
  const ArtistDetailScreen({Key? key, required this.player}) : super(key: key);
  @override
  _ArtistDetailScreenState createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  ScrollController _albumscontroller = ScrollController();
  ScrollController _similarArtistcontroller = ScrollController();
  List<Albums> _albums = [];
  List<Songs> _songList = [];
  String _artilstname = "";
  int _albumsnum = 0;
  String? _arturl;
  String _biography = "";
  bool _isbiography = true;
  int _songs = 0;
  int _duration = 0;
  int _playCount = 0;
  bool _star = false;
  bool _isMoreSongs = false;
  List _similarArtist = [];

  _getTopSongs(String _artilstname) async {
    final _albumtem = await getTopSongs(_artilstname);
    if (_albumtem != null && _albumtem["song"] != null) {
      final _songsList = _albumtem["song"];
      List<Songs> _songtem = [];

      for (var _element in _songsList) {
        String _stream = getServerInfo("stream");
        String _url = getCoverArt(_element["id"]);
        _element["stream"] = _stream + '&id=' + _element["id"];
        _element["coverUrl"] = _url;
        Songs _song = Songs.fromJson(_element);
        _songtem.add(_song);
      }

      if (mounted) {
        setState(() {
          _songList = _songtem;
        });
      }
    }
  }

  _getArtistInfo2(String _artistId) async {
    final _artist = await getArtistInfo2(_artistId);
    if (_artist != null) {
      if (_artist["biography"] != null) {
        String _tem = _artist["biography"];
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

      if (_artist["similarArtist"] != null &&
          _artist["similarArtist"].length > 0) {
        List _similarList = [];
        for (var _element in _artist["similarArtist"]) {
          _element["coverUrl"] = getCoverArt(_element["id"]);
          _similarList.add(_element);
        }
        if (mounted) {
          setState(() {
            _similarArtist = _similarList;
          });
        }
      }
    }
  }

  _getArtist(String artistId) async {
    final _artist = await getArtist(artistId);
    if (_artist != null) {
      List<Albums> _list = [];
      if (_artist != null && _artist.length > 0) {
        _getTopSongs(_artist["name"]);
        for (var _element in _artist["album"]) {
          String _url = getCoverArt(_element["id"]);
          _element["coverUrl"] = _url;
          Albums _album = Albums.fromJson(_element);
          _list.add(_album);
          _playCount += _album.playCount;
          _duration += _album.duration;
          _songs += _album.songCount;
        }
      }

      if (_artist["starred"] != null) {
        _star = true;
      } else {
        _star = false;
      }

      if (mounted) {
        setState(() {
          _albums = _list;
          _albumsnum = _artist["albumCount"];
          _artilstname = _artist["name"];

          _arturl = getCoverArt(_artist["id"]);
        });
      }
    }
  }

  @override
  initState() {
    super.initState();
    _getArtistInfo2(activeID.value);
    _getArtist(activeID.value);
  }

  @override
  void dispose() {
    _albumscontroller.dispose();
    _similarArtistcontroller.dispose();
    super.dispose();
  }

  Widget _buildTopWidget() {
    double _toprightwidth = isMobile
        ? windowsWidth.value - screenImageWidthAndHeight - 30 - 15
        : windowsWidth.value -
            drawerWidth -
            screenImageWidthAndHeight -
            30 -
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
                    ))
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
                  width: _toprightwidth,
                  child: Text(_artilstname,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: titleText2)),
              Container(
                child: Row(
                  children: [
                    MyTextButton(
                        press: () {
                          indexValue.value = 5;
                        },
                        title: S.current.artist),
                    Container(
                      height: 30,
                      width: 30,
                      child: (_star)
                          ? IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: badgeRed,
                                size: 16,
                              ),
                              onPressed: () async {
                                Favorite _favorite = Favorite(
                                    id: activeID.value, type: 'artist');
                                await delStarred(_favorite);

                                setState(() {
                                  _star = false;
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
                                Favorite _favorite = Favorite(
                                    id: activeID.value, type: 'artist');
                                await addStarred(_favorite);

                                setState(() {
                                  _star = true;
                                });
                              },
                            ),
                    )
                  ],
                ),
              ),
              Container(
                width: _toprightwidth,
                child: Text(
                  S.current.album + ": " + _albumsnum.toString(),
                  style: nomalText,
                ),
              ),
              Container(
                width: _toprightwidth,
                child: Text(
                  S.current.song + ": " + _songs.toString(),
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderWidget() {
    List<String> _title = [
      S.current.song,
      S.current.album,
      S.current.dration,
      if (!isMobile) S.current.playCount,
    ];
    return myRowList(_title, subText);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverToBoxAdapter(
        child: Column(
          children: [
            Container(
              padding: leftrightPadding,
              child: _buildTopWidget(),
            )
          ],
        ),
      ),
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
      if (_songList.length > 0)
        SliverToBoxAdapter(
            child: Container(
          padding: allPadding,
          child: Row(
            children: [
              Text(
                S.current.top + S.current.song,
                style: titleText3,
              ),
              if (_songList.length > 5)
                SizedBox(
                  width: 5,
                ),
              if (_songList.length > 5)
                MyTextButton(
                  press: () {
                    if (_isMoreSongs) {
                      setState(() {
                        _isMoreSongs = false;
                      });
                    } else {
                      setState(() {
                        _isMoreSongs = true;
                      });
                    }
                  },
                  title: _isMoreSongs ? S.current.less : S.current.more,
                )
            ],
          ),
        )),
      if (_songList.length > 0)
        SliverToBoxAdapter(
            child: Container(
          padding: leftrightPadding,
          child: _buildHeaderWidget(),
        )),
      if (_songList.length > 0)
        SliverList(
          delegate: SliverChildBuilderDelegate((content, index) {
            Songs _tem = _songList[index];
            List<String> _title = [
              _tem.title,
              _tem.album,
              formatDuration(_tem.duration),
              if (!isMobile) _tem.playCount.toString(),
            ];
            return Container(
                padding: leftrightPadding,
                height: 50,
                alignment: Alignment.center,
                child: InkWell(
                    onTap: () async {
                      if (listEquals(activeList.value, _songList)) {
                        widget.player.seek(Duration.zero, index: index);
                      } else {
                        //当前歌曲队列
                        activeIndex.value = index;
                        activeSongValue.value = _tem.id;
                        //歌曲所在专辑歌曲List
                        activeList.value = _songList;
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
          },
              childCount: (_songList.length < 5 || _isMoreSongs)
                  ? _songList.length
                  : 5),
        ),
      if (_albums.length > 0)
        SliverToBoxAdapter(
            child: MySliverControlBar(
          title: S.current.album,
          controller: _albumscontroller,
        )),
      if (_albums.length > 0)
        SliverToBoxAdapter(
          child: MySliverControlList(
              controller: _albumscontroller, albums: _albums),
        ),
      if (_similarArtist.length > 0)
        SliverToBoxAdapter(
            child: MySliverControlBar(
          title: S.current.similar + S.current.artist,
          controller: _similarArtistcontroller,
        )),
      if (_similarArtist.length > 0)
        SliverToBoxAdapter(
          child: Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _similarArtist.length,
              controller: _similarArtistcontroller,
              itemBuilder: (context, index) {
                var _tem = _similarArtist[index];

                return Container(
                  padding: index == 0
                      ? leftrightPadding
                      : EdgeInsets.only(right: 15),
                  child: InkWell(
                      onTap: () {
                        activeID.value = _tem["id"];
                        _similarArtist.clear();
                        _songList.clear();
                        _getArtistInfo2(activeID.value);
                        _getArtist(activeID.value);
                      },
                      child: Column(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: 200 - 67,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: _tem["coverUrl"],
                                fit: BoxFit.cover,
                                placeholder: (context, url) {
                                  return AnimatedSwitcher(
                                    child: Image.asset(mylogoAsset),
                                    duration: const Duration(
                                        milliseconds: imageMilli),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              constraints: BoxConstraints(
                                maxWidth: 200 - 67,
                              ),
                              child: Text(_tem["name"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: nomalText)),
                        ],
                      )),
                );
              },
            ),
          ),
        ),
    ]);
  }
}
