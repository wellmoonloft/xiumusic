import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../util/httpClient.dart';
import '../common/myStructure.dart';
import '../common/myTextButton.dart';

class ArtistAlbumScreen extends StatefulWidget {
  const ArtistAlbumScreen({Key? key}) : super(key: key);
  @override
  _ArtistAlbumScreenState createState() => _ArtistAlbumScreenState();
}

class _ArtistAlbumScreenState extends State<ArtistAlbumScreen> {
  List<Albums> _albums = [];
  String _artistname = "";

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
        }
      }

      if (mounted) {
        setState(() {
          _albums = _list;
          _artistname = _artist["name"];
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: isMobile
              ? windowsWidth.value - 30
              : windowsWidth.value - drawerWidth - 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    MyTextButton(
                        press: () {
                          indexValue.value = 9;
                        },
                        title: _artistname),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _itemBuildWidget() {
    //做了个设定取出右边的宽度然后除以180，再向下取整作为多少列，这样保证图片在窗口变大变小的时候不会有太大变化
    double _rightWidth = 0;
    if (isMobile) {
      _rightWidth =
          (windowsHeight.value - bottomHeight - appBarHeight - safeheight) /
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
                            _tem.year == 0
                                ? _tem.title
                                : (_tem.title +
                                    "(" +
                                    _tem.year.toString() +
                                    ")"),
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
        top: 20,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
          ],
        ),
        contentWidget: _itemBuildWidget());
  }
}
