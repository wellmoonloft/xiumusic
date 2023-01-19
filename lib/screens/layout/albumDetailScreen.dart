import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xiumusic/models/myModel.dart';
import '../../util/dbProvider.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../util/httpClient.dart';
import '../../util/localizations.dart';
import '../../util/util.dart';
import '../common/myStructure.dart';
import '../common/myTextButton.dart';

class AlbumDetailScreen extends StatefulWidget {
  const AlbumDetailScreen({
    Key? key,
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
                        child: Image.asset("assets/images/logo.jpg"),
                        duration: const Duration(milliseconds: imageMilli),
                      );
                    },
                  ),
                )),
            Container(
              //padding: EdgeInsets.only(left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: windowsWidth.value / 2,
                      padding: leftrightPadding,
                      child: Text(_albumsname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titleText1)),
                  Container(
                    padding: leftrightPadding,
                    child: Row(
                      children: [
                        MyTextButton(
                            press: () {
                              indexValue.value = 5;
                            },
                            title: "$artistLocal"),
                        SizedBox(
                          width: 10,
                        ),
                        MyTextButton(
                            press: () {
                              activeID.value = _artistID;
                              indexValue.value = 9;
                            },
                            title: _artist),
                        if (!isMobile.value)
                          SizedBox(
                            width: 10,
                          ),
                        if (!isMobile.value)
                          Text(
                            "$yearLocal: " + _year.toString(),
                            style: nomalText,
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        _genre == "0"
                            ? Container()
                            : MyTextButton(press: () {}, title: "$genresLocal"),
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
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: leftrightPadding,
                    child: Row(
                      children: [
                        Text(
                          "$songLocal: " + _songsnum.toString(),
                          style: nomalText,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "$drationLocal: " + formatDuration(_duration),
                          style: nomalText,
                        ),
                      ],
                    ),
                  ),
                  if (isMobile.value)
                    SizedBox(
                      height: 5,
                    ),
                  if (isMobile.value)
                    Container(
                      padding: leftrightPadding,
                      child: Row(
                        children: [
                          Text(
                            "$playCountLocal: " + _playCount.toString(),
                            style: nomalText,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "$yearLocal: " + _year.toString(),
                            style: nomalText,
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: leftrightPadding,
                    child: Row(
                      children: [
                        if (!isMobile.value)
                          Text(
                            "$playCountLocal: " + _playCount.toString(),
                            style: nomalText,
                          ),
                        Container(
                          padding: EdgeInsets.only(left: 5),
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
      songLocal,
      drationLocal,
      bitRangeLocal,
      playCountLocal
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
                            activeSongValue.value = _tem.id;
                            //歌曲所在专辑歌曲List
                            activeList.value = _songs!;
                            //当前歌曲队列
                            activeIndex.value = index;
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
        top: 222,
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
