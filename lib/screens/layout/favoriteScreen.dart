import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/httpClient.dart';
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
    final _favoriteList = await getStarred();
    if (_favoriteList != null) {
      var songs = _favoriteList["song"];
      var albums = _favoriteList["album"];
      var artists = _favoriteList["artist"];
      List<Songs> _songs1 = [];
      List<Albums> _albums1 = [];
      List<Artists> _artists1 = [];

      if (songs != null && songs.length > 0) {
        for (var _song in songs) {
          String _stream = await getServerInfo("stream");
          String _url = await getCoverArt(_song["id"]);
          _song["stream"] = _stream + '&id=' + _song["id"];
          _song["coverUrl"] = _url;
          _songs1.add(Songs.fromJson(_song));
        }
      }
      if (albums != null && albums.length > 0) {
        for (var _album in albums) {
          String _url = await getCoverArt(_album["id"]);
          _album["coverUrl"] = _url;
          _albums1.add(Albums.fromJson(_album));
        }
      }
      if (artists != null && artists.length > 0) {
        for (var _artist in artists) {
          String _url = await getCoverArt(_artist["id"]);
          _artist["artistImageUrl"] = _url;

          _artists1.add(Artists.fromJson(_artist));
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

  Widget _itemSongsWidget() {
    return Column(
      children: [
        buildSongHeaderWidget(),
        Container(
            height: (isMobile)
                ? windowsHeight.value - (106 + bottomHeight + 50 + 25 + 40 + 30)
                : windowsHeight.value - (106 + bottomHeight + 50 + 30),
            child: songsBuildWidget(_songs, context, widget.player))
      ],
    );
  }

  Widget _itemAlbumsWidget() {
    return Column(
      children: [buildAlbumHeaderWidget(), albumBuildWidget(_albums, context)],
    );
  }

  Widget _itemArtistsWidget() {
    return Column(
      children: [
        buildArtistsHeaderWidget(),
        artistBuildWidget(_artists, context)
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
