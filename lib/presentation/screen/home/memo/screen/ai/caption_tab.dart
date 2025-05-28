import 'package:flutter/material.dart';
import 'ai_repository.dart'; // generateCaption 함수 불러오기

class CaptionTab extends StatefulWidget {
  final String? title;
  final String? content;

  const CaptionTab({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<CaptionTab> createState() => _CaptionTabState();
}

class _CaptionTabState extends State<CaptionTab> {
  String _caption = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateCaption();
  }

  Future<void> _generateCaption() async {
    setState(() => _isLoading = true);

    try {
      final result = await generateCaption(
        widget.title ?? '',
        widget.content ?? '',
      );
      setState(() => _caption = result);
    } catch (e) {
      setState(() => _caption = '❌ 캡션 생성 실패: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // 긴 텍스트 대비 스크롤 가능하게
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🏷️ 메모리 캡션 및 해시태그 추천',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_caption.isNotEmpty)
            SelectableText(
              _caption,
              style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
            )
          else
            const Text(
              '(캡션 결과 없음)',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
        ],
      ),
    );
  }
}