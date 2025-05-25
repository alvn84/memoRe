import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../auth/token_storage.dart';
import '../../../../auth/api_config.dart';

// 메모 번역
Future<String> translateText(String inputText, String targetLang) async {
  final token = await TokenStorage.getToken(); // 로그인 기반 인증 사용 시
  final url = Uri.parse('$baseUrl/api/translate');

  print('📤 번역 요청 텍스트: $inputText');
  print('📤 요청 URL: $url');


  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 필요 없으면 제거 가능
      },
      body: jsonEncode({
        'text': inputText,
        'targetLanguage': targetLang,
      }),
    );

    print('📥 응답 코드: ${response.statusCode}');
    print('📥 응답 바디: ${response.body}');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['translatedText'] ?? '번역 결과 없음';
    } else {
      return '번역 실패: ${response.statusCode}';
    }
  } catch (e) {
    return '서버 오류: $e';
  }
}