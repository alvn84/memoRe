import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';
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
    final rawText = json['translatedText'] ?? '번역 결과 없음';

    // ✅ HTML 엔티티 디코딩
    final unescaped = HtmlUnescape().convert(rawText);

    return unescaped;
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

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        // 토큰 없이 서버에서 OpenAI 처리
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return response.body.trim();
    } else {
      return '요약 실패: ${response.statusCode}';
    }
  } catch (e) {
    return '요약 예외 발생: $e';
  }
}

Future<String> generateCaption(String title, String content) async {
  const apiUrl = '$baseUrl/api/openai/caption';
  final requestBody = {
    'title': title,
    'content': content,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        // 토큰 없이 서버에서 OpenAI 처리 (필요 시 추가)
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return response.body.trim();
    } else {
      return '캡션 생성 실패: ${response.statusCode}';
    }
  } catch (e) {
    return '캡션 예외 발생: $e';
  }
}

class MapPlace {
  final String name;
  final double lat;
  final double lng;

  MapPlace({required this.name, required this.lat, required this.lng});

  factory MapPlace.fromJson(Map<String, dynamic> json) {
    return MapPlace(
      name: json['name'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

Future<List<MapPlace>> extractMapPlaces(String memoText) async {
  final token = await TokenStorage.getToken();
  final url = Uri.parse('$baseUrl/api/maps');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'memoText': memoText, // ✅ memoId 제거
    }),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final List places = json['places'] ?? [];

    return places.map((place) => MapPlace.fromJson(place)).toList();
  } else {
    throw Exception('장소 추출 실패: ${response.statusCode}');
  }
}
