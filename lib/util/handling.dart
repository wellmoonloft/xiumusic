//业务逻辑

//这里需要再加一个检查，当用户把歌曲删除的时候，加一个弹窗提示强制刷新，或者自动刷新
//专辑和艺人那边也是，如果整张专辑和整个艺人的歌全都删掉了，就需要刷新数据库
//应该写个异步去操作这个事

//这个接口应该可以用 getScanStatus
//里面有个count...但是还有问题，万一有人删了一首歌，再加一首歌咋整...

// {
//     "subsonic-response": {
//         "status": "ok",
//         "version": "1.16.1",
//         "type": "navidrome",
//         "serverVersion": "0.48.0 (af5c2b5a)",
//         "scanStatus": {
//             "scanning": false,
//             "count": 1874,
//             "folderCount": 116,
//             "lastScan": "2023-01-09T12:25:08.007176678Z"
//         }
//     }
// }

//去你妈的，就为了这个事要写那么多逻辑，算了吧，自己搭的服务器，自己删了文件不刷新，这不是有毛病么

import '../models/myModel.dart';
import 'baseDB.dart';
import 'httpClient.dart';

//1.流派
getFromNet() async {
  final _genresList = await getGenres();
  List<Genres> _list = [];
  for (dynamic element in _genresList) {
    Genres _tem = Genres.fromJson(element);
    _list.add(_tem);
  }
  await BaseDB.instance.addGenres(_list);
}

//2.艺人/专辑/歌曲
getArtistsFromNet() async {
  List<Artists> _list = [];
  Map _genresList = await getArtists();
  for (var _element in _genresList["index"]) {
    var _temp = _element["artist"];
    for (dynamic _element1 in _temp) {
      if (_element1["artistImageUrl"] == null)
        _element1["artistImageUrl"] = "1";
      Artists _tem = Artists.fromJson(_element1);
      _list.add(_tem);
      getAlbumsFromNet(_tem.id);
    }
  }
  await BaseDB.instance.addArtists(_list);
}

getAlbumsFromNet(String artistId) async {
  List<Albums> _list = [];
  Map _genresList = await getAlbums(artistId);
  for (dynamic _element in _genresList["album"]) {
    if (_element["playCount"] == null) _element["playCount"] = 0;
    if (_element["year"] == null) _element["year"] = 0;
    if (_element["genre"] == null) _element["genre"] = "0";
    Albums _tem = Albums.fromJson(_element);
    _list.add(_tem);
    getSongsFromNet(_tem.id);
  }
  await BaseDB.instance.addAlbums(_list, artistId);
}

getSongsFromNet(String albumId) async {
  List<Songs> _list = [];
  Map _songsList = await getSongs(albumId);

  for (dynamic _element in _songsList["song"]) {
    if (_element["playCount"] == null) _element["playCount"] = 0;
    if (_element["year"] == null) _element["year"] = 0;
    if (_element["genre"] == null) _element["genre"] = "0";
    Songs _tem = Songs.fromJson(_element);
    _list.add(_tem);
  }
  await BaseDB.instance.addSongs(_list, albumId);
}
