import 'package:flutter/material.dart';
import 'package:memore/presentation/screen/auth/api_config.dart';
import 'package:memore/presentation/screen/auth/token_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ai_repository.dart';

class TranslateTab extends StatefulWidget {
  final String? title;
  final String? content;
  final void Function(String translatedText)? onApplyTranslation;

  const TranslateTab({
    super.key,
    required this.title,
    required this.content,
    this.onApplyTranslation,
  });

  @override
  State<TranslateTab> createState() => _TranslateTabState();
}

class _TranslateTabState extends State<TranslateTab> {
  String _translated = '';
  bool _isLoading = false;
  bool isKorean(String text) {
    // 한글 유니코드 범위: U+AC00 ~ U+D7A3
    return RegExp(r'[가-힣]').hasMatch(text);
  }

  @override
  void initState() {
    super.initState();
    _translate(); // ✅ 번역 자동 실행
  }

  Future<void> _translate() async {
    final combined = widget.content ?? '';
    setState(() => _isLoading = true);

    try {
      final translated = await translateText(combined);
      setState(() => _translated = translated);
    } catch (e) {
      setState(() => _translated = '번역 실패: $e');
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
          else if (_translated.isNotEmpty) ...[
            Text(
              _translated,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.onApplyTranslation != null) {
                  widget.onApplyTranslation!(_translated); // 콜백 호출
                  Navigator.pop(context); // 창 닫기
                }
              },
              child: const Text('텍스트 대치하기'),
            ),
          ] else
            const Text(
              '(번역 결과 없음)',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
        ],
      ),
    );
  }
}
