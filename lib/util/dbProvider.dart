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
  final String SongsAndLyricTable = "songsAndLyric";

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
                neteaseapi TEXT,
                languageCode TEXT
              )
        ''');

    await _database.execute('''
              create table $SongsAndLyricTable (
                uid INTEGER PRIMARY KEY AUTOINCREMENT,
                lyric TEXT NOT NULL,
                songId TEXT NOT NULL
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
      batch.delete(SongsAndLyricTable);
      batch.delete("sqlite_sequence");
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

  addSongsAndLyricTable(SongsAndLyric _artists) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(SongsAndLyricTable,
          where: "songId = ?", whereArgs: [_artists.songId]);
      await batch.commit(noResult: true);
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

  Future close() async {
    final db = await instance.db;
    db.close();
  }
}
