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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*const Text(
            '🏷️ 메모리 캡션 및 해시태그 추천',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),*/
          const SizedBox(height: 16),

          // ✅ 결과 있을 때
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_caption.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFC),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '✨ 추천 캡션',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    _caption,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  /*Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // 캡션 적용 등의 기능을 원한다면 여기에 구현
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check_circle_outline,
                          color: Color(0xFF4A90E2)),
                      label: const Text(
                        '캡션 적용',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A90E2),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE6F0FB),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            )

          // ❌ 결과 없을 때
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '아직 추천된 캡션이 없습니다.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
        ],
      ),
    );
  }
}