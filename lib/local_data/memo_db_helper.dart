import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MemoDbHelper {
  static final MemoDbHelper instance = MemoDbHelper._init();
  static Database? _database;

  MemoDbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('memo.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE memos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        folderId INTEGER,
        createdAt TEXT
      );
    ''');
  }
}