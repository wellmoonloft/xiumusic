import 'package:flutter/material.dart';
import 'package:xiumusic/models/myModel.dart';
import '../../util/baseDB.dart';
import '../../models/notifierValue.dart';
import '../../util/baseCSS.dart';
import '../../util/httpClient.dart';
import '../../util/localizations.dart';
import '../../util/util.dart';
import '../components/rightHeader.dart';
import '../components/textButtom.dart';

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
  String _createDate = "2022-11-29T03:15:15.065292936Z";
  String _arturl = "https://s2.loli.net/2023/01/08/8hBKyu15UDqa9Z2.jpg";
  String _artist = "";
  int _year = 0;

  _getSongs(String albumId) async {
    final _songsList = await BaseDB.instance.getSongs(albumId);

    if (_songsList != null) {
      String _xx = await getCoverArt(albumId);
      final xx = await BaseDB.instance.getAlbumsByID(albumId);
      Albums _albums = xx[0];
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
        _createDate = _albums.created;
        _arturl = _xx;
      });
    } else {
      _getSongsFromNet(albumId);
    }
  }

  _getSongsFromNet(String albumId) async {
    List<Songs> _list = [];
    String _xx = await getCoverArt(albumId);
    Map _songsList = await getSongs(albumId);

    for (dynamic _element in _songsList["song"]) {
      if (_element["playCount"] == null) _element["playCount"] = 0;
      if (_element["year"] == null) _element["year"] = 0;
      if (_element["genre"] == null) _element["genre"] = "0";
      Songs _tem = Songs.fromJson(_element);
      _list.add(_tem);
    }
    await BaseDB.instance.addSongs(_list, albumId);
    setState(() {
      _songs = _list;
      _songsnum = _songsList["songCount"];
      _albumsname = _songsList["name"];
      if (_songsList["playCount"] == null) {
        _playCount = 0;
      } else {
        _playCount = _songsList["playCount"];
      }
      if (_songsList["year"] == null) {
        _year = 0;
      } else {
        _year = _songsList["year"];
      }
      if (_songsList["genre"] == null) {
        _genre = "0";
      } else {
        _genre = _songsList["genre"];
      }

      _createDate = _songsList["created"];
      _duration = _songsList["duration"];
      _artistID = _songsList["artistId"];
      _artist = _songsList["artist"];
      _arturl = _xx;
    });
  }

  Widget _buildTopWidget() {
    Size _size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: 180,
                width: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    _arturl,
                    height: 180,
                    width: 180,
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) {
                        return child;
                      }
                      return AnimatedSwitcher(
                        child: frame != null
                            ? child
                            : Image.asset("assets/images/logo.jpg"),
                        duration: const Duration(milliseconds: 2000),
                      );
                    },
                  ),
                )),
            Container(
              padding: leftrightPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: _size.width - 400,
                      padding: EdgeInsets.all(10),
                      child: Text(_albumsname,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: titleText1)),
                  Container(
                    padding: leftrightPadding,
                    child: Row(
                      children: [
                        TextButtom(
                          press: () {
                            indexValue.value = 5;
                          },
                          title: "$artistLocal",
                          isActive: false,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButtom(
                          press: () {
                            activeID.value = _artistID;
                            indexValue.value = 9;
                          },
                          title: _artist,
                          isActive: false,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "$yearLocal: " + _year.toString(),
                          style: nomalGrayText,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButtom(
                          press: () {},
                          title: "$genresLocal",
                          isActive: false,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        _genre == "0"
                            ? Container()
                            : TextButtom(
                                press: () {},
                                title: _genre,
                                isActive: false,
                              ),
                        _genre == "0"
                            ? Container()
                            : SizedBox(
                                width: 10,
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: leftrightPadding,
                    child: Row(
                      children: [
                        Text(
                          "$songLocal: " + _songsnum.toString(),
                          style: nomalGrayText,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "$drationLocal: " + formatDuration(_duration),
                          style: nomalGrayText,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "$playCountLocal: " + _playCount.toString(),
                          style: nomalGrayText,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: leftrightPadding,
                    child: Row(
                      children: [
                        Text(
                          "创建: " + timeISOtoString(_createDate),
                          style: nomalGrayText,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 50,
                          child: TextButtom(
                            press: () {
                              _songsnum = 0;
                              _playCount = 0;
                              _duration = 0;
                              _getSongsFromNet(activeID.value);
                            },
                            title: refreshLocal,
                            isActive: false,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 2,
            child: Container(
              child: Text(
                songLocal,
                textDirection: TextDirection.ltr,
                style: nomalGrayText,
              ),
            )),
        Expanded(
          flex: 1,
          child: Container(
              child: Text(
            drationLocal,
            textDirection: TextDirection.rtl,
            style: nomalGrayText,
          )),
        ),
        Expanded(
          flex: 1,
          child: Container(
              child: Text(
            bitRangeLocal,
            textDirection: TextDirection.rtl,
            style: nomalGrayText,
          )),
        ),
        Expanded(
          flex: 1,
          child: Container(
              child: Text(
            playCountLocal,
            textDirection: TextDirection.rtl,
            style: nomalGrayText,
          )),
        )
      ],
    );
  }

  Widget _itemBuildWidget() {
    return _songs != null && _songs!.length > 0
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _songs!.length,
            itemExtent: 50.0, //强制高度为50.0
            itemBuilder: (BuildContext context, int index) {
              Songs _tem = _songs![index];
              return ListTile(
                  title: InkWell(
                      onTap: () {
                        activeSongValue.value = _tem.id;
                      },
                      child: ValueListenableBuilder<String>(
                          valueListenable: activeSongValue,
                          builder: ((context, value, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _tem.title,
                                    textDirection: TextDirection.ltr,
                                    style: activeSongValue.value == _tem.id
                                        ? activeText
                                        : nomalGrayText,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    formatDuration(_tem.duration),
                                    textDirection: TextDirection.rtl,
                                    style: activeSongValue.value == _tem.id
                                        ? activeText
                                        : nomalGrayText,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _tem.bitRate.toString(),
                                    textDirection: TextDirection.rtl,
                                    style: activeSongValue.value == _tem.id
                                        ? activeText
                                        : nomalGrayText,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _tem.playCount.toString(),
                                    textDirection: TextDirection.rtl,
                                    style: activeSongValue.value == _tem.id
                                        ? activeText
                                        : nomalGrayText,
                                  ),
                                ),
                              ],
                            );
                          }))));
            })
        : Container();
  }

  @override
  initState() {
    super.initState();
    _getSongs(activeID.value);
  }

  @override
  Widget build(BuildContext context) {
    return RightHeader(
        top: 225,
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
