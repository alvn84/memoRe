import 'package:flutter/material.dart';
import 'package:memore/presentation/screen/auth/api_config.dart';
import 'package:memore/presentation/screen/auth/token_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslateTab extends StatefulWidget {
  final String? title;
  final String? content;

  const TranslateTab({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<TranslateTab> createState() => _TranslateTabState();
}

class _TranslateTabState extends State<TranslateTab> {
  String _translated = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _translate(); // ✅ 번역 자동 실행
  }

  Future<void> _translate() async {
    final combined = '${widget.title}\n${widget.content}';
    setState(() => _isLoading = true);

    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/api/translate');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'text': combined,
          'targetLanguage': 'en', // 필요 시 변경 가능
        }),
      );

      print('📨 상태 코드: ${response.statusCode}');
      print('📨 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() => _translated = json['translatedText'] ?? '번역 결과 없음');
      } else {
        setState(() => _translated = '번역 실패: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _translated = '서버 오류: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📘 번역 결과',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_translated.isNotEmpty)
            Text(
              _translated,
              style: const TextStyle(fontSize: 14),
            )
          else
            const Text(
              '(번역 결과 없음)',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
        ],
      ),
    );
  }
}
