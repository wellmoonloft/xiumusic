import 'package:flutter/material.dart';
import '../../models/baseDB.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/baseCSS.dart';
import '../../util/httpClient.dart';
import '../../util/localizations.dart';
import '../../util/util.dart';
import '../components/rightHeader.dart';
import '../components/textButtom.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({Key? key}) : super(key: key);
  @override
  _ArtistsScreenState createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  List? _artists;
  List? _albums;
  List? _songs;
  int _dir = 0;
  int artistsnum = 0;
  int albumsnum = 0;
  int songsnum = 0;
  String _parent = "";
  String _artilstname = "";
  String _albumsname = "";

  _getArtistsFromNet() async {
    List<Artists> _list = [];
    Map _genresList = await getArtists();

    for (var _element in _genresList["index"]) {
      var _temp = _element["artist"];
      for (dynamic _element1 in _temp) {
        Artists _tem = Artists.fromJson(_element1);
        _list.add(_tem);
      }
    }
    await BaseDB.instance.addArtists(_list);
    setState(() {
      _artists = _list;
      artistsnum = _list.length;
    });
  }

  _getAlbumsFromNet(String artistId) async {
    List<Albums> _list = [];
    Map _genresList = await getAlbums(artistId);
    for (dynamic _element in _genresList["album"]) {
      if (_element["playCount"] == null) _element["playCount"] = 0;
      if (_element["year"] == null) _element["year"] = 0;
      Albums _tem = Albums.fromJson(_element);
      _list.add(_tem);
    }
    await BaseDB.instance.addAlbums(_list);
    setState(() {
      _albums = _list;
      albumsnum = _list.length;
      _artilstname = _list[0].artist;
    });
  }

  _getArtists() async {
    if (_artists == null) {
      final _artistsList = await BaseDB.instance.getArtists();
      if (_artistsList != null) {
        setState(() {
          _artists = _artistsList;
          artistsnum = _artistsList.length;
        });
      } else {
        _getArtistsFromNet();
      }
    }
  }

  _getAlbums(String artistId) async {
    final _albumsList = await BaseDB.instance.getAlbums(artistId);
    if (_albumsList != null) {
      setState(() {
        _albums = _albumsList;
        albumsnum = _albumsList.length;
        _artilstname = _albums![0].artist;
      });
    } else {
      _getAlbumsFromNet(artistId);
    }

    setState(() {
      _dir = 1;
      _parent = artistId;
    });
  }

  _setUPLevel(String _id) async {
    if (_dir == 1) {
      await _getArtists();
      setState(() {
        _dir = 0;
      });
    } else if (_dir == 2) {
      await _getAlbums(_id);
      setState(() {
        _dir = 1;
      });
    }
  }

  @override
  initState() {
    super.initState();
    _getArtists();
  }

  Widget _buildHeaderWidget() {
    switch (_dir) {
      case 0:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  child: Text(
                    artistLocal,
                    textDirection: TextDirection.ltr,
                    style: nomalGrayText,
                  ),
                )),
            Expanded(
              flex: 1,
              child: Container(
                  child: Text(
                albumLocal,
                textDirection: TextDirection.rtl,
                style: nomalGrayText,
              )),
            )
          ],
        );

      default:
        return Container();
    }
  }

  Widget _itemBuildWidget() {
    switch (_dir) {
      case 0:
        return _artists != null && _artists!.length > 0
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _artists!.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  Artists _tem = _artists![index];
                  return ListTile(
                      title: InkWell(
                          onTap: () {
                            //_getAlbums(_tem.id);
                            activeID.value = _tem.id;
                            indexValue.value = 9;
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  _tem.name,
                                  textDirection: TextDirection.ltr,
                                  style: nomalGrayText,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  _tem.albumCount.toString(),
                                  textDirection: TextDirection.rtl,
                                  style: nomalGrayText,
                                ),
                              ),
                            ],
                          )));
                })
            : Container();

      default:
        return Container();
    }
  }

  Widget _buildTopWidget() {
    switch (_dir) {
      case 0:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(artistLocal, style: titleText1),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    artistsnum.toString(),
                    style: nomalGrayText,
                  ),
                )
              ],
            ),
            Container(
              child: TextButtom(
                press: () {
                  _getArtists();
                },
                title: refreshLocal,
                isActive: false,
              ),
            )
          ],
        );

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RightHeader(
        top: 155,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration: circularBorder,
                    child: InkWell(
                      onTap: () {
                        if (_dir > 0) {
                          _setUPLevel(_parent);
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.expand_less,
                            size: 15,
                            color: kGrayColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(upLocal, style: nomalGrayText),
                        ],
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            _buildHeaderWidget()
          ],
        ),
        contentWidget: _itemBuildWidget());
  }
}
