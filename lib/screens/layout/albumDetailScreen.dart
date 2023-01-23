import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:xiumusic/models/myModel.dart';
import '../../generated/l10n.dart';
import '../../util/dbProvider.dart';
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
  List? _songs;
  int _songsnum = 0;
  int _playCount = 0;
  int _duration = 0;
  String _albumsname = "";
  String _artistID = "";
  String _genre = "";
  String _arturl = "https://s2.loli.net/2023/01/08/8hBKyu15UDqa9Z2.jpg";
  String _artist = "";
  int _year = 0;
  bool _star = false;

  _getSongs(String albumId) async {
    final _albumtem = await DbProvider.instance.getAlbumsByID(albumId);
    if (_albumtem != null && _albumtem.length > 0) {
      final _songsList = await DbProvider.instance.getSongsByAlbumId(albumId);

      if (_songsList != null) {
        var _favorite = await DbProvider.instance.getFavoritebyId(albumId);
        if (_favorite != null) {
          _star = true;
        } else {
          _star = false;
        }
        Albums _albums = _albumtem[0];
        if (mounted) {
          setState(() {
            _songs = _songsList;
            _songsnum = _albums.songCount;
            _albumsname = _albums.title;
            _playCount = _albums.playCount;
            _duration = _albums.duration;
            _year = _albums.year;
            _artist = _albums.artist;
            _artistID = _albums.artistId;
            _genre = _albums.genre;
            _arturl = _albums.coverUrl;
          });
        }
      }
    }
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: _arturl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return AnimatedSwitcher(
                        child: Image.asset(mylogoAsset),
                        duration: const Duration(milliseconds: imageMilli),
                      );
                    },
                  ),
                )),
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
                      child: Text(_albumsname,
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
                          width: 10,
                        ),
                        MyTextButton(
                            press: () {
                              activeID.value = _artistID;
                              indexValue.value = 9;
                            },
                            title: _artist),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        S.of(context).year + ": " + _year.toString(),
                        style: nomalText,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _genre == "0"
                          ? Container()
                          : MyTextButton(
                              press: () {}, title: S.of(context).genres),
                      _genre == "0"
                          ? Container()
                          : SizedBox(
                              width: 10,
                            ),
                      _genre == "0"
                          ? Container()
                          : MyTextButton(press: () {}, title: _genre),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Text(
                      S.of(context).song + ": " + _songsnum.toString(),
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
                                    await DbProvider.instance
                                        .delFavorite(activeID.value);
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
                                    await DbProvider.instance
                                        .addFavorite(_favorite);
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

  Widget _buildHeaderWidget() {
    List<String> _title = [
      S.of(context).song,
      S.of(context).dration,
      S.of(context).bitRange,
      S.of(context).playCount
    ];
    return myRowList(_title, subText);
  }

  Widget _itemBuildWidget() {
    return _songs != null && _songs!.length > 0
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _songs!.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  Songs _tem = _songs![index];
                  List<String> _title = [
                    _tem.title,
                    formatDuration(_tem.duration),
                    _tem.bitRate.toString(),
                    _tem.playCount.toString(),
                  ];
                  return ListTile(
                      title: InkWell(
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
                                    (value.isNotEmpty &&
                                            value["value"] == _tem.id)
                                        ? activeText
                                        : nomalText);
                              }))));
                }))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 238,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
            SizedBox(
              height: 20,
            ),
            _buildHeaderWidget()
          ],
        ),
        contentWidget: _itemBuildWidget());
  }
}
