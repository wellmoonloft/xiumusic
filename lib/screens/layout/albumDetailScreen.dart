import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xiumusic/models/myModel.dart';
import '../../util/baseDB.dart';
import '../../models/notifierValue.dart';
import '../common/baseCSS.dart';
import '../../util/httpClient.dart';
import '../../util/localizations.dart';
import '../../util/util.dart';
import '../common/myStructure.dart';
import '../common/textButtom.dart';

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
    final _songsList = await BaseDB.instance.getSongsById(albumId);

    if (_songsList != null) {
      String _xx = await getCoverArt(albumId);
      final xx = await BaseDB.instance.getAlbumsByID(albumId);
      Albums _albums = xx[0];
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
          _createDate = _albums.created;
          _arturl = _xx;
        });
      }
    }
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
                        if (!isMobile.value)
                          SizedBox(
                            width: 10,
                          ),
                        if (!isMobile.value)
                          Text(
                            "$yearLocal: " + _year.toString(),
                            style: nomalGrayText,
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        _genre == "0"
                            ? Container()
                            : TextButtom(
                                press: () {},
                                title: "$genresLocal",
                                isActive: false,
                              ),
                        _genre == "0"
                            ? Container()
                            : SizedBox(
                                width: 10,
                              ),
                        _genre == "0"
                            ? Container()
                            : TextButtom(
                                press: () {},
                                title: _genre,
                                isActive: false,
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
                      ],
                    ),
                  ),
                  if (isMobile.value)
                    SizedBox(
                      height: 10,
                    ),
                  if (isMobile.value)
                    Container(
                      padding: leftrightPadding,
                      child: Row(
                        children: [
                          Text(
                            "$playCountLocal: " + _playCount.toString(),
                            style: nomalGrayText,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "$yearLocal: " + _year.toString(),
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
                        if (!isMobile.value)
                          SizedBox(
                            width: 10,
                          ),
                        if (!isMobile.value)
                          Text(
                            "$playCountLocal: " + _playCount.toString(),
                            style: nomalGrayText,
                          ),
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
                style: sublGrayText,
              ),
            )),
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
            bitRangeLocal,
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
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _tem.title,
                                    textDirection: TextDirection.ltr,
                                    style: (value.isNotEmpty &&
                                            value["value"] == _tem.id)
                                        ? activeText
                                        : nomalGrayText,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    formatDuration(_tem.duration),
                                    textDirection: TextDirection.rtl,
                                    style: (value.isNotEmpty &&
                                            value["value"] == _tem.id)
                                        ? activeText
                                        : nomalGrayText,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _tem.bitRate.toString(),
                                    textDirection: TextDirection.rtl,
                                    style: (value.isNotEmpty &&
                                            value["value"] == _tem.id)
                                        ? activeText
                                        : nomalGrayText,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _tem.playCount.toString(),
                                    textDirection: TextDirection.rtl,
                                    style: (value.isNotEmpty &&
                                            value["value"] == _tem.id)
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
