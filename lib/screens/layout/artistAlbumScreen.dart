import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../generated/l10n.dart';

import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';
import '../common/myStructure.dart';
import '../common/myTextButton.dart';

class ArtistAlbumScreen extends StatefulWidget {
  const ArtistAlbumScreen({Key? key}) : super(key: key);
  @override
  _ArtistAlbumScreenState createState() => _ArtistAlbumScreenState();
}

class _ArtistAlbumScreenState extends State<ArtistAlbumScreen> {
  List<Albums> _albums = [];
  String _artilstname = "";
  int _albumsnum = 0;
  String _arturl = "https://s2.loli.net/2023/01/08/8hBKyu15UDqa9Z2.jpg";
  //增加歌曲数，专辑数还有总时长
  int _songs = 0;
  int _playCount = 0;
  int _duration = 0;
  bool _star = false;

  _getArtist(String artistId) async {
    final _artist = await getArtist(artistId);
    if (_artist != null) {
      List<Albums> _list = [];
      if (_artist != null && _artist.length > 0) {
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
    _getArtist(activeID.value);
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
                  child: Image.network(
                    _arturl,
                    height: screenImageWidthAndHeight,
                    width: screenImageWidthAndHeight,
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) {
                        return child;
                      }
                      return AnimatedSwitcher(
                        child: frame != null ? child : Image.asset(mylogoAsset),
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
                        MyTextButton(
                            press: () {
                              indexValue.value = 9;
                            },
                            title: _artilstname),
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

  Widget _itemBuildWidget() {
    //做了个设定取出右边的宽度然后除以180，再向下取整作为多少列，这样保证图片在窗口变大变小的时候不会有太大变化
    double _rightWidth = 0;
    if (isMobile) {
      _rightWidth =
          (windowsHeight.value - bottomHeight - appBarHeight - 40 - 25 - 80) /
              screenImageWidthAndHeight;
    } else {
      _rightWidth =
          (windowsWidth.value - drawerWidth) / screenImageWidthAndHeight;
    }

    int _count = _rightWidth.truncate();

    return Container(
      color: bkColor,
      child: _albums.length > 0
          ? MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: MasonryGridView.count(
                crossAxisCount: _count,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                itemCount: _albums.length,
                itemBuilder: (context, index) {
                  Albums _tem = _albums[index];
                  return InkWell(
                      onTap: () {
                        activeID.value = _tem.id;
                        indexValue.value = 8;
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: _tem.coverUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return AnimatedSwitcher(
                                  child: Image.asset(mylogoAsset),
                                  duration:
                                      const Duration(milliseconds: imageMilli),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              child: Text(
                            _tem.title + "(" + _tem.year.toString() + ")",
                            style: nomalText,
                            textAlign: TextAlign.center,
                          )),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              child: Text(_tem.artist,
                                  style: subText, textAlign: TextAlign.center))
                        ],
                      ));
                },
              ))
          : Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 180,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
          ],
        ),
        contentWidget: _itemBuildWidget());
  }
}
