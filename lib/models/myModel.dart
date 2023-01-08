class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class ServerInfo {
  late String baseurl;
  late String username;
  late String password;
  late String salt;
  late String hash;

  ServerInfo(
      {required this.baseurl,
      required this.username,
      required this.password,
      required this.salt,
      required this.hash});

  ServerInfo.fromJson(Map<String, dynamic> json) {
    baseurl = json['baseurl'];
    username = json['username'];
    password = json['password'];
    salt = json['salt'];
    hash = json['hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['baseurl'] = this.baseurl;
    _data['username'] = this.username;
    _data['password'] = this.password;
    _data['salt'] = this.salt;
    _data['hash'] = this.hash;
    return _data;
  }
}

class Genres {
  late String value;
  late int songCount;
  late int albumCount;

  Genres(
      {required this.value, required this.songCount, required this.albumCount});

  Genres.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    songCount = json['songCount'];
    albumCount = json['albumCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['value'] = this.value;
    _data['songCount'] = this.songCount;
    _data['albumCount'] = this.albumCount;

    return _data;
  }
}

class Artists {
  late String id;
  late String name;
  late int albumCount;
  late String artistImageUrl;

  Artists(
      {required this.id,
      required this.name,
      required this.albumCount,
      required this.artistImageUrl});

  Artists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    albumCount = json['albumCount'];
    artistImageUrl = json['artistImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['id'] = this.id;
    _data['name'] = this.name;
    _data['albumCount'] = this.albumCount;
    _data['artistImageUrl'] = this.artistImageUrl;

    return _data;
  }
}

class Albums {
  late String id;
  late String artistId;
  late String title;
  late String artist;
  late int year;
  late int duration;
  late int playCount;
  late int songCount;

  Albums(
      {required this.id,
      required this.artistId,
      required this.title,
      required this.artist,
      required this.year,
      required this.duration,
      required this.playCount,
      required this.songCount});

  Albums.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    artistId = json['artistId'];
    title = json['title'];
    artist = json['artist'];
    year = json['year'];
    duration = json['duration'];
    playCount = json['playCount'];
    songCount = json['songCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['id'] = this.id;
    _data['artistId'] = this.artistId;
    _data['title'] = this.title;
    _data['artist'] = this.artist;
    _data['year'] = this.year;
    _data['duration'] = this.duration;
    _data['playCount'] = this.playCount;
    _data['songCount'] = this.songCount;
    return _data;
  }
}

class Songs {
  late String id;
  late String title;
  late String album;
  late String artist;
  late String albumId;
  late int duration;
  late int bitRate;
  late String path;
  late int playCount;

  Songs(
      {required this.id,
      required this.title,
      required this.album,
      required this.artist,
      required this.albumId,
      required this.duration,
      required this.bitRate,
      required this.path,
      required this.playCount});

  Songs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    album = json['album'];
    artist = json['artist'];
    albumId = json['albumId'];
    duration = json['duration'];
    bitRate = json['bitRate'];
    path = json['path'];
    playCount = json['playCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['id'] = this.id;
    _data['title'] = this.title;
    _data['album'] = this.album;
    _data['artist'] = this.artist;
    _data['albumId'] = this.albumId;
    _data['duration'] = this.duration;
    _data['bitRate'] = this.bitRate;
    _data['path'] = this.path;
    _data['playCount'] = this.playCount;
    return _data;
  }
}
