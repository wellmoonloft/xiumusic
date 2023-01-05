import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    //return response;
  } catch (e) {
    print(e);
    return false;
  }
}

getGenres() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String _baseurl = sharedPreferences.getString("baseurl")!;
  String _username = sharedPreferences.getString("username")!;
  String _salt = sharedPreferences.getString("salt")!;
  String _hash = sharedPreferences.getString("hash")!;
  try {
    var response = await Dio().get(
      _baseurl +
          'rest/getGenres?v=0.0.1&c=xiumusic&f=json&u=' +
          _username +
          '&s=' +
          _salt +
          '&t=' +
          _hash,
    );
    //print(response);
    if (response.statusCode == 200) {
      Map _value1 = response.data['subsonic-response'];
      Map genres = _value1['genres'];

      return genres;
    }
  } catch (e) {
    print(e);
  }
}

getMusicFolders() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String _baseurl = sharedPreferences.getString("baseurl")!;
  String _username = sharedPreferences.getString("username")!;
  String _salt = sharedPreferences.getString("salt")!;
  String _hash = sharedPreferences.getString("hash")!;
  try {
    var response = await Dio().get(
      _baseurl +
          'rest/getMusicFolders?v=0.0.1&c=xiumusic&f=json&u=' +
          _username +
          '&s=' +
          _salt +
          '&t=' +
          _hash,
    );
    //print(response);
    if (response.statusCode == 200) {
      Map _value1 = response.data['subsonic-response'];
      Map genres = _value1['musicFolders'];

      return genres;
    }
  } catch (e) {
    print(e);
  }
}

getIndexes() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String _baseurl = sharedPreferences.getString("baseurl")!;
  String _username = sharedPreferences.getString("username")!;
  String _salt = sharedPreferences.getString("salt")!;
  String _hash = sharedPreferences.getString("hash")!;
  try {
    var response = await Dio().get(
      _baseurl +
          'rest/getIndexes?v=0.0.1&c=xiumusic&f=json&u=' +
          _username +
          '&s=' +
          _salt +
          '&t=' +
          _hash,
    );
    //print(response);
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
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String _baseurl = sharedPreferences.getString("baseurl")!;
  String _username = sharedPreferences.getString("username")!;
  String _salt = sharedPreferences.getString("salt")!;
  String _hash = sharedPreferences.getString("hash")!;
  try {
    var response = await Dio().get(
      _baseurl +
          'rest/getMusicDirectory?v=0.0.1&c=xiumusic&f=json&u=' +
          _username +
          '&s=' +
          _salt +
          '&t=' +
          _hash +
          '&id=' +
          _id,
    );
    //print(response);
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
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String _baseurl = sharedPreferences.getString("baseurl")!;
  String _username = sharedPreferences.getString("username")!;
  String _salt = sharedPreferences.getString("salt")!;
  String _hash = sharedPreferences.getString("hash")!;
  try {
    var response = await Dio().get(
      _baseurl +
          'rest/getSong?v=0.0.1&c=xiumusic&f=json&u=' +
          _username +
          '&s=' +
          _salt +
          '&t=' +
          _hash +
          '&id=' +
          _id,
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
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String _baseurl = sharedPreferences.getString("baseurl")!;
  String _username = sharedPreferences.getString("username")!;
  String _salt = sharedPreferences.getString("salt")!;
  String _hash = sharedPreferences.getString("hash")!;
  return _baseurl +
      'rest/getCoverArt?v=0.0.1&c=xiumusic&f=json&u=' +
      _username +
      '&s=' +
      _salt +
      '&t=' +
      _hash +
      '&id=' +
      _id;
}

getSongStreamUrl(String _id) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String _baseurl = sharedPreferences.getString("baseurl")!;
  String _username = sharedPreferences.getString("username")!;
  String _salt = sharedPreferences.getString("salt")!;
  String _hash = sharedPreferences.getString("hash")!;
  return _baseurl +
      'rest/stream?v=0.0.1&c=xiumusic&f=json&u=' +
      _username +
      '&s=' +
      _salt +
      '&t=' +
      _hash +
      '&id=' +
      _id;
}

String md5RandomString(String _password) {
  final randomNumber = Random().toString();
  final randomBytes = utf8.encode(randomNumber + _password);
  final randomString = md5.convert(randomBytes).toString();
  return randomString;
}
