import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memore/presentation/screen/auth/api_config.dart';
import 'package:memore/presentation/screen/auth/token_storage.dart';

Future<String> translateText(String text) async {
  if (text.trim().isEmpty) return '번역할 텍스트 없음';

  // 언어 감지: 한글이면 영어로, 영어면 한글로
  final isKorean = RegExp(r'[가-힣]').hasMatch(text);
  final targetLang = isKorean ? 'en' : 'ko';

  final token = await TokenStorage.getToken();
  final url = Uri.parse('$baseUrl/api/translate');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'text': text,
      'targetLanguage': targetLang,
    }),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['translatedText'] ?? '번역 결과 없음';
  } else {
    return '번역 실패: ${response.statusCode}';
  }
}

Future<String> summarizeText(String title, String content) async {
  const apiUrl = '$baseUrl/api/openai/summarize';
  final requestBody = {
    'title': title,
    'content': content,
  };

  print('📤 요약 요청 보냄:');
  print('📌 제목: $title');
  print('📝 내용: $content');

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        // 토큰 없이 서버에서 OpenAI 처리
      },
      body: jsonEncode(requestBody),
    );

    print('📥 서버 응답 코드: ${response.statusCode}');
    print('📥 서버 응답 바디: ${response.body}');
    if (response.statusCode == 200) {
      return response.body.trim();
    } else {
      return '요약 실패: ${response.statusCode}';
    }
  } catch (e) {
    return '요약 예외 발생: $e';
  }
}

