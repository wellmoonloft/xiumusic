import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/myModel.dart';

class DbProvider {
  static final DbProvider instance = DbProvider._init();
  static Database? _db;
  DbProvider._init();

  final String dbName = "xiumusic.db";
  // ignore: non_constant_identifier_names
  final String ServerInfoTable = "serverInfo";
  // ignore: non_constant_identifier_names
  final String ServerStatusTable = "serverStatus";
  // ignore: non_constant_identifier_names
  final String PlaylistTable = "playlist";
  // ignore: non_constant_identifier_names
  final String PlaylistAndSongTable = "playlistAndSong";
  // ignore: non_constant_identifier_names
  final String GenresTable = "genres";
  // ignore: non_constant_identifier_names
  final String ArtistsTable = "artists";
  // ignore: non_constant_identifier_names
  final String AlbumsTable = "albums";
  // ignore: non_constant_identifier_names
  final String SongsTable = "songs";
  // ignore: non_constant_identifier_names
  final String SongsAndLyricTable = "songsAndLyric";
  // ignore: non_constant_identifier_names
  final String FavoriteTable = "favorite";

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _useDatabase();
    return _db!;
  }

  Future<Database> _useDatabase() async {
    final dbPath = await getDatabasesPath();

    return await openDatabase(join(dbPath, dbName),
        version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database _database, int _version) async {
    await _database.execute('''
              create table $ServerInfoTable (
                uid INTEGER PRIMARY KEY AUTOINCREMENT,
                baseurl TEXT NOT NULL,
                username TEXT NOT NULL,
                salt TEXT NOT NULL,
                hash TEXT NOT NULL,
                neteaseapi TEXT
              )
        ''');
    await _database.execute('''
              create table $ServerStatusTable (
                uid INTEGER PRIMARY KEY AUTOINCREMENT,
                count INTEGER NOT NULL,
                folderCount INTEGER NOT NULL,
                lastScan TEXT NOT NULL
              )
        ''');
    await _database.execute('''
              create table $PlaylistTable (
                uid INTEGER PRIMARY KEY AUTOINCREMENT,
                id TEXT NOT NULL,
                name TEXT NOT NULL,
                songCount INTEGER NOT NULL,
                duration INTEGER NOT NULL,
                public INTEGER NOT NULL,
                owner TEXT NOT NULL,
                created TEXT NOT NULL,
                changed TEXT NOT NULL,
                imageUrl TEXT
              )
        ''');
    await _database.execute('''
              create table $PlaylistAndSongTable (
                uid INTEGER PRIMARY KEY AUTOINCREMENT,
                playlistId TEXT NOT NULL,
                songId TEXT NOT NULL
              )
        ''');
    await _database.execute('''
              create table $GenresTable (
                uid INTEGER PRIMARY KEY AUTOINCREMENT,
                value TEXT NOT NULL,
                songCount INTEGER NOT NULL,
                albumCount INTEGER NOT NULL
              )
        ''');
    await _database.execute('''
              create table $ArtistsTable (
                uid INTEGER PRIMARY KEY AUTOINCREMENT,
                id TEXT NOT NULL,
                name TEXT NOT NULL,
                albumCount INTEGER NOT NULL,
                artistImageUrl TEXT NOT NULL
              )
        ''');
    await _database.execute('''
              create table $AlbumsTable (
                uid INTEGER PRIMARY KEY AUTOINCREMENT,
                id TEXT NOT NULL,
                artistId TEXT NOT NULL,
                title TEXT NOT NULL,
                artist TEXT NOT NULL,
                genre TEXT,
                year INTEGER,
                duration INTEGER NOT NULL,
                playCount INTEGER,
                songCount INTEGER NOT NULL,
                created TEXT NOT NULL,
                coverUrl TEXT
              )
        ''');
    await _database.execute('''
              create table $SongsTable (
                uid INTEGER PRIMARY KEY AUTOINCREMENT,
                id TEXT NOT NULL,
                title TEXT NOT NULL,                
                album TEXT NOT NULL,
                artist TEXT NOT NULL,
                genre TEXT,
                albumId TEXT NOT NULL,
                duration INTEGER NOT NULL,
                bitRate INTEGER NOT NULL,
                path TEXT NOT NULL,
                playCount INTEGER,
                created TEXT NOT NULL,
                stream TEXT,
                coverUrl TEXT
              )
        ''');
    await _database.execute('''
              create table $SongsAndLyricTable (
                uid INTEGER PRIMARY KEY AUTOINCREMENT,
                lyric TEXT NOT NULL,
                songId TEXT NOT NULL
              )
        ''');
    await _database.execute('''
              create table $FavoriteTable (
                uid INTEGER PRIMARY KEY AUTOINCREMENT,
                id TEXT NOT NULL,
                type TEXT NOT NULL
              )
        ''');
  }

  addServerInfo(ServerInfo _info) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.insert(ServerInfoTable, _info.toJson());
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  updateServerInfo(ServerInfo _info) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.update(ServerInfoTable, _info.toJson());
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  deleteServerInfo() async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(ServerInfoTable);
      //清空数据库，后面前端加个提示
      batch.delete(ServerStatusTable);
      batch.delete(PlaylistTable);
      batch.delete(PlaylistAndSongTable);
      batch.delete(GenresTable);
      batch.delete(ArtistsTable);
      batch.delete(AlbumsTable);
      batch.delete(SongsTable);
      batch.delete(FavoriteTable);
      batch.delete(SongsAndLyricTable);
      batch.delete("sqlite_sequence");
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  forchrefresh() async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(PlaylistTable);
      batch.delete(PlaylistAndSongTable);
      batch.delete(GenresTable);
      batch.delete(ArtistsTable);
      batch.delete(AlbumsTable);
      batch.delete(SongsTable);
      batch.delete(FavoriteTable);

      db.delete("sqlite_sequence", where: "name=?", whereArgs: [
        PlaylistTable,
      ]);
      db.delete("sqlite_sequence", where: "name=?", whereArgs: [
        PlaylistAndSongTable,
      ]);
      db.delete("sqlite_sequence", where: "name=?", whereArgs: [
        GenresTable,
      ]);
      db.delete("sqlite_sequence", where: "name=?", whereArgs: [
        ArtistsTable,
      ]);
      db.delete("sqlite_sequence", where: "name=?", whereArgs: [
        AlbumsTable,
      ]);
      db.delete("sqlite_sequence", where: "name=?", whereArgs: [
        SongsTable,
      ]);
      db.delete("sqlite_sequence", where: "name=?", whereArgs: [
        FavoriteTable,
      ]);
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  // 查
  getServerInfo() async {
    try {
      final db = await instance.db;
      var res = await db.query(ServerInfoTable);
      if (res.length == 0) return null;
      List<ServerInfo> lists = res.map((e) => ServerInfo.fromJson(e)).toList();
      return lists[0];
    } catch (err) {
      print('err1 is 👉 $err');
    }
  }

  addServerStatus(ServerStatus _info) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(ServerStatusTable);
      await batch.commit(noResult: true);
      batch.insert(ServerStatusTable, _info.toJson());
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getServerStatus() async {
    try {
      final db = await instance.db;
      var res = await db.query(ServerStatusTable);
      if (res.length == 0) return null;
      List<ServerStatus> lists =
          res.map((e) => ServerStatus.fromJson(e)).toList();
      return lists[0];
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  addGenres(List<Genres> _genres) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      for (Genres element in _genres) {
        batch.insert(GenresTable, element.toJson());
      }
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  updateGenres(List<Genres> _genres) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      for (Genres element in _genres) {
        batch.update(GenresTable, element.toJson(),
            where: "value = ?", whereArgs: [element.value]);
      }
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getGenres() async {
    try {
      final db = await instance.db;
      var res = await db.query(GenresTable);
      if (res.length == 0) return null;
      List<Genres> lists = res.map((e) => Genres.fromJson(e)).toList();
      return lists;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  addPlaylists(Playlist _playlist) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.insert(PlaylistTable, _playlist.toJson());

      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  updatePlaylists(Playlist _playlist) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.update(PlaylistTable, _playlist.toJson(),
          where: "id=?", whereArgs: [_playlist.id]);

      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  checkPlaylistById(String _playlistId, String songId) async {
    try {
      final db = await instance.db;
      var res = db.rawQuery(
          "SELECT * FROM $PlaylistAndSongTable WHERE playlistId='$_playlistId' AND songId='$songId'");
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  delPlaylistById(String _playlistId) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(PlaylistAndSongTable,
          where: "playlistId=?", whereArgs: [_playlistId]);
      batch.delete(PlaylistTable, where: "id=?", whereArgs: [_playlistId]);

      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  delAllPlaylistSongs() async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(PlaylistAndSongTable);
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  addPlaylistSongs(PlaylistAndSong _playlistAndSong) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();

      batch.insert(PlaylistAndSongTable, _playlistAndSong.toJson());

      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  delPlaylistSongs(String _songId) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();

      batch.delete(PlaylistAndSongTable,
          where: "songId=?", whereArgs: [_songId]);

      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  addForcePlaylistSongs(
      List<PlaylistAndSong> _playlistAndSong, String _playlistId) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      for (PlaylistAndSong _element in _playlistAndSong) {
        batch.insert(PlaylistAndSongTable, _element.toJson());
      }
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getPlaylistById(String _playlistId) async {
    try {
      final db = await instance.db;
      var res = await db
          .query(PlaylistTable, where: "id=?", whereArgs: [_playlistId]);
      if (res.length == 0) return null;
      List<Playlist> lists = res.map((e) => Playlist.fromJson(e)).toList();
      return lists[0];
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getPlaylists() async {
    try {
      final db = await instance.db;
      var res = await db.query(PlaylistTable);
      if (res.length == 0) return null;
      List<Playlist> lists = res.map((e) => Playlist.fromJson(e)).toList();
      return lists;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getPlaylistSongs(String _playlistId) async {
    try {
      final db = await instance.db;
      var res = await db.query(PlaylistAndSongTable,
          where: "playlistId = ?", whereArgs: [_playlistId]);
      if (res.length == 0) return null;
      List<PlaylistAndSong> lists =
          res.map((e) => PlaylistAndSong.fromJson(e)).toList();
      List<Songs> songs = [];
      for (PlaylistAndSong element in lists) {
        Songs song = await getSongById(element.songId);
        songs.add(song);
      }

      return songs;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  addArtists(List<Artists> _artists) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      for (Artists element in _artists) {
        batch.insert(ArtistsTable, element.toJson());
      }
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  updateArtists1(List<Artists> _artists) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      for (Artists element in _artists) {
        batch.update(ArtistsTable, element.toJson(),
            where: "id = ?", whereArgs: [element.id]);
      }
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getArtists() async {
    try {
      final db = await instance.db;
      var res = await db.query(ArtistsTable);
      if (res.length == 0) return null;
      List<Artists> lists = res.map((e) => Artists.fromJson(e)).toList();
      return lists;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getArtistsByID(String artistId) async {
    try {
      final db = await instance.db;
      var res =
          await db.query(ArtistsTable, where: "id = ?", whereArgs: [artistId]);
      if (res.length == 0) return null;
      List<Artists> lists = res.map((e) => Artists.fromJson(e)).toList();
      return lists;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  delAlbums() async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(AlbumsTable);
      await batch.commit(noResult: true);

      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  addAlbums(List<Albums> _albums) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      for (Albums element in _albums) {
        batch.insert(AlbumsTable, element.toJson());
      }
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  updateAlbums(List<Albums> _albums) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      for (Albums element in _albums) {
        batch.update(AlbumsTable, element.toJson(),
            where: "id = ?", whereArgs: [element.id]);
      }
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getAlbums(String artistId) async {
    try {
      final db = await instance.db;
      var res = await db
          .query(AlbumsTable, where: "artistId = ?", whereArgs: [artistId]);
      if (res.length == 0) return null;
      List<Albums> lists = res.map((e) => Albums.fromJson(e)).toList();
      return lists;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getAlbumsByID(String albumId) async {
    try {
      final db = await instance.db;
      var res =
          await db.query(AlbumsTable, where: "id = ?", whereArgs: [albumId]);
      if (res.length == 0) return null;
      List<Albums> lists = res.map((e) => Albums.fromJson(e)).toList();
      return lists;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getAllAlbums() async {
    try {
      final db = await instance.db;
      var res = await db.query(AlbumsTable);
      if (res.length == 0) return null;
      List<Albums> lists = res.map((e) => Albums.fromJson(e)).toList();
      return lists;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getAlbumsByOrder(int _order) async {
    try {
      final db = await instance.db;
      String _order1 = "playCount";
      if (_order == 1) _order1 = "created";
      var res = await db.rawQuery(
          "SELECT * FROM $AlbumsTable ORDER  BY $_order1 DESC LIMIT 10");
      if (res.length == 0) return null;
      List<Albums> lists = res.map((e) => Albums.fromJson(e)).toList();
      return lists;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  addSongs(List<Songs> _songs) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      for (Songs element in _songs) {
        batch.insert(SongsTable, element.toJson());
      }
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  updateSongs(List<Songs> _songs) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      for (Songs element in _songs) {
        batch.update(SongsTable, element.toJson(),
            where: "id = ?", whereArgs: [element.id]);
      }
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getSongsByOrder(int _order) async {
    try {
      final db = await instance.db;
      String _order1 = "playCount";
      if (_order == 1) _order1 = "created";
      var res = await db.rawQuery(
          "SELECT * FROM $SongsTable ORDER  BY $_order1 DESC LIMIT 5");
      if (res.length == 0) return null;
      List<Songs> lists = res.map((e) => Songs.fromJson(e)).toList();
      return lists;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getSongsByAlbumId(String albumId) async {
    try {
      final db = await instance.db;
      var res = await db
          .query(SongsTable, where: "albumId = ?", whereArgs: [albumId]);
      if (res.length == 0) return null;
      List<Songs> lists = res.map((e) => Songs.fromJson(e)).toList();
      return lists;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getSongById(String id) async {
    try {
      final db = await instance.db;
      var res = await db.query(SongsTable, where: "id = ?", whereArgs: [id]);
      if (res.length == 0) return null;
      List<Songs> lists = res.map((e) => Songs.fromJson(e)).toList();
      return lists[0];
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getSongByName(String title, String title2) async {
    try {
      final db = await instance.db;
      if (title2 == "") title2 = title;
      var res = await db.rawQuery(
          "SELECT * FROM $SongsTable WHERE title like '%$title%' or  title like '%$title2%' ");

      if (res.length == 0) return null;
      List<Songs> lists = res.map((e) => Songs.fromJson(e)).toList();
      return lists;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  addSongsAndLyricTable(SongsAndLyric _artists) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.insert(SongsAndLyricTable, _artists.toJson());
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getLyricById(String _songId) async {
    try {
      final db = await instance.db;
      var res = await db
          .query(SongsAndLyricTable, where: "songId = ?", whereArgs: [_songId]);
      if (res.length == 0) return null;
      List<SongsAndLyric> lists =
          res.map((e) => SongsAndLyric.fromJson(e)).toList();
      SongsAndLyric _result = lists[0];
      return _result.lyric;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  addFavorite(Favorite _favorite) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.insert(FavoriteTable, _favorite.toJson());
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  delFavorite(String _id) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(FavoriteTable, where: "id = ?", whereArgs: [_id]);
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getFavorite() async {
    try {
      final db = await instance.db;
      var res = await db.query(FavoriteTable);
      if (res.length == 0) return null;
      List<Favorite> lists = res.map((e) => Favorite.fromJson(e)).toList();
      return lists;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getFavoritebyId(String _id) async {
    try {
      final db = await instance.db;
      var res =
          await db.query(FavoriteTable, where: "id = ?", whereArgs: [_id]);
      if (res.length == 0) return null;
      List<Favorite> lists = res.map((e) => Favorite.fromJson(e)).toList();
      return lists[0];
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  //fechar conexao com o banco de dados, funcao nao usada nesse app
  Future close() async {
    final db = await instance.db;
    db.close();
  }
}
