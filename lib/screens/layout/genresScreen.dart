import 'package:flutter/material.dart';
import '../../util/baseDB.dart';
import '../../models/myModel.dart';
import '../../util/baseCSS.dart';
import '../../util/httpClient.dart';
import '../../util/localizations.dart';
import '../components/rightHeader.dart';
import '../components/textButtom.dart';

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

  _getFromNet() async {
    final _genresList = await getGenres();
    List<Genres> _list = [];
    for (dynamic element in _genresList) {
      Genres _tem = Genres.fromJson(element);
      _list.add(_tem);
      songsnum += _tem.songCount;
      albumsnum += _tem.albumCount;
      genresnum++;
    }
    await BaseDB.instance.addGenres(_list);
    setState(() {
      _genres = _list;
    });
  }

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
    } else {
      _getFromNet();
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
                style: nomalGrayText,
              ),
            )),
        Expanded(
          flex: 1,
          child: Text(
            albumLocal,
            textDirection: TextDirection.rtl,
            style: nomalGrayText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
              child: Text(
            songLocal,
            textDirection: TextDirection.rtl,
            style: nomalGrayText,
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
            SizedBox(
              width: 10,
            ),
            TextButtom(
              press: () {
                albumsnum = 0;
                songsnum = 0;
                genresnum = 0;
                _getFromNet();
              },
              title: refreshLocal,
              isActive: false,
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RightHeader(
      top: 100,
      headerWidget: Column(
        children: [
          _buildTopWidget(),
          SizedBox(height: 24),
          _buildHeaderWidget()
        ],
      ),
      contentWidget: _genres != null && _genres!.length > 0
          ? Container(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _genres!.length,
                  itemExtent: 50.0, //强制高度为50.0
                  itemBuilder: (BuildContext context, int index) {
                    return _itemBuildWidget(context, index, _genres!);
                  }))
          : Container(),
    );
  }
}
