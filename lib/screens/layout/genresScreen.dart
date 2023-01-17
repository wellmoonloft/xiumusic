import 'package:flutter/material.dart';
import '../../util/baseDB.dart';
import '../../models/myModel.dart';
import '../common/baseCSS.dart';
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
    final _genresList = await BaseDB.instance.getGenres();
    if (_genresList != null) {
      for (var element in _genresList) {
        Genres _tem = element;
        songsnum += _tem.songCount;
        albumsnum += _tem.albumCount;
        genresnum++;
      }
      setState(() {
        _genres = _genresList;
      });
    }
  }

  @override
  initState() {
    super.initState();
    _getGenres();
  }

  Widget _itemBuildWidget(BuildContext context, int index, List tem) {
    Genres _tem = tem[index];
    return ListTile(
        title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            _tem.value,
            textDirection: TextDirection.ltr,
            style: nomalGrayText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            _tem.albumCount.toString(),
            textDirection: TextDirection.rtl,
            style: nomalGrayText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            _tem.songCount.toString(),
            textDirection: TextDirection.rtl,
            style: nomalGrayText,
          ),
        )
      ],
    ));
  }

  Widget _buildHeaderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              child: Text(
                nameLocal,
                textDirection: TextDirection.ltr,
                style: sublGrayText,
              ),
            )),
        Expanded(
          flex: 1,
          child: Text(
            albumLocal,
            textDirection: TextDirection.rtl,
            style: sublGrayText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
              child: Text(
            songLocal,
            textDirection: TextDirection.rtl,
            style: sublGrayText,
          )),
        )
      ],
    );
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
              style: nomalGrayText,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "$albumLocal: " + albumsnum.toString(),
              style: nomalGrayText,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "$songLocal: " + songsnum.toString(),
              style: nomalGrayText,
            ),
          ],
        ),
      ],
    );
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
      contentWidget: _genres != null && _genres!.length > 0
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
                        return _itemBuildWidget(context, index, _genres!);
                      })))
          : Container(),
    );
  }
}
