import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/dbProvider.dart';
import '../../util/util.dart';
import '../../util/mycss.dart';
import '../common/myStructure.dart';

class FavoriteScreen extends StatefulWidget {
  final AudioPlayer player;
  const FavoriteScreen({Key? key, required this.player}) : super(key: key);
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<Tab> myTabs = <Tab>[Tab(text: ''), Tab(text: ''), Tab(text: '')];
  List<Songs> _songs = [];
  List<Albums> _albums = [];
  List<Artists> _artists = [];

  _getFavorite() async {
    var _favorite = await DbProvider.instance.getFavorite();

    if (_favorite != null) {
      List<Songs> _songs1 = [];
      List<Albums> _albums1 = [];
      List<Artists> _artists1 = [];
      for (var _element in _favorite) {
        Favorite _tem = _element;
        if (_tem.type == "song") {
          Songs _song = await DbProvider.instance.getSongById(_tem.id);
          _songs1.add(_song);
        } else if (_tem.type == "album") {
          var _albumsList = await DbProvider.instance.getAlbumsByID(_tem.id);
          Albums album = _albumsList[0];
          _albums1.add(album);
        } else if (_tem.type == "artist") {
          var _artistsList = await DbProvider.instance.getArtistsByID(_tem.id);
          Artists artist = _artistsList[0];
          _artists1.add(artist);
        }
      }
      setState(() {
        _songs = _songs1;
        _albums = _albums1;
        _artists = _artists1;
      });
    }
  }

  @override
  initState() {
    super.initState();
    myTabs = <Tab>[
      Tab(text: S.current.song),
      Tab(text: S.current.album),
      Tab(text: S.current.artist)
    ];
    tabController = TabController(length: myTabs.length, vsync: this);
    _getFavorite();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget _buildArtistsHeaderWidget() {
    List<String> _title = [S.of(context).artist, S.of(context).album];
    return Container(
        height: 30,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        color: bkColor,
        child: myRowList(_title, subText));
  }

  Widget _buildAlbumHeaderWidget() {
    List<String> _title = [
      S.of(context).album,
      S.of(context).year,
      S.of(context).song,
      S.of(context).dration,
      S.of(context).playCount
    ];
    return Container(
        height: 30,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        color: bkColor,
        child: myRowList(_title, subText));
  }

  Widget _buildSongHeaderWidget() {
    List<String> _title = [
      S.of(context).song,
      S.of(context).dration,
      S.of(context).bitRange,
      S.of(context).playCount
    ];
    return Container(
        height: 30,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        color: bkColor,
        child: myRowList(_title, subText));
  }

  Widget _itemSongsWidget() {
    return Column(
      children: [
        _buildSongHeaderWidget(),
        Container(
          height: (isMobile)
              ? windowsHeight.value - (106 + bottomHeight + 50 + 25 + 40 + 30)
              : windowsHeight.value - (106 + bottomHeight + 50 + 30),
          child: _songs.length > 0
              ? MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _songs.length,
                      itemExtent: 50.0, //强制高度为50.0
                      itemBuilder: (BuildContext context, int index) {
                        Songs _tem = _songs[index];
                        List<String> _title = [
                          _tem.title,
                          _tem.artist,
                          _tem.bitRate.toString(),
                          _tem.playCount.toString(),
                        ];
                        return ListTile(
                            title: InkWell(
                                onTap: () async {
                                  if (listEquals(activeList.value, _songs)) {
                                    widget.player
                                        .seek(Duration.zero, index: index);
                                  } else {
                                    //当前歌曲队列
                                    activeIndex.value = index;
                                    activeSongValue.value = _tem.id;
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
                                                  value["value"] == _tem.id)
                                              ? activeText
                                              : nomalText);
                                    }))));
                      }))
              : Container(),
        )
      ],
    );
  }

  Widget _itemAlbumsWidget() {
    return Column(
      children: [
        _buildAlbumHeaderWidget(),
        Container(
            height: (isMobile)
                ? windowsHeight.value - (106 + bottomHeight + 50 + 25 + 40 + 30)
                : windowsHeight.value - (106 + bottomHeight + 50 + 30),
            child: _albums.length > 0
                ? MediaQuery.removePadding(
                    context: context,
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
                            formatDuration(_tem.duration),
                            _tem.playCount.toString(),
                          ];
                          return ListTile(
                              title: InkWell(
                                  onTap: () {
                                    activeID.value = _tem.id;
                                    indexValue.value = 8;
                                  },
                                  child: myRowList(_title, nomalText)));
                        }))
                : Container())
      ],
    );
  }

  Widget _itemArtistsWidget() {
    return Column(
      children: [
        _buildArtistsHeaderWidget(),
        Container(
            height: (isMobile)
                ? windowsHeight.value - (106 + bottomHeight + 50 + 25 + 40 + 30)
                : windowsHeight.value - (106 + bottomHeight + 50 + 30),
            child: _artists.length > 0
                ? MediaQuery.removePadding(
                    context: context,
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
                : Container())
      ],
    );
  }

  Widget _buildTopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(child: Text(S.of(context).favorite, style: titleText1)),
        Row(
          children: [
            Text(
              S.of(context).song + ": " + _songs.length.toString(),
              style: nomalText,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              S.of(context).album + ": " + _albums.length.toString(),
              style: nomalText,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              S.of(context).artist + ": " + _artists.length.toString(),
              style: nomalText,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 106,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
            Container(
                alignment: Alignment.topLeft,
                child: TabBar(
                    controller: tabController,
                    labelColor: textGray,
                    unselectedLabelColor: borderColor,
                    tabs: myTabs,
                    isScrollable: true,
                    indicatorColor: badgeRed)),
          ],
        ),
        contentWidget: TabBarView(controller: tabController, children: [
          _itemSongsWidget(),
          _itemAlbumsWidget(),
          _itemArtistsWidget()
        ]));
  }
}
