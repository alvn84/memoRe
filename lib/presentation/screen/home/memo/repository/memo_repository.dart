import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/memo_model.dart';
import '../../../auth/token_storage.dart';

const String baseUrl = 'https://your-ngrok-url.ngrok-free.app'; // 실제 주소로 변경

class MemoRepository {
  // 전체 메모 조회 (폴더 기준)
  Future<List<Memo>> getMemos(String storagePath) async {
    final response = await http.get(
      Uri.parse('$baseUrl/memo/list?storagePath=$storagePath'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Memo.fromJson(json)).toList();
    } else {
      print('❌ 서버 응답 에러: ${response.statusCode} ${response.body}');
      throw Exception('메모 불러오기 실패');
    }
  }

  // 메모 저장
  Future<void> saveMemo(Memo memo) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('http://192.168.219.103:8080/api/memos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(memo.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('메모 저장 실패');
    }
  }

  // 메모 삭제
  Future<bool> deleteMemo(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/memo/delete'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );
    return response.statusCode == 200;
  }
}
