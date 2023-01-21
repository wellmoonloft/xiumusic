import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../util/dbProvider.dart';
import '../../util/localizations.dart';
import '../common/myStructure.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({Key? key}) : super(key: key);
  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  List<Albums>? _albums;
  int _albumsnum = 0;

  _getAllAlbums() async {
    final _albumsList = await DbProvider.instance.getAllAlbums();
    List<Albums> _list = [];
    for (var element in _albumsList) {
      Albums _album = element;
      _list.add(_album);
      _albumsnum++;
    }
    if (mounted) {
      setState(() {
        _albums = _albumsList;
      });
    }
  }

  @override
  initState() {
    super.initState();
    _getAllAlbums();
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
      child: _albums != null && _albums!.length > 0
          ? MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: MasonryGridView.count(
                crossAxisCount: _count,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemCount: _albums!.length,
                itemBuilder: (context, index) {
                  Albums _tem = _albums![index];
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

  Widget _buildTopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(child: Text(albumLocal, style: titleText1)),
        Text(
          "$albumLocal: " + _albumsnum.toString(),
          style: nomalText,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 80,
        headerWidget: Column(
          children: [_buildTopWidget(), SizedBox(height: 20), Container()],
        ),
        contentWidget: _itemBuildWidget());
  }
}
