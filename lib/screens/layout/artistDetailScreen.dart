import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../util/dbProvider.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';
import '../common/myStructure.dart';
import '../common/myTextButton.dart';

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
  bool _star = false;

  _getAlbums(String artistId) async {
    final _albumsList = await DbProvider.instance.getAlbums(artistId);
    if (_albumsList != null) {
      final _artistList = await DbProvider.instance.getArtistsByID(artistId);
      var _favorite = await DbProvider.instance.getFavoritebyId(artistId);
      if (_favorite != null) {
        _star = true;
      } else {
        _star = false;
      }

      for (var element in _albumsList) {
        Albums _xx = element;
        _playCount += _xx.playCount;
        _duration += _xx.duration;
        _songs += _xx.songCount;
      }
      if (mounted) {
        setState(() {
          _albums = _albumsList;
          _albumsnum = _albumsList.length;
          _artilstname = _artistList[0].name;

          _arturl = _artistList[0].artistImageUrl;
        });
      }
    }
  }

  @override
  initState() {
    super.initState();
    _getAlbums(activeID.value);
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
                  child: Image.network(
                    _arturl,
                    height: screenImageWidthAndHeight,
                    width: screenImageWidthAndHeight,
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded) {
                        return child;
                      }
                      return AnimatedSwitcher(
                        child: frame != null ? child : Image.asset(mylogoAsset),
                        duration: const Duration(milliseconds: imageMilli),
                      );
                    },
                  ),
                )),
            SizedBox(
              width: 15,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: isMobile
                          ? windowsWidth.value -
                              screenImageWidthAndHeight -
                              30 -
                              15
                          : windowsWidth.value -
                              drawerWidth -
                              screenImageWidthAndHeight -
                              30 -
                              15,
                      child: Text(_artilstname,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: titleText2)),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Row(
                      children: [
                        MyTextButton(
                            press: () {
                              indexValue.value = 5;
                            },
                            title: S.of(context).artist),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).album + ": " + _albumsnum.toString(),
                          style: nomalText,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Text(
                      S.of(context).song + ": " + _songs.toString(),
                      style: nomalText,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    child: Text(
                      S.of(context).dration + ": " + formatDuration(_duration),
                      style: nomalText,
                    ),
                  ),
                  Container(
                      child: Row(children: [
                    Text(
                      S.of(context).playCount + ": " + _playCount.toString(),
                      style: nomalText,
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      child: (_star)
                          ? IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: badgeRed,
                                size: 16,
                              ),
                              onPressed: () async {
                                Favorite _favorite = Favorite(
                                    id: activeID.value, type: 'artist');
                                await delStarred(_favorite);
                                await DbProvider.instance
                                    .delFavorite(activeID.value);
                                setState(() {
                                  _star = false;
                                });
                              },
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                color: textGray,
                                size: 16,
                              ),
                              onPressed: () async {
                                Favorite _favorite = Favorite(
                                    id: activeID.value, type: 'artist');
                                await addStarred(_favorite);
                                await DbProvider.instance
                                    .addFavorite(_favorite);
                                setState(() {
                                  _star = true;
                                });
                              },
                            ),
                    )
                  ]))
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderWidget() {
    List<String> _title = [
      S.of(context).album,
      S.of(context).year,
      S.of(context).song,
      S.of(context).dration,
      if (!isMobile) S.of(context).playCount
    ];
    return myRowList(_title, subText);
  }

  Widget _itemBuildWidget() {
    return _albums != null && _albums!.length > 0
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _albums!.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  Albums _tem = _albums![index];
                  List<String> _title = [
                    _tem.title,
                    _tem.year.toString(),
                    _tem.songCount.toString(),
                    formatDuration(_tem.duration),
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
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
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
