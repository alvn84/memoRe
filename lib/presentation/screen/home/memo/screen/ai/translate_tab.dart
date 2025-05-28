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
            SelectableText(
              _translated,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (widget.onApplyTranslation != null) {
                    widget.onApplyTranslation!(_translated);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // 좀 더 세련된 블루
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  elevation: 10, // 그림자 강조
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // 둥글게
                  ),
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
                child: const Text(
                  'Replace Text',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: Color(0xFF4A90E2),
                  ),
                ),
              ),
            )
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
