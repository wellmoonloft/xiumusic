import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../generated/l10n.dart';
import '../../models/notifierValue.dart';
import '../../models/myModel.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';
import '../../util/mycss.dart';
import '../common/myTextInput.dart';
import '../common/myStructure.dart';

class SearchScreen extends StatefulWidget {
  final AudioPlayer player;
  const SearchScreen({Key? key, required this.player}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final searchController = new TextEditingController();
  late List<Tab> myTabs;
  late TabController tabController;
  List<Songs> _songs = [];
  List<Albums> _albums = [];
  List<Artists> _artists = [];

  _getSongsbyName() async {
    String _title1 = searchController.text;
    String _title2 = "";
    List<Songs> _listSong = [];
    List<Albums> _listAlbums = [];
    List<Artists> _listArtists = [];
    _title2 = await converToTraditional(_title1);
    final _searchData = await search3(_title1);
    final _searchDat2 = await search3(_title2);
    if (_searchData["song"] != null) {
      for (var _element in _searchData["song"]) {
        String _stream = getServerInfo("stream");
        String _url = await getCoverArt(_element["id"]);
        _element["stream"] = _stream + '&id=' + _element["id"];
        _element["coverUrl"] = _url;
        Songs _tem = Songs.fromJson(_element);
        _listSong.add(_tem);
      }
    }
    if (_searchData["album"] != null) {
      for (var _element in _searchData["album"]) {
        String _url = await getCoverArt(_element["id"]);
        _element["coverUrl"] = _url;
        Albums _tem = Albums.fromJson(_element);
        _listAlbums.add(_tem);
      }
    }
    if (_searchData["artist"] != null) {
      for (var _element in _searchData["artist"]) {
        String _url = await getCoverArt(_element["id"]);
        _element["artistImageUrl"] = _url;
        Artists _tem = Artists.fromJson(_element);
        _listArtists.add(_tem);
      }
    }
    if (_searchDat2["song"] != null) {
      for (var _element in _searchDat2["song"]) {
        String _stream = getServerInfo("stream");
        String _url = await getCoverArt(_element["id"]);
        _element["stream"] = _stream + '&id=' + _element["id"];
        _element["coverUrl"] = _url;
        Songs _tem = Songs.fromJson(_element);
        _listSong.add(_tem);
      }
    }
    if (_searchDat2["album"] != null) {
      for (var _element in _searchDat2["album"]) {
        String _url = await getCoverArt(_element["id"]);
        _element["coverUrl"] = _url;
        Albums _tem = Albums.fromJson(_element);
        _listAlbums.add(_tem);
      }
    }
    if (_searchDat2["artist"] != null) {
      for (var _element in _searchDat2["artist"]) {
        String _url = await getCoverArt(_element["id"]);
        _element["artistImageUrl"] = _url;
        Artists _tem = Artists.fromJson(_element);
        _listArtists.add(_tem);
      }
    }
    if (mounted) {
      setState(() {
        _songs = _listSong;
        _albums = _listAlbums;
        _artists = _listArtists;
        myTabs = <Tab>[
          Tab(text: S.current.song + "(" + _songs.length.toString() + ")"),
          Tab(text: S.current.album + "(" + _albums.length.toString() + ")"),
          Tab(text: S.current.artist + "(" + _artists.length.toString() + ")")
        ];
      });
    }
  }

  @override
  initState() {
    super.initState();
    myTabs = <Tab>[
      Tab(text: S.current.song + "(" + _songs.length.toString() + ")"),
      Tab(text: S.current.album + "(" + _albums.length.toString() + ")"),
      Tab(text: S.current.artist + "(" + _artists.length.toString() + ")")
    ];
    tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    searchController.dispose();
    tabController.dispose();
    super.dispose();
  }

  Widget _songHeader() {
    List<String> _title = [
      S.current.song,
      S.current.album,
      S.current.artist,
      S.current.dration
    ];
    return Container(
        height: 30,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        color: bkColor,
        child: myRowList(_title, subText));
  }

  Widget _songsBody() {
    return _songs.length > 0
        ? MediaQuery.removePadding(
            context: context,
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
                    _song.album,
                    _song.artist,
                    if (!isMobile) formatDuration(_song.duration)
                  ];
                  return ListTile(
                      title: InkWell(
                          onTap: () async {
                            if (listEquals(activeList.value, _songs)) {
                              widget.player.seek(Duration.zero, index: index);
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

  Widget _songsWidget() {
    return Column(
      children: [
        _songHeader(),
        Container(
            height: (isMobile)
                ? windowsHeight.value - (106 + bottomHeight + 50 + 25 + 40 + 30)
                : windowsHeight.value - (106 + bottomHeight + 50 + 30),
            child: _songsBody())
      ],
    );
  }

  Widget _artistWidget() {
    return Column(
      children: [
        buildArtistsHeaderWidget(),
        artistBuildWidget(_artists, context)
      ],
    );
  }

  Widget _itemAlbumsWidget() {
    return Column(
      children: [albumHeader(), albumBuildWidget(_albums, context)],
    );
  }

  Widget _buildTopWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextInput(
          control: searchController,
          label: S.of(context).search,
          hintLabel: S.of(context).pleaseInput +
              S.of(context).song +
              S.of(context).name,
          hideText: false,
          icon: Icons.search,
          press: () {
            _getSongsbyName();
          },
          titleStyle: titleText1,
          mainaxis: MainAxisAlignment.start,
          crossaxis: CrossAxisAlignment.end,
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
          _songsWidget(),
          _itemAlbumsWidget(),
          _artistWidget(),
        ]));
  }
}
