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

  String _summarizedTranslation = '';
  bool _isSummarizing = false;
  bool _isSummaryMode = false;
  String _originalTranslation = '';

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
      setState(() {
        _originalTranslation = translated; // ✅ 원본 저장
        _translated = translated;
      });
    } catch (e) {
      setState(() => _translated = '번역 실패: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _summarizeThenTranslate() async {
    final title = widget.title ?? '';
    final content = widget.content ?? '';

    setState(() {
      _isSummarizing = true;
      _isSummaryMode = !_isSummaryMode; // ✅ 토글 ON/OFF
    });

    try {
      if (_isSummaryMode) {
        // 요약 후 번역
        final summary = await summarizeText(title, content);
        final translatedSummary = await translateText(summary);
        setState(() {
          _summarizedTranslation = translatedSummary;
          _translated = translatedSummary;
        });
      } else {
        // 다시 원래 번역으로 복귀
        setState(() => _translated = _originalTranslation);
      }
    } catch (e) {
      setState(() => _translated = '요약 번역 실패: $e');
    } finally {
      setState(() => _isSummarizing = false);
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
            '📘 메모리 번역',
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _summarizeThenTranslate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF6F6F6), // 연한 회색 배경
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isSummaryMode ? '전체 번역' : '요약 번역',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (_isSummarizing) const SizedBox(width: 8),
                  if (_isSummarizing)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (widget.onApplyTranslation != null) {
                    widget.onApplyTranslation!(_translated);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6F0FB),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '본문 대체',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A90E2),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 10),
          ] else
          // ✅ 요약 번역 결과 블록
          if (_isSummarizing)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_summarizedTranslation.isNotEmpty) ...[
            const Divider(height: 32),
            const Text(
              '🧾 요약된 번역',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SelectableText(
              _summarizedTranslation,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.onApplyTranslation != null) {
                    widget.onApplyTranslation!(_summarizedTranslation);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2F8FF),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '요약 번역으로 대치',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A90E2),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
