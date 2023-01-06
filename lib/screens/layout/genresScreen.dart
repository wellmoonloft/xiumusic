import 'package:flutter/material.dart';
import '../../models/baseDB.dart';
import '../../models/myModel.dart';
import '../../util/baseCSS.dart';
import '../../util/httpClient.dart';
import '../components/text_buttom.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);
  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  List? _genres;

  _getFromNet() async {
    final _genresList = await getGenres();
    List<Genres> _list = [];
    for (dynamic element in _genresList) {
      Genres _tem = Genres.fromJson(element);
      _list.add(_tem);
    }
    await BaseDB.instance.addGenres(_list);
    setState(() {
      _genres = _list;
    });
  }

  _getGenres() async {
    final _genresList = await BaseDB.instance.getGenres();
    if (_genresList != null) {
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
            style: nomalText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            _tem.albumCount.toString(),
            textDirection: TextDirection.rtl,
            style: nomalText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            _tem.songCount.toString(),
            textDirection: TextDirection.rtl,
            style: nomalText,
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
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "名称",
                textDirection: TextDirection.ltr,
                style: nomalText,
              ),
            )),
        Expanded(
          flex: 1,
          child: Text(
            "专辑",
            textDirection: TextDirection.rtl,
            style: nomalText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.only(right: 15),
              child: Text(
                "歌曲",
                textDirection: TextDirection.rtl,
                style: nomalText,
              )),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Container(
                height: 100,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("流派", style: titleText1),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                (_genres != null)
                                    ? _genres!.length.toString()
                                    : "0",
                                style: nomalText,
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(0),
                          child: TextButtom(
                            press: () {
                              _getFromNet();
                            },
                            title: "刷新",
                            isActive: false,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    _buildHeaderWidget()
                  ],
                )),
            SizedBox(
              height: 15,
            ),
            Container(
                height: _size.height - 250.2,
                child: _genres != null && _genres!.length > 0
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _genres!.length,
                        itemExtent: 50.0, //强制高度为50.0
                        itemBuilder: (BuildContext context, int index) {
                          return _itemBuildWidget(context, index, _genres!);
                        })
                    : Container())
          ],
        ));
  }
}
