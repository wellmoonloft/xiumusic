import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/httpClient.dart';
import '../../util/mycss.dart';
import '../common/myStructure.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);
  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  List<Genres> _genres = [];
  int albumsnum = 0;
  int songsnum = 0;
  int genresnum = 0;

  _getGenres() async {
    final _genresList = await getGenres();
    if (_genresList != null) {
      List<Genres> _genreslist = [];
      for (var element in _genresList) {
        Genres _genres = Genres.fromJson(element);
        _genreslist.add(_genres);
        songsnum += _genres.songCount;
        albumsnum += _genres.albumCount;
        genresnum++;
      }
      if (mounted) {
        setState(() {
          _genres = _genreslist;
        });
      }
    }
  }

  @override
  initState() {
    super.initState();
    _getGenres();
  }

  Widget _buildTopWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(child: Text(S.of(context).genres, style: titleText1)),
        if (!isMobile)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                S.of(context).genres + ": " + genresnum.toString(),
                style: nomalText,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                S.of(context).album + ": " + albumsnum.toString(),
                style: nomalText,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                S.of(context).song + ": " + songsnum.toString(),
                style: nomalText,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildHeaderWidget() {
    List<String> _title = [
      S.of(context).name,
      S.of(context).album,
      S.of(context).song
    ];
    return myRowList(_title, subText);
  }

  Widget _itemBuildWidget() {
    return _genres.length > 0
        ? Container(
            child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _genres.length,
                    itemExtent: 50.0, //强制高度为50.0
                    itemBuilder: (BuildContext context, int index) {
                      Genres _tem = _genres[index];
                      List<String> _title = [
                        _tem.value,
                        _tem.albumCount.toString(),
                        _tem.songCount.toString()
                      ];
                      return ListTile(
                          title: InkWell(
                              onTap: () {
                                activeID.value = _tem.value;
                                indexValue.value = 4;
                              },
                              child: myRowList(_title, nomalText)));
                    })))
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return MyStructure(
        top: (isMobile) ? 120 : 100,
        headerWidget: Column(
          children: [
            _buildTopWidget(),
            if (isMobile)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).genres + ": " + genresnum.toString(),
                    style: nomalText,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    S.of(context).album + ": " + albumsnum.toString(),
                    style: nomalText,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    S.of(context).song + ": " + songsnum.toString(),
                    style: nomalText,
                  ),
                ],
              ),
            SizedBox(height: 25),
            _buildHeaderWidget()
          ],
        ),
        contentWidget: _itemBuildWidget());
  }
}
