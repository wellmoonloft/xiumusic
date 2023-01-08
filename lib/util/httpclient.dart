import 'package:dio/dio.dart';
import '../models/baseDB.dart';

testServer(String _baseUrl, String _username, String _password) async {
  try {
    var response = await Dio().get(
      _baseUrl +
          'rest/ping?v=0.0.1&c=xiumusic&f=json&u=' +
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
  final _infoList = await BaseDB.instance.getServerInfo();
  String _request = _infoList.baseurl +
      'rest/$_api?v=0.0.1&c=xiumusic&f=json&u=' +
      _infoList.username +
      '&s=' +
      _infoList.salt +
      '&t=' +
      _infoList.hash;
  return _request;
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
    //print(response);
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

getSongStreamUrl(String _id) async {
  String _sql = await _getServerInfo("stream");
  return _sql + '&id=' + _id;
}
