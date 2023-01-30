import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../generated/l10n.dart';
import '../models/myModel.dart';
import '../models/notifierValue.dart';
import 'util.dart';

//底部高度
const double bottomHeight = 80;
//appbar高度
const double appBarHeight = 40;
//侧拉栏宽度
const double drawerWidth = 160;
//底部图片大小
const double bottomImageWidthAndHeight = 50;
//正常页面图片大小
const double screenImageWidthAndHeight = 180;
//正在播放图片大小
const double playingImageWidthAndHeight = 180;
//图片刷新动画延迟
const int imageMilli = 500;
//logo asset地址
const String mylogoAsset = "assets/images/logo.jpg";
//是不是移动端
late final bool isMobile;

const qing = Color.fromARGB(255, 194, 197, 196);
const hong = Color.fromARGB(255, 185, 64, 65);
const huang = Color.fromARGB(255, 237, 207, 106);
const bai = Color.fromARGB(255, 250, 250, 250);
const xuan = Color.fromARGB(255, 48, 46, 44);

const badgeRed = Color.fromARGB(255, 185, 64, 65);
const badgeDark = Color.fromARGB(255, 52, 53, 54);
const textGray = Color.fromARGB(255, 216, 216, 216);
const rightColor = Color.fromARGB(255, 24, 24, 25);
const bkColor = Colors.black;
const borderColor = Colors.grey;

const updownPadding = EdgeInsets.symmetric(vertical: 15);
const leftrightPadding = EdgeInsets.symmetric(horizontal: 15);
const allPadding = EdgeInsets.all(15);

const titleText1 =
    TextStyle(fontSize: 40, color: textGray, fontWeight: FontWeight.bold);
const titleText2 =
    TextStyle(fontSize: 24, color: textGray, fontWeight: FontWeight.bold);
const titleText3 = TextStyle(fontSize: 20, color: textGray);
const activeText = TextStyle(color: badgeRed, fontSize: 14);
const nomalText = TextStyle(color: textGray, fontSize: 14);
const subText = TextStyle(color: borderColor, fontSize: 12);

BoxDecoration circularBorder = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    border: Border.all(width: 0.2, color: borderColor));

List<Widget> mylistView(List<String> _title, TextStyle _style) {
  List<Widget> _list = [];
  for (var i = 0; i < _title.length; i++) {
    _list.add(Expanded(
      flex: (i == 0) ? 2 : 1,
      child: Text(
        _title[i],
        textDirection: (i == 0) ? TextDirection.ltr : TextDirection.rtl,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: _style,
      ),
    ));
  }
  return _list;
}

Widget myRowList(List<String> _title, TextStyle _style) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: mylistView(_title, _style));
}

Widget songsHeaderWidget() {
  List<String> _title = [
    S.current.song,
    S.current.dration,
    if (!isMobile) S.current.bitRange,
    S.current.playCount
  ];
  return myRowList(_title, subText);
}

Widget buildArtistsHeaderWidget() {
  List<String> _title = [S.current.artist, S.current.album];
  return Container(
      height: 30,
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      color: bkColor,
      child: myRowList(_title, subText));
}

Widget albumHeader() {
  List<String> _title = [
    S.current.album,
    S.current.artist,
    S.current.song,
    if (!isMobile) S.current.dration,
    if (!isMobile) S.current.playCount
  ];
  return Container(
      height: 30,
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      color: bkColor,
      child: myRowList(_title, subText));
}

Widget buildSongHeaderWidget() {
  List<String> _title = [
    S.current.song,
    S.current.dration,
    S.current.bitRange,
    S.current.playCount
  ];
  return Container(
      height: 30,
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      color: bkColor,
      child: myRowList(_title, subText));
}

Widget songsBuildWidget(
    List<Songs> _songs, BuildContext _context, AudioPlayer _player) {
  return _songs.length > 0
      ? MediaQuery.removePadding(
          context: _context,
          removeTop: true,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _songs.length,
              itemExtent: 50.0, //强制高度为50.0
              itemBuilder: (BuildContext context, int index) {
                Songs _song = _songs[index];
                List<String> _title = [
                  _song.title,
                  formatDuration(_song.duration),
                  if (!isMobile)
                    _song.suffix + "[" + _song.bitRate.toString() + "]",
                  _song.playCount.toString(),
                ];
                return ListTile(
                    title: InkWell(
                        onTap: () async {
                          if (listEquals(activeList.value, _songs)) {
                            _player.seek(Duration.zero, index: index);
                          } else {
                            //当前歌曲队列
                            activeIndex.value = index;
                            activeSongValue.value = _song.id;
                            //歌曲所在专辑歌曲List
                            activeList.value = _songs;
                          }
                        },
                        child: ValueListenableBuilder<Map>(
                            valueListenable: activeSong,
                            builder: ((context, value, child) {
                              return myRowList(
                                  _title,
                                  (value.isNotEmpty &&
                                          value["value"] == _song.id)
                                      ? activeText
                                      : nomalText);
                            }))));
              }))
      : Container();
}

Widget artistBuildWidget(List<Artists> _artists, BuildContext _context) {
  return Container(
      height: (isMobile)
          ? windowsHeight.value - (106 + bottomHeight + 50 + 25 + 40 + 30)
          : windowsHeight.value - (106 + bottomHeight + 50 + 30),
      child: _artists.length > 0
          ? MediaQuery.removePadding(
              context: _context,
              removeTop: true,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _artists.length,
                  itemExtent: 50.0, //强制高度为50.0
                  itemBuilder: (BuildContext context, int index) {
                    Artists _tem = _artists[index];
                    List<String> _title = [
                      _tem.name,
                      _tem.albumCount.toString()
                    ];
                    return ListTile(
                        title: InkWell(
                            onTap: () {
                              activeID.value = _tem.id;
                              indexValue.value = 9;
                            },
                            child: myRowList(_title, nomalText)));
                  }))
          : Container());
}

Widget albumBuildWidget(List<Albums> _albums, BuildContext _context) {
  return Container(
      height: (isMobile)
          ? windowsHeight.value - (106 + bottomHeight + 50 + 25 + 40 + 30)
          : windowsHeight.value - (106 + bottomHeight + 50 + 30),
      child: _albums.length > 0
          ? MediaQuery.removePadding(
              context: _context,
              removeTop: true,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _albums.length,
                  itemExtent: 50.0, //强制高度为50.0
                  itemBuilder: (BuildContext context, int index) {
                    Albums _tem = _albums[index];
                    List<String> _title = [
                      _tem.title,
                      _tem.artist.toString(),
                      _tem.songCount.toString(),
                      if (!isMobile) formatDuration(_tem.duration),
                      if (!isMobile) _tem.playCount.toString(),
                    ];
                    return ListTile(
                        title: InkWell(
                            onTap: () {
                              activeID.value = _tem.id;
                              indexValue.value = 8;
                            },
                            child: myRowList(_title, nomalText)));
                  }))
          : Container());
}
