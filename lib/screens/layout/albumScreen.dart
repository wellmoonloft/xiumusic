import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../common/baseCSS.dart';
import '../../util/baseDB.dart';
import '../../util/httpClient.dart';
import '../../util/localizations.dart';
import '../common/rightHeader.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({Key? key}) : super(key: key);
  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  List<Albums>? _albums;
  List<String>? _imageURL;
  int _albumsnum = 0;

  _getAllAlbums() async {
    final _albumsList = await BaseDB.instance.getAllAlbums();
    List<Albums> _list = [];
    List<String> _listURL = [];
    for (var element in _albumsList) {
      Albums _xx = element;
      String _yy = await getCoverArt(_xx.id);
      _list.add(_xx);
      _listURL.add(_yy);
      _albumsnum++;
    }
    if (mounted) {
      setState(() {
        _albums = _albumsList;
        _imageURL = _listURL;
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
    Size _size = MediaQuery.of(context).size;
    double _rightWidth = 0;
    if (isMobile.value) {
      _rightWidth = (_size.width) / screenImageWidthAndHeight;
    } else {
      _rightWidth = (_size.width - drawerWidth) / screenImageWidthAndHeight;
    }

    int _count = _rightWidth.truncate();
    return Container(
      color: bkColor,
      child: _albums != null && _albums!.length > 0
          ? MasonryGridView.count(
              crossAxisCount: _count,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemCount: _albums!.length,
              itemBuilder: (context, index) {
                Albums _tem = _albums![index];
                String _temURL = _imageURL![index];
                return InkWell(
                    onTap: () {
                      //_getAlbums(_tem.id);
                      activeID.value = _tem.id;
                      indexValue.value = 8;
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: _temURL,
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return AnimatedSwitcher(
                                child: Image.asset("assets/images/logo.jpg"),
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
                                style: nomalGrayText)),
                        SizedBox(
                          height: 5,
                        ),
                        Container(child: Text(_tem.artist, style: sublGrayText))
                      ],
                    ));
              },
            )
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
          style: nomalGrayText,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RightHeader(
        top: 80,
        headerWidget: Column(
          children: [_buildTopWidget(), SizedBox(height: 20), Container()],
        ),
        contentWidget: _itemBuildWidget());
  }
}
