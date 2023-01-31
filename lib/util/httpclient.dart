import 'package:dio/dio.dart';
import '../models/myModel.dart';
import '../models/notifierValue.dart';

testServer(String _baseUrl, String _username, String _password) async {
  try {
    var _response = await Dio().get(
      _baseUrl +
          '/rest/ping?v=0.0.1&c=xiumusic&f=json&u=' +
          _username +
          '&p=' +
          _password,
    );
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return false;
    return true;
  } catch (e) {
    print(e);
  }
}

checkResponse(Response<dynamic> _response) {
  if (_response.statusCode == 200) {
    if (_response.data['subsonic-response'] != null) {
      Map _subsonic = _response.data['subsonic-response'];
      String _status = _subsonic['status'];
      if (_status == 'ok') {
        return _subsonic;
      }
    }
  }
  return null;
}

getCoverArt(String _id) {
  String _sql = getServerInfo("getCoverArt");
  return _sql + '&size=350' + '&id=' + _id;
}

getServerInfo(String _api) {
  String _request = serversInfo.value.baseurl +
      '/rest/$_api?v=0.0.1&c=xiumusic&f=json&u=' +
      serversInfo.value.username +
      '&s=' +
      serversInfo.value.salt +
      '&t=' +
      serversInfo.value.hash;
  return _request;
}

//type:random/newest/highest/frequent/recent/
//subsonic 1.8.0 alphabeticalByName/alphabeticalByArtist/starred
//size 10 if no
//offset 0
//byGenre  need genre
//byYear  fromYear  toYear
getAlbumList(String _type, String _by, int _offset, int _size) async {
  String _sql = getServerInfo("getAlbumList2") +
      '&offset=' +
      _offset.toString() +
      '&size=' +
      _size.toString();
  switch (_type) {
    case "byGenre":
      _sql += '&type=' + _type + '&genre=' + _by;
      break;
    default:
      _sql += '&type=' + _type;
  }
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _albumList = _subsonic['albumList2'];
    List _albums = _albumList['album'];
    return _albums;
  } catch (e) {
    print(e);
  }
}

getAlbumInfo2(String _albumId) async {
  String _sql = getServerInfo("getAlbumInfo2") + '&id=' + _albumId;
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map scanStatus = _subsonic['albumInfo'];
    return scanStatus;
  } catch (e) {
    print(e);
  }
}

search3(String _query) async {
  String _sql = getServerInfo("search3") + '&query=' + _query;
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map scanStatus = _subsonic['searchResult3'];
    return scanStatus;
  } catch (e) {
    print(e);
  }
}

getGenres() async {
  String _sql = getServerInfo("getGenres");
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map genres = _subsonic['genres'];
    List genresList = genres["genre"];
    return genresList;
  } catch (e) {
    print(e);
  }
}

//playlistId Yes (if updating) || name Yes (if creating)
createPlaylist(String _nameOrId, String _songId) async {
  String _sql = await getServerInfo("createPlaylist");
  if (_songId == "") {
    _sql = _sql + '&name=' + _nameOrId;
  } else {
    _sql = _sql + '&name=' + _nameOrId + '&songId=' + _songId;
  }
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    return _subsonic;
  } catch (e) {
    print(e);
  }
}

updatePlaylist(String playlistId, String songIdToAdd) async {
  String _sql = await getServerInfo("updatePlaylist");
  _sql = _sql + '&playlistId=' + playlistId + '&songIdToAdd=' + songIdToAdd;
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    return _subsonic;
  } catch (e) {
    print(e);
  }
}

delSongfromPlaylist(String playlistId, String? index) async {
  String _sql = await getServerInfo("updatePlaylist");
  _sql = _sql +
      '&playlistId=' +
      playlistId +
      '&songIndexToRemove=' +
      index.toString();
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    return _subsonic;
  } catch (e) {
    print(e);
  }
}

getPlaylistbyId(String _id) async {
  String _sql = await getServerInfo("getPlaylist");
  try {
    var _response = await Dio().get(_sql + "&id=" + _id);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _playlist = _subsonic['playlist'];
    return _playlist;
  } catch (e) {
    print(e);
  }
}

getPlaylists() async {
  String _sql = await getServerInfo("getPlaylists");
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _playlists = _subsonic['playlists'];
    List _playlist = _playlists['playlist'];
    return _playlist;
  } catch (e) {
    print(e);
  }
}

getPlaylist(String _id) async {
  String _sql = await getServerInfo("getPlaylist");
  try {
    var _response = await Dio().get(_sql + "&id=" + _id);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _playlist = _subsonic['playlist'];
    List _songs = _playlist['entry'];
    return _songs;
  } catch (e) {
    print(e);
  }
}

deletePlaylist(String _id) async {
  String _sql = await getServerInfo("deletePlaylist");
  try {
    var _response = await Dio().get(_sql + "&id=" + _id);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    return _subsonic;
  } catch (e) {
    print(e);
  }
}

getArtists() async {
  String _sql = await getServerInfo("getArtists");
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _artists = _subsonic['artists'];
    return _artists;
  } catch (e) {
    print(e);
  }
}

getArtistInfo2(String _id) async {
  String _sql = await getServerInfo("getArtistInfo2");
  try {
    var _response = await Dio().get(
      _sql + '&count=10' + '&id=' + _id,
    );
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _artist = _subsonic['artistInfo2'];
    return _artist;
  } catch (e) {
    print(e);
  }
}

getArtist(String _id) async {
  String _sql = await getServerInfo("getArtist");
  try {
    var _response = await Dio().get(
      _sql + '&id=' + _id,
    );
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _artist = _subsonic['artist'];
    return _artist;
  } catch (e) {
    print(e);
  }
}

getSongs(String _id) async {
  String _sql = await getServerInfo("getAlbum");
  try {
    var _response = await Dio().get(
      _sql + '&id=' + _id,
    );
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _artist = _subsonic['album'];
    return _artist;
  } catch (e) {
    print(e);
  }
}

//count no 50
getTopSongs(String _name) async {
  String _sql = await getServerInfo("getTopSongs");
  try {
    var _response = await Dio().get(
      _sql + '&artist=' + _name,
    );
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _topSongs = _subsonic['topSongs'];
    return _topSongs;
  } catch (e) {
    print(e);
  }
}

getSong(String _id) async {
  String _sql = await getServerInfo("getSong");
  try {
    var _response = await Dio().get(
      _sql + '&id=' + _id,
    );
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _song = _subsonic['song'];
    return _song;
  } catch (e) {
    print(e);
  }
}

addStarred(Favorite _starred) async {
  String _sql = await getServerInfo("star");
  switch (_starred.type) {
    case "song":
      _sql = _sql + '&id=' + _starred.id;
      break;
    case "album":
      _sql = _sql + '&albumId=' + _starred.id;
      break;
    case "artist":
      _sql = _sql + '&artistId=' + _starred.id;
      break;
    default:
      _sql = _sql + '&id=' + _starred.id;
  }
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    return _subsonic;
  } catch (e) {
    print(e);
  }
}

getStarred() async {
  String _sql = await getServerInfo("getStarred2");
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _starred = _subsonic['starred2'];
    return _starred;
  } catch (e) {
    print(e);
  }
}

delStarred(Favorite _starred) async {
  String _sql = await getServerInfo("unstar");
  switch (_starred.type) {
    case "song":
      _sql = _sql + '&id=' + _starred.id;
      break;
    case "album":
      _sql = _sql + '&albumId=' + _starred.id;
      break;
    case "artist":
      _sql = _sql + '&artistId=' + _starred.id;
      break;
    default:
      _sql = _sql + '&id=' + _starred.id;
  }
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    return _subsonic;
  } catch (e) {
    print(e);
  }
}

scrobble(String _songId, bool _submission) async {
  String _timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  String _sql =
      await getServerInfo("scrobble") + '&time=$_timestamp' + '&id=' + _songId;
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    return _subsonic;
  } catch (e) {
    print(e);
  }
}

searchNeteasAPI(String _name, String _type) async {
  String _neteaseapi = serversInfo.value.neteaseapi;
  String _timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  String _request = _neteaseapi +
      "/search?limit=5&type=$_type&offset=0&keywords=$_name&timestamp=$_timestamp";
  print(_request);
  try {
    var response = await Dio().get(_request);
    if (response.statusCode == 200) {
      var _result = response.data['result'];
      if (_result == null) return null;
      return _result;
    } else {
      return null;
    }
  } catch (e) {
    print(e);
  }
}

getLyric(String _songId) async {
  String _neteaseapi = serversInfo.value.neteaseapi;
  String _timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  String _request = _neteaseapi + "/lyric?id=$_songId&timestamp=$_timestamp";
  try {
    var response = await Dio().get(_request);
    if (response.statusCode == 200) {
      var _value = response.data['lrc'];
      if (_value == null) return null;
      var _lyric = _value["lyric"];
      if (_lyric == null) return null;
      return _lyric;
    } else {
      return null;
    }
  } catch (e) {
    print(e);
  }
}
