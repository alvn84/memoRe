import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../../../../auth/token_storage.dart';
import '../../../../auth/api_config.dart';




class SummaryTab extends StatefulWidget {
  final String? title;
  final String? content;

  const SummaryTab({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<SummaryTab> createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab> {
  String _summary = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _summarize(); // 자동 실행
  }

  Future<void> _summarize() async {
    setState(() => _isLoading = true);

    const apiUrl = '$baseUrl/api/openai/summarize'; // 👉 서버 주소로 변경
    final requestBody = {
      'title': widget.title,
      'content': widget.content,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          // OpenAI API 키는 프론트에서 보내지 않음 ❌ 서버가 내부적으로 처리
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        setState(() {
          _summary = response.body.trim();
        });
      } else {
        setState(() {
          _summary = '❌ 오류: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _summary = '❌ 예외 발생: $e';
      });
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
            '📝 메모리 요약',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_summary.isNotEmpty)
            Text(
              _summary,
              style: const TextStyle(fontSize: 14),
            )
          else
            const Text(
              '(요약 결과 없음)',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
        ],
      ),
    );
  }
}
