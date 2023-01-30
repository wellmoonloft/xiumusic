import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/httpClient.dart';
import '../../util/mycss.dart';
import '../common/myStructure.dart';
import '../common/myToast.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({Key? key}) : super(key: key);
  @override
  _ArtistsScreenState createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  List? _artists;
  int artistsnum = 0;
  List<bool> _star = [];

  _getArtists() async {
    if (_artists == null) {
      final _artistsList = await getArtists();
      if (_artistsList != null) {
        List<Artists> _list = [];
        List<bool> _startem = [];
        for (var _element in _artistsList["index"]) {
          var _temp = _element["artist"];
          for (var element in _temp) {
            String _url = getCoverArt(element["id"]);
            element["artistImageUrl"] = _url;
            if (element["starred"] != null) {
              _startem.add(true);
            } else {
              _startem.add(false);
            }
            Artists _artist = Artists.fromJson(element);
            _list.add(_artist);
          }
        }
        if (mounted) {
          setState(() {
            _artists = _list;
            _star = _startem;
            artistsnum = _artists!.length;
          });
        }
      }
    }
  }

  @override
  initState() {
    super.initState();
    _getArtists();
  }

  Widget _buildTopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(child: Text(S.of(context).artist, style: titleText1)),
        Container(
          child: Text(
            S.of(context).artist + ": " + artistsnum.toString(),
            style: nomalText,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderWidget() {
    List<String> _title = [
      S.of(context).artist,
      S.of(context).album,
      S.of(context).favorite
    ];
    return myRowList(_title, subText);
  }

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

  Widget _itemBuildWidget() {
    return _artists != null && _artists!.length > 0
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _artists!.length,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  Artists _tem = _artists![index];

                  return ListTile(
                      title: InkWell(
                          onTap: () {
                            activeID.value = _tem.id;
                            indexValue.value = 9;
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _tem.name,
                                    textDirection: TextDirection.ltr,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: nomalText,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _tem.albumCount.toString(),
                                    textDirection: TextDirection.rtl,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: nomalText,
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: (_star[index])
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.favorite,
                                                color: badgeRed,
                                                size: 16,
                                              ),
                                              onPressed: () async {
                                                Favorite _favorite = Favorite(
                                                    id: _tem.id,
                                                    type: 'artist');
                                                await delStarred(_favorite);
                                                MyToast.show(
                                                    context: context,
                                                    message: S.current.cancel +
                                                        S.current.favorite);
                                                setState(() {
                                                  _star[index] = false;
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
                                                    id: _tem.id,
                                                    type: 'artist');
                                                await addStarred(_favorite);
                                                MyToast.show(
                                                    context: context,
                                                    message: S.current.add +
                                                        S.current.favorite);
                                                setState(() {
                                                  _star[index] = true;
                                                });
                                              },
                                            ),
                                    )),
                              ])));
                }))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 100,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
            SizedBox(height: 25),
            _buildHeaderWidget()
          ],
        ),
        contentWidget: _itemBuildWidget());
  }
}
