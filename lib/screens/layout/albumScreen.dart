import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/httpClient.dart';
import '../../util/mycss.dart';
import '../common/myStructure.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({Key? key}) : super(key: key);
  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  List<Albums> _albums = [];
  int _albumsnum = 0;
  String? _selectOrder;
  int _offset = 0;
  int _size = 500;
  List<DropdownMenuItem<String>> _sortOrder = [];

  _getAllAlbums() async {
    final _albumsList;
    if (_selectOrder != null && _selectOrder == "random" ||
        _selectOrder == "newest" ||
        _selectOrder == "recent" ||
        _selectOrder == "frequent") {
      _albumsList = await getAlbumList(_selectOrder!, "", _offset, _size);
    } else {
      _albumsList = await getAlbumList(
          "byGenre", _selectOrder!.replaceAll("&", "%26"), _offset, _size);
    }

    List<Albums> _list = [];
    if (_albumsList != null && _albumsList.length > 0) {
      for (var _element in _albumsList) {
        String _url = getCoverArt(_element["id"]);
        _element["coverUrl"] = _url;
        Albums _album = Albums.fromJson(_element);

        _list.add(_album);
        _albumsnum++;
      }
      if (_list.length / _size == 1 && _selectOrder != "random") {
        setState(() {
          _albums.addAll(_list);
          _offset += _size;
        });
        _getAllAlbums();
      } else {
        if (mounted) {
          setState(() {
            _albums.addAll(_list);
            _offset = 0;
          });
        }
      }
    }
  }

  _getGenres() async {
    final _genresList = await getGenres();
    _sortOrder = [
      DropdownMenuItem(
          value: "random",
          child: Text(
            S.current.random,
            style: nomalText,
          )),
      DropdownMenuItem(
          value: "newest",
          child: Text(
            S.current.last + S.current.add,
            style: nomalText,
          )),
      DropdownMenuItem(
          value: "recent",
          child: Text(
            S.current.last + S.current.play,
            style: nomalText,
          )),
      DropdownMenuItem(
          value: "frequent",
          child: Text(
            S.current.most + S.current.play,
            style: nomalText,
          ))
    ];
    if (_genresList != null) {
      for (var element in _genresList) {
        Genres _genres = Genres.fromJson(element);
        _sortOrder.add(DropdownMenuItem(
            value: _genres.value,
            child: Text(
              _genres.value + "(" + _genres.albumCount.toString() + ")",
              style: nomalText,
            )));
      }
    }
  }

  @override
  initState() {
    if (activeID.value == "1") {
      _selectOrder = "random";
    } else {
      _selectOrder = activeID.value;
    }
    _getGenres();
    _getAllAlbums();
    super.initState();
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

  Widget _buildTopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(child: Text(S.of(context).album, style: titleText1)),
        Text(
          S.of(context).album + ": " + _albumsnum.toString(),
          style: nomalText,
        )
      ],
    );
  }

  Widget _buildChoiceWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_selectOrder != null && _sortOrder.length > 0)
          Container(
              width: 200,
              height: 40,
              child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: badgeDark,
                  ),
                  child: DropdownButton(
                    value: _selectOrder,
                    items: _sortOrder,
                    menuMaxHeight: windowsHeight.value / 2,
                    isDense: true,
                    isExpanded: true,
                    underline: Container(),
                    onChanged: (value) {
                      setState(() {
                        _selectOrder = value.toString();
                      });
                      _albumsnum = 0;
                      _albums.clear();
                      _getAllAlbums();
                    },
                  ))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 120,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
            SizedBox(height: 20),
            _buildChoiceWidget()
          ],
        ),
        contentWidget: _itemBuildWidget());
  }
}
