import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int _index;
  String _activeMusic;

  UserProvider(this._index, this._activeMusic);

  set setIndex(int value) {
    _index = value;
    notifyListeners();
  }

  String get activeMusic => _activeMusic;

  int get index => _index;

  void setActiveMusic(String value) {
    _activeMusic = value;
    notifyListeners();
  }

  void setIndex2(int value) {
    _index = value;
    notifyListeners();
  }
}
