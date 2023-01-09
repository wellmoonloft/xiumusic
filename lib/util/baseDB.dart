import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/myModel.dart';

class BaseDB {
  static final BaseDB instance = BaseDB._init();
  static Database? _db;
  BaseDB._init();

  final String dbName = "xiumusic.db";
  // ignore: non_constant_identifier_names
  final String ServerInfoTable = "serverInfo";
  // ignore: non_constant_identifier_names
  final String GenresTable = "genres";
  // ignore: non_constant_identifier_names
  final String ArtistsTable = "artists";
  // ignore: non_constant_identifier_names
  final String AlbumsTable = "albums";
  // ignore: non_constant_identifier_names
  final String SongsTable = "songs";

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
                password TEXT NOT NULL,
                salt TEXT NOT NULL,
                hash TEXT NOT NULL
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
                created TEXT NOT NULL
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
                created TEXT NOT NULL
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

  // list -> 写入到posts -> for性能非常低下，batch insert
  addGenres(List<Genres> _genres) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(GenresTable);
      await batch.commit(noResult: true);
      for (Genres element in _genres) {
        batch.insert(GenresTable, element.toJson());
      }
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  addArtists(List<Artists> _artists) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(ArtistsTable);
      await batch.commit(noResult: true);
      for (Artists element in _artists) {
        batch.insert(ArtistsTable, element.toJson());
      }
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  addAlbums(List<Albums> _albums, String artistId) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(AlbumsTable, where: "artistId = ?", whereArgs: [artistId]);
      await batch.commit(noResult: true);
      for (Albums element in _albums) {
        batch.insert(AlbumsTable, element.toJson());
      }
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  addSongs(List<Songs> _songs, String albumId) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(SongsTable, where: "albumId = ?", whereArgs: [albumId]);
      await batch.commit(noResult: true);
      for (Songs element in _songs) {
        batch.insert(SongsTable, element.toJson());
      }
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
      batch.delete(GenresTable);
      batch.delete(ArtistsTable);
      batch.delete(AlbumsTable);
      batch.delete(SongsTable);
      var res = await batch.commit();
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

  getSongs(String albumId) async {
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

  //fechar conexao com o banco de dados, funcao nao usada nesse app
  Future close() async {
    final db = await instance.db;
    db.close();
  }
}
