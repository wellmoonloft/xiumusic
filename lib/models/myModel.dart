class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class ServerInfo {
  late String baseurl;
  late String username;
  late String salt;
  late String hash;

  ServerInfo(
      {required this.baseurl,
      required this.username,
      required this.salt,
      required this.hash});

  ServerInfo.fromJson(Map<String, dynamic> json) {
    baseurl = json['baseurl'];
    username = json['username'];
    salt = json['salt'];
    hash = json['hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['baseurl'] = this.baseurl;
    _data['username'] = this.username;
    _data['salt'] = this.salt;
    _data['hash'] = this.hash;
    return _data;
  }
}

class ServerStatus {
  late int count;
  late int folderCount;
  late String lastScan;

  ServerStatus(
      {required this.count, required this.folderCount, required this.lastScan});

  ServerStatus.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    folderCount = json['folderCount'];
    lastScan = json['lastScan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['count'] = this.count;
    _data['folderCount'] = this.folderCount;
    _data['lastScan'] = this.lastScan;
    return _data;
  }
}

class Playlist {
  late String id;
  late String name;
  late int songCount;
  late int duration;
  late int public;
  late String owner;
  late String created;
  late String changed;

  Playlist(
      {required this.id,
      required this.name,
      required this.songCount,
      required this.duration,
      required this.public,
      required this.owner,
      required this.created,
      required this.changed});

  Playlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    songCount = json['songCount'];
    duration = json['duration'];
    public = json['public'];
    owner = json['owner'];
    created = json['created'];
    changed = json['changed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['id'] = this.id;
    _data['name'] = this.name;
    _data['songCount'] = this.songCount;
    _data['duration'] = this.duration;
    _data['public'] = this.public;
    _data['owner'] = this.owner;
    _data['created'] = this.created;
    _data['changed'] = this.changed;

    return _data;
  }
}

class PlaylistAndSong {
  late String playlistId;
  late String songId;

  PlaylistAndSong({required this.playlistId, required this.songId});

  PlaylistAndSong.fromJson(Map<String, dynamic> json) {
    playlistId = json['playlistId'];
    songId = json['songId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['playlistId'] = this.playlistId;
    _data['songId'] = this.songId;

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
  late String genre;
  late int year;
  late int duration;
  late int playCount;
  late int songCount;
  late String created;

  Albums(
      {required this.id,
      required this.artistId,
      required this.title,
      required this.artist,
      required this.genre,
      required this.year,
      required this.duration,
      required this.playCount,
      required this.songCount,
      required this.created});

  Albums.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    artistId = json['artistId'];
    title = json['title'];
    artist = json['artist'];
    genre = json['genre'];
    year = json['year'];
    duration = json['duration'];
    playCount = json['playCount'];
    songCount = json['songCount'];
    created = json['created'];
  }

  get length => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['id'] = this.id;
    _data['artistId'] = this.artistId;
    _data['title'] = this.title;
    _data['artist'] = this.artist;
    _data['genre'] = this.genre;
    _data['year'] = this.year;
    _data['duration'] = this.duration;
    _data['playCount'] = this.playCount;
    _data['songCount'] = this.songCount;
    _data['created'] = this.created;
    return _data;
  }
}

class Songs {
  late String id;
  late String title;
  late String album;
  late String artist;
  late String genre;
  late String albumId;
  late int duration;
  late int bitRate;
  late String path;
  late int playCount;
  late String created;

  Songs(
      {required this.id,
      required this.title,
      required this.album,
      required this.artist,
      required this.genre,
      required this.albumId,
      required this.duration,
      required this.bitRate,
      required this.path,
      required this.playCount,
      required this.created});

  Songs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    album = json['album'];
    artist = json['artist'];
    genre = json['genre'];
    albumId = json['albumId'];
    duration = json['duration'];
    bitRate = json['bitRate'];
    path = json['path'];
    playCount = json['playCount'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['id'] = this.id;
    _data['title'] = this.title;
    _data['album'] = this.album;
    _data['artist'] = this.artist;
    _data['genre'] = this.genre;
    _data['albumId'] = this.albumId;
    _data['duration'] = this.duration;
    _data['bitRate'] = this.bitRate;
    _data['path'] = this.path;
    _data['playCount'] = this.playCount;
    _data['created'] = this.created;
    return _data;
  }
}
