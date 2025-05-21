// lib/presentation/screen/home/memo/cache/local_memo_cache.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/memo_model.dart'; // Memo 모델을 import

class LocalMemoCache {
  static const _key = 'local_memos';

  static Future<void> saveMemo(Memo memo) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_key) ?? [];
    final List<Map<String, dynamic>> memoList =
    rawList.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

    // 같은 id 삭제 후 덮어쓰기
    memoList.removeWhere((e) => e['id'] == memo.id);
    memoList.add(memo.toJson());

    prefs.setStringList(_key, memoList.map(jsonEncode).toList());
  }

  static Future<List<Memo>> loadMemos() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_key) ?? [];
    return rawList.map((e) => Memo.fromJson(jsonDecode(e))).toList();
  }
}