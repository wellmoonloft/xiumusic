import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/httpClient.dart';
import '../../util/mycss.dart';
import '../common/myAlertDialog.dart';
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(child: Text(S.current.artist, style: titleText1)),
        Container(
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 3),
          decoration: BoxDecoration(
              color: badgeDark,
              borderRadius: const BorderRadius.all(Radius.circular(6))),
          child: Text(
            artistsnum.toString(),
            style: nomalText,
          ),
        ),
      ],
    );
  }

  Widget _artistHeader() {
    List<String> _title = [
      S.current.artist,
      S.current.album,
      S.current.favorite
    ];
    return myRowList(_title, subText);
  }

  List<Widget> _artistBody(List<String> _title, int _index) {
    List<Widget> _list = [];
    for (var i = 0; i < _title.length; i++) {
      if (i == _title.length - 1) {
        _list.add(Expanded(
            flex: 1,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              (_star[_index])
                  ? IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: badgeRed,
                        size: 16,
                      ),
                      onPressed: () async {
                        Favorite _favorite =
                            Favorite(id: _title[i], type: 'artist');
                        await delStarred(_favorite);
                        MyToast.show(
                            context: context,
                            message: S.current.cancel + S.current.favorite);
                        setState(() {
                          _star[_index] = false;
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
                        Favorite _favorite =
                            Favorite(id: _title[i], type: 'artist');
                        await addStarred(_favorite);
                        MyToast.show(
                            context: context,
                            message: S.current.add + S.current.favorite);
                        setState(() {
                          _star[_index] = true;
                        });
                      },
                    ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.share,
                  color: textGray,
                  size: 16,
                ),
                onPressed: () async {
                  final _sharelists = await createShare(_title[i]);
                  if (_sharelists != null && _sharelists.length > 0) {
                    Sharelist _share = Sharelist.fromJson(_sharelists[0]);
                    showShareDialog(_share, context);
                  } else {
                    showMyAlertDialog(
                        context, S.current.failure, S.current.failure);
                  }
                },
              )
            ])));
      } else {
        _list.add(Expanded(
          flex: (i == 0) ? 2 : 1,
          child: Text(
            _title[i],
            textDirection: (i == 0) ? TextDirection.ltr : TextDirection.rtl,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: nomalText,
          ),
        ));
      }
    }
    return _list;
  }

  Widget _artistWidget() {
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
                  List<String> _title = [
                    _tem.name,
                    _tem.albumCount.toString(),
                    _tem.id
                  ];
                  return ListTile(
                      title: InkWell(
                          onTap: () {
                            activeID.value = _tem.id;
                            indexValue.value = 9;
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: _artistBody(_title, index))));
                }))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: 90,
        headerWidget: Column(
          children: [_buildTopWidget(), SizedBox(height: 15), _artistHeader()],
        ),
        contentWidget: _artistWidget());
  }
}
