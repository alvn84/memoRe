import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/memo_model.dart';
import '../../../auth/token_storage.dart';
import '../../../auth/api_config.dart';

class MemoRepository {
  // 전체 메모 조회 (폴더 ID 기준)
  Future<List<Memo>> getMemos(int folderId) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/memos?folderId=$folderId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Memo.fromJson(json)).toList();
    } else {
      print('❌ 메모 조회 실패: ${response.statusCode} ${response.body}');
      throw Exception('메모 불러오기 실패');
    }
  }

  // 메모 저장
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
      print('✅ 저장할 메모 데이터: ${jsonEncode(memo.toJson())}');
      print('❌ 메모 저장 실패: ${response.statusCode} ${response.body}');
      throw Exception('메모 저장 실패');
    }
  }

  Future<void> saveQuickMemo(Memo memo) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/memos/quick'), // ✅ userId를 URL에 안 붙임
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(memo.toJson()),
    );

    if (response.statusCode != 200) {
      print('✅ 저장할 퀵메모 데이터: ${jsonEncode(memo.toJson())}');
      print('❌ 퀵메모 저장 실패: ${response.statusCode} ${response.body}');
      throw Exception('퀵메모 저장 실패');
    }
  }

  // 메모 수정
  Future<void> updateMemo(Memo memo) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/api/memos/${memo.id}'), // id를 경로에 포함
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(memo.toJson()),
    );

    if (response.statusCode != 200) {
      print('✅ 수정할 메모 데이터: ${jsonEncode(memo.toJson())}');
      print('❌ 메모 수정 실패: ${response.statusCode} ${response.body}');
      throw Exception('메모 수정 실패');
    }
  }

  // 메모 삭제
  Future<bool> deleteMemo(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/memos/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      print('❌ 메모 삭제 실패: ${response.statusCode}');
    }
    return response.statusCode == 200;
  }
}
