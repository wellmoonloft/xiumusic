import 'package:flutter/material.dart';
import '../../util/dbProvider.dart';
import '../../models/myModel.dart';
import '../../util/mycss.dart';
import '../../util/localizations.dart';
import '../common/myStructure.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);
  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  List? _genres;
  int albumsnum = 0;
  int songsnum = 0;
  int genresnum = 0;

  _getGenres() async {
    final _genresList = await DbProvider.instance.getGenres();
    if (_genresList != null) {
      for (var element in _genresList) {
        Genres _tem = element;
        songsnum += _tem.songCount;
        albumsnum += _tem.albumCount;
        genresnum++;
      }
      if (mounted) {
        setState(() {
          _genres = _genresList;
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
        Container(child: Text(genresLocal, style: titleText1)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "$genresLocal: " + genresnum.toString(),
              style: nomalText,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "$albumLocal: " + albumsnum.toString(),
              style: nomalText,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "$songLocal: " + songsnum.toString(),
              style: nomalText,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderWidget() {
    List<String> _title = [nameLocal, albumLocal, songLocal];
    return myRowList(_title, subText);
  }

  Widget _itemBuildWidget() {
    return _genres != null && _genres!.length > 0
        ? Container(
            child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _genres!.length,
                    itemExtent: 50.0, //强制高度为50.0
                    itemBuilder: (BuildContext context, int index) {
                      Genres _tem = _genres![index];
                      List<String> _title = [
                        _tem.value,
                        _tem.albumCount.toString(),
                        _tem.songCount.toString()
                      ];
                      return ListTile(title: myRowList(_title, nomalText));
                    })))
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
