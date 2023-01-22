import 'package:dio/dio.dart';
import '../models/myModel.dart';
import 'dbProvider.dart';

testServer(String _baseUrl, String _username, String _password) async {
  try {
    var response = await Dio().get(
      _baseUrl +
          '/rest/ping?v=0.0.1&c=xiumusic&f=json&u=' +
          _username +
          '&p=' +
          _password,
    );
    print(response);
    if (response.statusCode == 200) {
      Map _value = response.data['subsonic-response'];
      String _status = _value['status'];
      if (_status == 'failed') {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

_getServerInfo(String _api) async {
  final _infoList = await DbProvider.instance.getServerInfo();
  String _request = _infoList.baseurl +
      '/rest/$_api?v=0.0.1&c=xiumusic&f=json&u=' +
      _infoList.username +
      '&s=' +
      _infoList.salt +
      '&t=' +
      _infoList.hash;
  return _request;
}

getServerInfo(String _api) async {
  final _infoList = await DbProvider.instance.getServerInfo();
  String _request = _infoList.baseurl +
      '/rest/$_api?v=0.0.1&c=xiumusic&f=json&u=' +
      _infoList.username +
      '&s=' +
      _infoList.salt +
      '&t=' +
      _infoList.hash;
  return _request;
}

getServerStatus() async {
  String _sql = await _getServerInfo("getScanStatus");
  try {
    var response = await Dio().get(_sql);
    if (response.statusCode == 200) {
      Map _value1 = response.data['subsonic-response'];
      Map scanStatus = _value1['scanStatus'];

      return scanStatus;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

getGenres() async {
  String _sql = await _getServerInfo("getGenres");
  try {
    var response = await Dio().get(_sql);
    if (response.statusCode == 200) {
      Map _value1 = response.data['subsonic-response'];
      Map genres = _value1['genres'];
      List genresList = genres["genre"];

      return genresList;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

getMusicFolders() async {
  String _sql = await _getServerInfo("getMusicFolders");
  try {
    var response = await Dio().get(_sql);
    if (response.statusCode == 200) {
      Map _value1 = response.data['subsonic-response'];
      Map genres = _value1['musicFolders'];

      return genres;
    }
  } catch (e) {
    print(e);
  }
}

//playlistId Yes (if updating) || name Yes (if creating)
createPlaylist(String _nameOrId, String _songId) async {
  String _sql = await _getServerInfo("createPlaylist");

  if (_songId == "") {
    _sql = _sql + '&name=' + _nameOrId;
  } else {
    _sql = _sql + '&name=' + _nameOrId + '&songId=' + _songId;
  }

  try {
    var response = await Dio().get(_sql);
    if (response.statusCode == 200) {
      var _response = response.data['subsonic-response'];

      return _response;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

updatePlaylist(String playlistId, String songIdToAdd) async {
  String _sql = await _getServerInfo("updatePlaylist");

  _sql = _sql + '&playlistId=' + playlistId + '&songIdToAdd=' + songIdToAdd;

  try {
    var response = await Dio().get(_sql);
    if (response.statusCode == 200) {
      var _response = response.data['subsonic-response'];

      return _response;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

delSongfromPlaylist(String playlistId, String? index) async {
  String _sql = await _getServerInfo("updatePlaylist");

  _sql = _sql +
      '&playlistId=' +
      playlistId +
      '&songIndexToRemove=' +
      index.toString();

  try {
    var response = await Dio().get(_sql);
    if (response.statusCode == 200) {
      var _response = response.data['subsonic-response'];

      return _response;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

getPlaylistbyId(String _id) async {
  String _sql = await _getServerInfo("getPlaylist");
  try {
    var response = await Dio().get(_sql + "&id=" + _id);
    if (response.statusCode == 200) {
      Map _response = response.data['subsonic-response'];
      Map _playlist = _response['playlist'];

      return _playlist;
    }
  } catch (e) {
    print(e);
  }
}

getPlaylists() async {
  String _sql = await _getServerInfo("getPlaylists");
  try {
    var response = await Dio().get(_sql);
    if (response.statusCode == 200) {
      Map _response = response.data['subsonic-response'];
      Map _playlists = _response['playlists'];
      List _playlist = _playlists['playlist'];

      return _playlist;
    }
  } catch (e) {
    print(e);
  }
}

getPlaylist(String _id) async {
  String _sql = await _getServerInfo("getPlaylist");
  try {
    var response = await Dio().get(_sql + "&id=" + _id);
    if (response.statusCode == 200) {
      Map _response = response.data['subsonic-response'];
      Map _playlist = _response['playlist'];
      List _songs = _playlist['entry'];

      return _songs;
    }
  } catch (e) {
    print(e);
  }
}

deletePlaylist(String _id) async {
  String _sql = await _getServerInfo("deletePlaylist");
  try {
    var response = await Dio().get(_sql + "&id=" + _id);
    if (response.statusCode == 200) {
      Map _response = response.data['subsonic-response'];

      return _response;
    }
  } catch (e) {
    print(e);
  }
}

getArtists() async {
  String _sql = await _getServerInfo("getArtists");
  try {
    var response = await Dio().get(_sql);
    if (response.statusCode == 200) {
      Map _response = response.data['subsonic-response'];
      Map _artists = _response['artists'];

      return _artists;
    }
  } catch (e) {
    print(e);
  }
}

getAlbums(String _id) async {
  String _sql = await _getServerInfo("getArtist");
  try {
    var response = await Dio().get(
      _sql + '&id=' + _id,
    );
    if (response.statusCode == 200) {
      Map _response = response.data['subsonic-response'];
      Map _artist = _response['artist'];
//album
      return _artist;
    }
  } catch (e) {
    print(e);
  }
}

getSongs(String _id) async {
  String _sql = await _getServerInfo("getAlbum");
  try {
    var response = await Dio().get(
      _sql + '&id=' + _id,
    );
    if (response.statusCode == 200) {
      Map _response = response.data['subsonic-response'];
      Map _artist = _response['album'];
//song
      return _artist;
    }
  } catch (e) {
    print(e);
  }
}

getIndexes() async {
  String _sql = await _getServerInfo("getIndexes");
  try {
    var response = await Dio().get(_sql);
    if (response.statusCode == 200) {
      Map _value1 = response.data['subsonic-response'];
      Map _indexs = _value1['indexes'];

      return _indexs;
    }
  } catch (e) {
    print(e);
  }
}

getMusicDirectory(String _id) async {
  String _sql = await _getServerInfo("getMusicDirectory");
  try {
    var response = await Dio().get(
      _sql + '&id=' + _id,
    );
    if (response.statusCode == 200) {
      Map _value1 = response.data['subsonic-response'];
      Map _musicdirectory = _value1['directory'];

      return _musicdirectory;
    }
  } catch (e) {
    print(e);
  }
}

getSong(String _id) async {
  String _sql = await _getServerInfo("getSong");
  try {
    var response = await Dio().get(
      _sql + '&id=' + _id,
    );
    if (response.statusCode == 200) {
      Map _value1 = response.data['subsonic-response'];
      Map _song = _value1['song'];

      return _song;
    }
  } catch (e) {
    print(e);
  }
}

getCoverArt(String _id) async {
  String _sql = await _getServerInfo("getCoverArt");
  return _sql + '&id=' + _id;
}

searchNeteasAPI(String _name, String _type) async {
  final _infoList = await DbProvider.instance.getServerInfo();
  String _neteaseapi = _infoList.neteaseapi;
  String _timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  String _request = _neteaseapi +
      "/search?limit=5&type=$_type&offset=0&keywords=$_name&timestamp=$_timestamp";
  print(_request);
  try {
    var response = await Dio().get(_request);
    if (response.statusCode == 200) {
      var _value = response.data['result'];

      return _value;
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

getLyric(String _songId) async {
  final _infoList = await DbProvider.instance.getServerInfo();
  String _neteaseapi = _infoList.neteaseapi;
  String _timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  String _request = _neteaseapi + "/lyric?id=$_songId&timestamp=$_timestamp";
  try {
    var response = await Dio().get(_request);
    if (response.statusCode == 200) {
      var _value = response.data['lrc'];
      var _lyric = _value["lyric"];

      return _lyric;
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

addStarred(Favorite _starred) async {
  String _sql = await _getServerInfo("star");
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
    var response = await Dio().get(_sql);
    if (response.statusCode == 200) {
      Map _response = response.data['subsonic-response'];

      return _response;
    }
  } catch (e) {
    print(e);
  }
}

getStarred() async {
  String _sql = await _getServerInfo("getStarred");
  try {
    var response = await Dio().get(_sql);
    if (response.statusCode == 200) {
      Map _response = response.data['subsonic-response'];
      Map _starred = _response['starred'];

      return _starred;
    }
  } catch (e) {
    print(e);
  }
}

delStarred(Favorite _starred) async {
  String _sql = await _getServerInfo("unstar");
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
    var response = await Dio().get(_sql);
    if (response.statusCode == 200) {
      Map _response = response.data['subsonic-response'];

      return _response;
    }
  } catch (e) {
    print(e);
  }
}
