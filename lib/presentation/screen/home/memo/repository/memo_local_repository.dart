import 'package:sqflite/sqflite.dart';
import '../../../../../local_data/memo_db_helper.dart';
import '../../../../../local_data/model/memo_local_model.dart';

class MemoLocalRepository {
  static Future<void> saveMemo(LocalMemo localmemo) async {
    final db = await MemoDbHelper.instance.database;
    await db.insert('memos', localmemo.toMap());
  }

  static Future<void> saveQuickMemo(LocalMemo localmemo) async {
    final db = await MemoDbHelper.instance.database;
    await db.insert('memos', localmemo.toMap());
  }

  static Future<void> updateMemo(LocalMemo localmemo) async {
    final db = await MemoDbHelper.instance.database;
    await db.update(
      'memos',
      localmemo.toMap(),
      where: 'id = ?',
      whereArgs: [localmemo.id],
    );
  }

  static Future<List<LocalMemo>> getMemosByFolder(int folderId) async {
    final db = await MemoDbHelper.instance.database;
    final result = await db.query(
      'memos',
      where: 'folderId = ?',
      whereArgs: [folderId],
    );
    return result.map((e) => LocalMemo.fromMap(e)).toList();
  }
}