import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xiumusic/models/myModel.dart';
import '../../generated/l10n.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';
import '../common/myStructure.dart';
import '../common/myTextButton.dart';

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
  List<String> _genres = [];
  int _year = 0;
  bool _star = false;

  _getSongs(String albumId) async {
    final _albumtem = await getSongs(albumId);
    if (_albumtem != null && _albumtem.length > 0) {
      final _songsList = _albumtem["song"];
      String _url = getCoverArt(_albumtem["id"]);
      _albumtem["coverUrl"] = _url;
      _albumtem["title"] = _albumtem["name"];
      Albums _albums = Albums.fromJson(_albumtem);

      if (_songsList != null) {
        List<String> _genrelist = [];
        List<Songs> _songtem = [];
        for (var _element in _songsList) {
          String _stream = getServerInfo("stream");
          String _url = await getCoverArt(_element["id"]);
          _element["stream"] = _stream + '&id=' + _element["id"];
          _element["coverUrl"] = _url;
          Songs _song = Songs.fromJson(_element);
          _songtem.add(_song);
          if (_song.genre != "0" && !_genrelist.contains(_song.genre)) {
            _genrelist.add(_song.genre);
          }
        }
        if (_albumtem["starred"] != null) {
          _star = true;
        } else {
          _star = false;
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
            _genres = _genrelist;
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
                        child: CachedNetworkImage(
                          imageUrl: _arturl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return AnimatedSwitcher(
                              child: Image.asset(mylogoAsset),
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
                      constraints: BoxConstraints(
                        maxWidth: isMobile
                            ? windowsWidth.value -
                                screenImageWidthAndHeight -
                                30 -
                                15
                            : windowsWidth.value -
                                drawerWidth -
                                screenImageWidthAndHeight -
                                30 -
                                15,
                      ),
                      child: Text(_albumsname,
                          maxLines: 1,
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
                          width: 10,
                        ),
                        Container(
                            constraints: BoxConstraints(
                              maxWidth: isMobile
                                  ? windowsWidth.value -
                                      screenImageWidthAndHeight -
                                      30 -
                                      60
                                  : windowsWidth.value -
                                      drawerWidth -
                                      screenImageWidthAndHeight -
                                      30 -
                                      60,
                            ),
                            child: MyTextButton(
                                press: () {
                                  activeID.value = _artistID;
                                  indexValue.value = 9;
                                },
                                title: _artist)),
                      ],
                    ),
                  ),
                  if (_year != 0)
                    SizedBox(
                      height: 5,
                    ),
                  if (_year != 0)
                    Row(
                      children: [
                        Text(
                          S.of(context).year + ": " + _year.toString(),
                          style: nomalText,
                        ),
                      ],
                    ),
                  if (_genres.length > 0)
                    SizedBox(
                      height: 5,
                    ),
                  if (_genres.length > 0)
                    Container(
                        width: isMobile
                            ? windowsWidth.value -
                                screenImageWidthAndHeight -
                                30 -
                                60
                            : windowsWidth.value -
                                drawerWidth -
                                screenImageWidthAndHeight -
                                30 -
                                60,
                        child: Row(
                          children: [
                            MyTextButton(
                                press: () {
                                  indexValue.value = 6;
                                },
                                title: S.of(context).genres),
                            SizedBox(
                              width: 5,
                            ),
                            if (!isMobile)
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: mylistView(_genres)),
                            if (isMobile)
                              MyTextButton(
                                  press: () {
                                    activeID.value = _genre;
                                    indexValue.value = 4;
                                  },
                                  title: _genre),
                          ],
                        )),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Text(
                      S.of(context).song + ": " + _songsnum.toString(),
                      style: nomalText,
                    ),
                  ),
                  if (!isMobile)
                    SizedBox(
                      height: 5,
                    ),
                  if (!isMobile)
                    Container(
                      child: Text(
                        S.of(context).dration +
                            ": " +
                            formatDuration(_duration),
                        style: nomalText,
                      ),
                    ),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          S.of(context).playCount +
                              ": " +
                              _playCount.toString(),
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
                                        id: activeID.value, type: 'album');
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
                                        id: activeID.value, type: 'album');
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
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 228,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
            SizedBox(
              height: 20,
            ),
            songsHeaderWidget()
          ],
        ),
        contentWidget: songsBuildWidget(_songs, context, widget.player));
  }
}
