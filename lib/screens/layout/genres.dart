import 'package:flutter/material.dart';
import '../../util/basecss.dart';
import '../../util/httpclient.dart';

class Genres extends StatefulWidget {
  const Genres({Key? key}) : super(key: key);
  @override
  _GenresState createState() => _GenresState();
}

class _GenresState extends State<Genres> {
  Map? _genres;
  List? _genres1;

  _getGenres() async {
    _genres = await getGenres();
    setState(() {
      _genres1 = _genres!["genre"];
      //print(_genres1);
    });
  }

  @override
  initState() {
    super.initState();
    _getGenres();
  }

  // 根据index展示不同的widget
  Widget buildItemWidget(BuildContext context, int index, List tem) {
    if (index < 1) {
      return _buildHeaderWidget(context, index);
    } else {
      int itemIndex = index - 1;
      return _itemBuildWidget(context, itemIndex, tem);
    }
  }

  Widget _itemBuildWidget(BuildContext context, int index, List tem) {
    Map _tem = tem[index];
    return ListTile(
        title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            _tem["value"].toString(),
            textDirection: TextDirection.ltr,
            style: nomalText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            _tem["albumCount"].toString(),
            textDirection: TextDirection.rtl,
            style: nomalText,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            _tem["songCount"].toString(),
            textDirection: TextDirection.rtl,
            style: nomalText,
          ),
        )
      ],
    ));
  }

  // header内容
  Widget _buildHeaderWidget(BuildContext context, int index) {
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("流派", style: titleText1),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "12",
                    style: nomalText,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                height: _size.height - 246.2,
                child: _genres1 != null && _genres1!.length > 0
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _genres1!.length + 1,
                        itemExtent: 50.0, //强制高度为50.0

                        itemBuilder: (BuildContext context, int index) {
                          return buildItemWidget(context, index, _genres1!);
                        })
                    : Container())
          ],
        ));
  }
}
