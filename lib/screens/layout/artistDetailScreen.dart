import 'package:flutter/material.dart';
import '../../util/baseDB.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../common/baseCSS.dart';
import '../../util/httpClient.dart';
import '../../util/localizations.dart';
import '../../util/util.dart';
import '../common/rightHeader.dart';
import '../common/textButtom.dart';

class ArtistDetailScreen extends StatefulWidget {
  const ArtistDetailScreen({Key? key}) : super(key: key);
  @override
  _ArtistDetailScreenState createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  List? _albums;
  String _artilstname = "";
  int _albumsnum = 0;
  String _arturl = "https://s2.loli.net/2023/01/08/8hBKyu15UDqa9Z2.jpg";
  //增加歌曲数，专辑数还有总时长
  int _songs = 0;
  int _playCount = 0;
  int _duration = 0;

  _getAlbums(String artistId) async {
    final _albumsList = await BaseDB.instance.getAlbums(artistId);
    if (_albumsList != null) {
      String _artURL = await getCoverArt(artistId);
      final _artistList = await BaseDB.instance.getArtistsByID(artistId);

      for (var element in _albumsList) {
        Albums _xx = element;
        _playCount += _xx.playCount;
        _duration += _xx.duration;
        _songs += _xx.songCount;
      }
      setState(() {
        _albums = _albumsList;
        _albumsnum = _albumsList.length;
        _artilstname = _artistList[0].name;

        _arturl = _artURL;
      });
    } else {
      _getAlbumsFromNet(artistId);
    }
  }

  _getAlbumsFromNet(String artistId) async {
    List<Albums> _list = [];
    String _xx = await getCoverArt(artistId);
    Map _genresList = await getAlbums(artistId);
    for (dynamic _element in _genresList["album"]) {
      if (_element["playCount"] == null) _element["playCount"] = 0;
      if (_element["year"] == null) _element["year"] = 0;
      if (_element["genre"] == null) _element["genre"] = "0";
      Albums _tem = Albums.fromJson(_element);
      _list.add(_tem);
      _playCount += _tem.playCount;
      _duration += _tem.duration;
      _songs += _tem.songCount;
    }
    await BaseDB.instance.addAlbums(_list, artistId);
    setState(() {
      _albums = _list;
      _albumsnum = _list.length;
      _artilstname = _list[0].artist;
      _arturl = _xx;
    });
  }

  @override
  initState() {
    super.initState();
    _getAlbums(activeID.value);
  }

  Widget _itemBuildWidget() {
    return _albums != null && _albums!.length > 0
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _albums!.length,
            itemExtent: 50.0, //强制高度为50.0
            itemBuilder: (BuildContext context, int index) {
              Albums _tem = _albums![index];
              return ListTile(
                  title: InkWell(
                      onTap: () {
                        //_getSongs(_tem.id);
                        activeID.value = _tem.id;
                        indexValue.value = 8;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              _tem.title,
                              textDirection: TextDirection.ltr,
                              style: nomalGrayText,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              _tem.year.toString(),
                              textDirection: TextDirection.rtl,
                              style: nomalGrayText,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              _tem.songCount.toString(),
                              textDirection: TextDirection.rtl,
                              style: nomalGrayText,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              formatDuration(_tem.duration),
                              textDirection: TextDirection.rtl,
                              style: nomalGrayText,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              _tem.playCount.toString(),
                              textDirection: TextDirection.rtl,
                              style: nomalGrayText,
                            ),
                          ),
                        ],
                      )));
            })
        : Container();
  }

  Widget _buildTopWidget() {
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
                      padding: EdgeInsets.all(10),
                      child: Text(_artilstname, style: titleText1)),
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
                          width: 5,
                        ),
                        Text(
                          "$albumLocal: " + _albumsnum.toString(),
                          style: nomalGrayText,
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
                        Text(
                          "$songLocal: " + _songs.toString(),
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
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 50,
                          child: TextButtom(
                            press: () {
                              _songs = 0;
                              _playCount = 0;
                              _duration = 0;
                              _getAlbumsFromNet(activeID.value);
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
            ),
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
                albumLocal,
                textDirection: TextDirection.ltr,
                style: sublGrayText,
              ),
            )),
        Expanded(
          flex: 1,
          child: Container(
              child: Text(
            yearLocal,
            textDirection: TextDirection.rtl,
            style: sublGrayText,
          )),
        ),
        Expanded(
          flex: 1,
          child: Container(
              child: Text(
            songLocal,
            textDirection: TextDirection.rtl,
            style: sublGrayText,
          )),
        ),
        Expanded(
          flex: 1,
          child: Container(
              child: Text(
            drationLocal,
            textDirection: TextDirection.rtl,
            style: sublGrayText,
          )),
        ),
        Expanded(
          flex: 1,
          child: Container(
              child: Text(
            playCountLocal,
            textDirection: TextDirection.rtl,
            style: sublGrayText,
          )),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RightHeader(
        top: 217,
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
