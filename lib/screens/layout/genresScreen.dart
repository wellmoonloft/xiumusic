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
  int genresnum = 0;

  _getGenres() async {
    final _genresList = await getGenres();
    if (_genresList != null) {
      List<Genres> _genreslist = [];
      for (var element in _genresList) {
        Genres _genres = Genres.fromJson(element);
        _genreslist.add(_genres);
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(child: Text(S.current.genres, style: titleText1)),
        Container(
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 3),
          decoration: BoxDecoration(
              color: badgeDark,
              borderRadius: const BorderRadius.all(Radius.circular(6))),
          child: Text(
            genresnum.toString(),
            style: nomalText,
          ),
        ),
      ],
    );
  }

  Widget _genresHeader() {
    List<String> _title = [S.current.name, S.current.album, S.current.song];
    return myRowList(_title, subText);
  }

  Widget _genresBody() {
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
        top: 90,
        headerWidget: Column(
          children: [_buildTopWidget(), SizedBox(height: 15), _genresHeader()],
        ),
        contentWidget: _genresBody());
  }
}
