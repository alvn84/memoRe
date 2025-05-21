// lib/presentation/screen/home/memo/repository/memo_repository.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../presentation/screen/auth/api_config.dart';
import '../../../../../presentation/screen/auth/token_storage.dart';
import '../cache/local_memo_cache.dart'; // ✅ 로컬 캐시 임포트
import '../model/memo_model.dart';

class MemoRepository {
  Future<void> saveMemo(Memo memo) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/memos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(memo.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('서버 저장 실패');
    }
  }

  // ✅ 서버 저장 + 캐시 저장
  Future<void> saveMemoWithCache(Memo memo) async {
    try {
      await saveMemo(memo); // 서버 저장
    } catch (_) {
      // 실패해도 무시하고 캐시 저장
    } finally {
      await LocalMemoCache.saveMemo(memo); // 항상 캐시 저장
    }
  }

  // ✅ 로컬 캐시에서 불러오기
  Future<List<Memo>> loadMemosFromCache() async {
    return await LocalMemoCache.loadMemos();
  }
}