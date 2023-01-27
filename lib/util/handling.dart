import '../models/myModel.dart';
import 'dbProvider.dart';
import 'httpClient.dart';

bool isDBbusy = false;

//0.对比服务器变化是否要更新
//0. Compare server changes and whether to update
sacnServerStatus() async {
  final _net = await getServerStatus();

  if (_net["folderCount"] == null) _net["folderCount"] = 0;
  ServerStatus _netstatus = ServerStatus.fromJson(_net);

  final _database = await DbProvider.instance.getServerStatus();

  if (_database == null) {
    //新数据库，需要更新
    //New database, need to update
    await DbProvider.instance.addServerStatus(_netstatus);
    return true;
  } else {
    ServerStatus _databasestatus = _database;
    if (_netstatus.count == _databasestatus.count) {
      //不需要更新
      //songs count no changed.
      return false;
    } else {
      //need refresh.
      await DbProvider.instance.addServerStatus(_netstatus);
      return true;
    }
  }
}

initialize() async {
  await DbProvider.instance.forchrefresh();
  await getArtistsFromNet();
  await getGenresFromNet();
  await getFavoriteFromNet();
  await getPlaylistsFromNet();
}

//1.流派
getGenresFromNet() async {
  final _genresList = await getGenres();
  List<Genres> _list = [];
  for (dynamic element in _genresList) {
    Genres _tem = Genres.fromJson(element);
    _list.add(_tem);
  }
  await DbProvider.instance.addGenres(_list);
}

//2.艺人/专辑/歌曲
getArtistsFromNet() async {
  List<Artists> _list = [];
  var _artisList = await getArtists();
  if (_artisList != null) {
    for (var _element in _artisList["index"]) {
      var _temp = _element["artist"];
      for (dynamic _element1 in _temp) {
        //这个lastfm的网址开始报错了，暂时这么写
        if (_element1["artistImageUrl"] == null ||
            _element1["artistImageUrl"] ==
                "https://lastfm.freetls.fastly.net/i/u/174s/2a96cbd8b46e442fc41c2b86b821562f.png")
          _element1["artistImageUrl"] =
              "https://s2.loli.net/2023/01/08/8hBKyu15UDqa9Z2.jpg";
        Artists _tem = Artists.fromJson(_element1);
        _list.add(_tem);
        await getAlbumsFromNet(_tem.id);
      }
    }
    await DbProvider.instance.addArtists(_list);
  }
}

getAlbumsFromNet(String artistId) async {
  List<Albums> _list = [];
  var _genresList = await getAlbums(artistId);
  if (_genresList != null) {
    for (dynamic _element in _genresList["album"]) {
      String _url = await getCoverArt(_element["id"]);
      if (_element["playCount"] == null) _element["playCount"] = 0;
      if (_element["year"] == null) _element["year"] = 0;
      if (_element["genre"] == null) _element["genre"] = "0";
      if (_element["duration"] == null) _element["duration"] = 0;
      _element["coverUrl"] = _url;
      Albums _tem = Albums.fromJson(_element);
      _list.add(_tem);
      await getSongsFromNet(_tem.id);
    }

    await DbProvider.instance.addAlbums(_list);
  }
}

getSongsFromNet(String albumId) async {
  List<Songs> _list = [];
  var _songsList = await getSongs(albumId);
  if (_songsList != null) {
    for (dynamic _element in _songsList["song"]) {
      String _stream = await getServerInfo("stream");
      String _url = await getCoverArt(_element["id"]);
      if (_element["playCount"] == null) _element["playCount"] = 0;
      if (_element["year"] == null) _element["year"] = 0;
      if (_element["genre"] == null) _element["genre"] = "0";
      if (_element["duration"] == null) _element["duration"] = 0;
      if (_element["bitRate"] == null) _element["bitRate"] = 0;
      _element["stream"] = _stream + '&id=' + _element["id"];
      _element["coverUrl"] = _url;
      Songs _tem = Songs.fromJson(_element);
      _list.add(_tem);
    }
    await DbProvider.instance.addSongs(_list);
  }
}

//4.收藏
getFavoriteFromNet() async {
  final _favoriteList = await getStarred();

  var songs = _favoriteList["song"];
  var albums = _favoriteList["album"];
  var artists = _favoriteList["artist"];

  if (songs != null && songs.length > 0) {
    for (var _song in songs) {
      Favorite _tem = Favorite(id: _song['id'], type: 'song');
      await DbProvider.instance.addFavorite(_tem);
    }
  }
  if (albums != null && albums.length > 0) {
    for (var _album in albums) {
      Favorite _tem = Favorite(id: _album['id'], type: 'album');
      await DbProvider.instance.addFavorite(_tem);
    }
  }
  if (artists != null && artists.length > 0) {
    for (var _artist in artists) {
      Favorite _tem = Favorite(id: _artist['id'], type: 'artist');
      await DbProvider.instance.addFavorite(_tem);
    }
  }
}

//5.播放列表
getPlaylistsFromNet() async {
  final _playlistsList = await getPlaylists();
  if (_playlistsList != null && _playlistsList.length > 0) {
    for (var _playlists in _playlistsList) {
      //写playlist表
      String _url = await getCoverArt(_playlists['id']);
      Playlist _playlist = Playlist(
          id: _playlists['id'],
          name: _playlists['name'],
          songCount: _playlists['songCount'],
          duration: _playlists['duration'],
          public: _playlists['public'] ? 0 : 1,
          owner: _playlists['owner'],
          created: _playlists['created'],
          changed: _playlists['changed'],
          imageUrl: _url);
      await DbProvider.instance.addPlaylists(_playlist);
      var _songsList = await getPlaylist(_playlists['id']);
      if (_songsList != null && _songsList.length > 0) {
        List<PlaylistAndSong> _playlistandsongList = [];
        for (var _song in _songsList) {
          //写歌对应表
          PlaylistAndSong _playlistandsong = PlaylistAndSong(
              playlistId: _playlists['id'], songId: _song['id']);
          _playlistandsongList.add(_playlistandsong);
        }
        await DbProvider.instance
            .addForcePlaylistSongs(_playlistandsongList, _playlists['id']);
      }
    }
  }
}
