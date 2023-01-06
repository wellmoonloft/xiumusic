import 'package:flutter/material.dart';
import '../../models/notifierValue.dart';
import '../../util/baseCSS.dart';
import '../../util/httpClient.dart';
import '../../util/util.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  //Map _library;
  //List _genres1;
  List _artlist = [];
  List _artdiretory = [];
  List _artlistdiretory = [];
  int? _lastModified;
  int _dir = 0;
  String _title = "选择目录";
  String _subtitle = "";
  String _parent = "";

  _getIndexes() async {
    Map _library = await getIndexes();
    setState(() {
      for (var _element in _library["index"]) {
        var _temp = _element["artist"];
        for (var _element1 in _temp) {
          _artlist.add(_element1);
        }
      }
      _lastModified = _library["lastModified"];
    });
  }

  _getMusicDirectory(String _id) async {
    Map _diretory = await getMusicDirectory(_id);
    setState(() {
      if (_dir == 0) {
        _artdiretory = _diretory["child"];
        print(_diretory["name"]);
        _title = _diretory["name"];
        String _albumCount = _diretory["albumCount"].toString();
        String _playCount = _diretory["playCount"].toString() == "null"
            ? "0"
            : _diretory["playCount"].toString();
        _subtitle = "专辑总数：" + _albumCount + "  播放总次数：" + _playCount;
        _dir = 1;
        _parent = _diretory["parent"].toString();
      } else if (_dir == 1) {
        _artlistdiretory = _diretory["child"];
        _title = _diretory["name"];
        String _songCount = _diretory["songCount"].toString();
        String _playCount = _diretory["playCount"].toString() == "null"
            ? "0"
            : _diretory["playCount"].toString();
        _subtitle = "歌曲总数：" + _songCount + "  播放总次数：" + _playCount;
        _dir = 2;
        _parent = _diretory["parent"].toString();
      }
    });
  }

  _getMusicDirectory1(String _id) async {
    if (_dir == 1) {
      _getIndexes();
      setState(() {
        _dir = 0;
        _title = "选择目录";
        _subtitle = "";
      });
    } else if (_dir == 2) {
      Map _diretory = await getMusicDirectory(_id);

      setState(() {
        _artdiretory = _diretory["child"];
        print(_diretory["name"]);
        _title = _diretory["name"];
        String _albumCount = _diretory["albumCount"].toString();
        String _playCount = _diretory["playCount"].toString() == "null"
            ? "0"
            : _diretory["playCount"].toString();
        _subtitle = "专辑总数：" + _albumCount + "  播放总次数：" + _playCount;
        _dir = 1;
        _parent = _diretory["parent"].toString();
      });
    }
  }

  @override
  initState() {
    super.initState();
    _getIndexes();
  }

  Widget _itemBuildWidget1() {
    switch (_dir) {
      case 0:
        return _artlist.length > 0
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _artlist.length + 1,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  if (index < 1) {
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
                          child: Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                "专辑",
                                textDirection: TextDirection.rtl,
                                style: nomalText,
                              )),
                        )
                      ],
                    );
                  } else {
                    Map _tem = _artlist[index - 1];
                    return ListTile(
                        title: InkWell(
                            onTap: () {
                              //print(_tem["id"]);
                              _getMusicDirectory(_tem["id"]);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _tem["name"].toString(),
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
                              ],
                            )));
                  }
                })
            : Container();

      case 1:
        return _artdiretory.length > 0
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _artdiretory.length + 1,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  if (index < 1) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "专辑名",
                                textDirection: TextDirection.ltr,
                                style: nomalText,
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(right: 20),
                              child: Text(
                                "总时长",
                                textDirection: TextDirection.rtl,
                                style: nomalText,
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                "年度",
                                textDirection: TextDirection.rtl,
                                style: nomalText,
                              ),
                            )),
                        Expanded(
                          flex: 1,
                          child: Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                "播放",
                                textDirection: TextDirection.rtl,
                                style: nomalText,
                              )),
                        )
                      ],
                    );
                  } else {
                    Map _tem = _artdiretory[index - 1];
                    return ListTile(
                        title: InkWell(
                            onTap: () {
                              //print(_tem["id"]);
                              _getMusicDirectory(_tem["id"]);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _tem["name"].toString(),
                                    textDirection: TextDirection.ltr,
                                    style: nomalText,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    formatDuration(_tem["duration"]),
                                    textDirection: TextDirection.rtl,
                                    style: nomalText,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _tem["year"].toString(),
                                    textDirection: TextDirection.rtl,
                                    style: nomalText,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _tem["playCount"].toString() == "null"
                                        ? "0"
                                        : _tem["playCount"].toString(),
                                    textDirection: TextDirection.rtl,
                                    style: nomalText,
                                  ),
                                ),
                              ],
                            )));
                  }
                })
            : Container();

      case 2:
        return _artlistdiretory.length > 0
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _artlistdiretory.length + 1,
                itemExtent: 50.0, //强制高度为50.0
                itemBuilder: (BuildContext context, int index) {
                  if (index < 1) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "歌名",
                                textDirection: TextDirection.ltr,
                                style: nomalText,
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(right: 20),
                              child: Text(
                                "时长",
                                textDirection: TextDirection.rtl,
                                style: nomalText,
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                "比特率",
                                textDirection: TextDirection.rtl,
                                style: nomalText,
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                "年度",
                                textDirection: TextDirection.rtl,
                                style: nomalText,
                              ),
                            )),
                        Expanded(
                          flex: 1,
                          child: Container(
                              padding: EdgeInsets.only(right: 15),
                              child: Text(
                                "播放",
                                textDirection: TextDirection.rtl,
                                style: nomalText,
                              )),
                        )
                      ],
                    );
                  } else {
                    Map _tem = _artlistdiretory[index - 1];
                    return ListTile(
                        title: InkWell(
                            onTap: () {
                              activeSongValue.value = _tem["id"];
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    _tem["title"].toString(),
                                    textDirection: TextDirection.ltr,
                                    style: nomalText,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    formatDuration(_tem["duration"]),
                                    textDirection: TextDirection.rtl,
                                    style: nomalText,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _tem["bitRate"].toString() + "kbps",
                                    textDirection: TextDirection.rtl,
                                    style: nomalText,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _tem["year"].toString(),
                                    textDirection: TextDirection.rtl,
                                    style: nomalText,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _tem["playCount"].toString() == "null"
                                        ? "0"
                                        : _tem["playCount"].toString(),
                                    textDirection: TextDirection.rtl,
                                    style: nomalText,
                                  ),
                                ),
                              ],
                            )));
                  }
                })
            : Container();

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(_title, maxLines: 1, style: titleText1),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                      "更新于: " +
                          timestampToDateStr(
                            _lastModified ?? 1,
                          ),
                      textDirection: TextDirection.rtl,
                      style: subText),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_subtitle, style: subText),
                SizedBox(
                  width: 15,
                ),
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration: circularBorder,
                    child: InkWell(
                      onTap: () {
                        print(_dir);
                        if (_dir > 0) {
                          _getMusicDirectory1(_parent);
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.expand_less,
                            size: 15,
                            color: kGrayColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("上一级", style: subText),
                        ],
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(height: _size.height - 286.6, child: _itemBuildWidget1())
          ],
        ));
  }
}
