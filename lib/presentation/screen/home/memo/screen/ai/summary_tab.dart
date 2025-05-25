import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final openAiApiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

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

    final text = '${widget.title}\n${widget.content}';
    const apiUrl = 'https://api.openai.com/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAiApiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': '당신은 여행 메모를 간결하게 요약해주는 어시스턴트입니다.'},
            {
              'role': 'user',
              'content': text,
            },
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _summary =
              data['choices'][0]['message']['content']?.trim() ?? '요약 실패';
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
