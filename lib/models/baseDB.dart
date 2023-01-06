import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'myModel.dart';

class BaseDB {
  static final BaseDB instance = BaseDB._init();
  static Database? _db;
  //o banco de dados sera iniciado na instancia da classe
  BaseDB._init();

  final String dbName = "xiumusic.db";
  final String ServerInfoTable = "serverInfo";
  final String GenresTable = "genres";
  final String ArtistsTable = "artists";
  final String AlbumsTable = "albums";
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
                year INTEGER NOT NULL,
                coverArt TEXT NOT NULL,
                duration INTEGER NOT NULL,
                playCount INTEGER NOT NULL,
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
                albumId TEXT NOT NULL,
                artistId TEXT NOT NULL,
                size INTEGER NOT NULL,
                duration INTEGER NOT NULL,
                bitRate INTEGER NOT NULL,
                path TEXT NOT NULL,
                playCount INTEGER NOT NULL,
                created TEXT NOT NULL
              )
        ''');
  }

  // 增
  // list -> 写入到posts -> for性能非常低下，batch insert
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

  addGenres(List<Genres> _genres) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      //暴力更新
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

//batch.update('Test', {'name': 'new_item'}, where: 'name = ?', whereArgs: ['item']);
  // 删
  deleteServerInfo(String _username) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(ServerInfoTable,
          where: '[username] = ?', whereArgs: [_username]);
      var res = await batch.commit();
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  // 改
  // toJson -> Array & Object -> SQLite
  // updateServerInfo(List<ServerInfo> lists) async {
  //   try {
  //     final db = await instance.db;
  //     Batch batch = db.batch();
  //     lists.forEach((element) {
  //       batch.update(ServerInfoTable, element.toJson(),
  //           where: '[uid] = ?', whereArgs: [element.uid]);
  //     });
  //     var res = await batch.commit();
  //     return res;
  //   } catch (err) {
  //     print('err is 👉 $err');
  //   }
  // }

  // 查
  getServerInfo() async {
    try {
      final db = await instance.db;
      var res = await db.query(ServerInfoTable);
      // List
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
      // List
      if (res.length == 0) return null;
      List<Genres> lists = res.map((e) => Genres.fromJson(e)).toList();
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
