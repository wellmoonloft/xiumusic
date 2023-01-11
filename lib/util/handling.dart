// TODO: 设置里面有个强制刷新，绕过服务器状态检查直接删表（除了ServerInfoTable）
// 其他地方的刷新都做成update，但是最好先sacnServerStatus()一下
// 还需要一个app打开的时候自动检测
// 这里有一个bug，就是如果用户在同一文件夹里删除一首歌后又添加一首歌，返回的结果也是不需要更新
// 不过这个几乎是小概率事件，同时在设置里面提供一个绕过服务器状态检查的暴力更新即可

import '../models/myModel.dart';
import 'baseDB.dart';
import 'httpClient.dart';

//0.对比服务器变化是否要更新
sacnServerStatus() async {
  final _net = await getServerStatus();
  ServerStatus _netstatus = ServerStatus.fromJson(_net);

  final _database = await BaseDB.instance.getServerStatus();

  if (_database == null) {
    //新数据库，需要更新
    await BaseDB.instance.addServerStatus(_netstatus);
    return true;
  } else {
    ServerStatus _databasestatus = _database;
    if (_netstatus.count == _databasestatus.count &&
        _netstatus.folderCount == _databasestatus.folderCount) {
      //不需要更新
      return false;
    } else {
      await BaseDB.instance.addServerStatus(_netstatus);
      return true;
    }
  }
}

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
