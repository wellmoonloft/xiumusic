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
  int _songs = 0;
  int _playCount = 0;
  int _duration = 0;
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
      //_artist["biography"];

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: screenImageWidthAndHeight,
                width: screenImageWidthAndHeight,
                child: (_arturl != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          _arturl!,
                          height: screenImageWidthAndHeight,
                          width: screenImageWidthAndHeight,
                          fit: BoxFit.cover,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded) {
                              return child;
                            }
                            return AnimatedSwitcher(
                              child: frame != null
                                  ? child
                                  : Image.asset(mylogoAsset),
                              duration:
                                  const Duration(milliseconds: imageMilli),
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
                      width: isMobile
                          ? windowsWidth.value -
                              screenImageWidthAndHeight -
                              30 -
                              15
                          : windowsWidth.value -
                              drawerWidth -
                              screenImageWidthAndHeight -
                              30 -
                              15,
                      child: Text(_artilstname,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: titleText2)),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                      children: [
                        MyTextButton(
                            press: () {
                              indexValue.value = 5;
                            },
                            title: S.of(context).artist),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).album + ": " + _albumsnum.toString(),
                          style: nomalText,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Text(
                      S.of(context).song + ": " + _songs.toString(),
                      style: nomalText,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Text(
                      S.of(context).dration + ": " + formatDuration(_duration),
                      style: nomalText,
                    ),
                  ),
                  Container(
                      child: Row(children: [
                    Text(
                      S.of(context).playCount + ": " + _playCount.toString(),
                      style: nomalText,
                    ),
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
                  ]))
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderWidget() {
    List<String> _title = [
      S.of(context).song,
      S.of(context).album,
      S.of(context).dration,
      if (!isMobile) S.of(context).playCount,
    ];
    return myRowList(_title, subText);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverToBoxAdapter(
        child: Column(
          children: [
            _buildTopWidget(),
          ],
        ),
      ),
      if (_songList.length > 0)
        SliverToBoxAdapter(
            child: Container(
          padding: allPadding,
          child: Row(
            children: [
              Text(
                S.of(context).top + S.of(context).song,
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
          title: S.of(context).album,
          controller: _albumscontroller,
          press: (_albums.length > 10)
              ? () {
                  indexValue.value = 13;
                }
              : null,
        )),
      if (_albums.length > 0)
        SliverToBoxAdapter(
          child: MySliverControlList(
              controller: _albumscontroller, albums: _albums),
        ),
      if (_similarArtist.length > 0)
        SliverToBoxAdapter(
            child: MySliverControlBar(
          title: S.of(context).similar + S.of(context).artist,
          controller: _similarArtistcontroller,
        )),
      if (_similarArtist.length > 0)
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 10),
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _similarArtist.length,
              controller: _similarArtistcontroller,
              itemBuilder: (context, index) {
                var _tem = _similarArtist[index];

                return Container(
                  padding: leftrightPadding,
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
