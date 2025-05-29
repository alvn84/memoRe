import 'package:flutter/material.dart';
import '../../../../auth/token_storage.dart';
import '../../../../auth/api_config.dart';
import 'ai_repository.dart'; // ✅ 요약 로직 사용

class SummaryTab extends StatefulWidget {
  final String? title;
  final String? content;
  final void Function(String translatedText)? onApplyTranslation;

  const SummaryTab({
    super.key,
    required this.title,
    required this.content,
    this.onApplyTranslation,
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
    _summarize();
  }

  @override
  void didUpdateWidget(covariant SummaryTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.title != oldWidget.title ||
        widget.content != oldWidget.content) {
      _summarize(); // ✅ 내용이 바뀌면 요약 다시 실행
    }
  }

  Future<void> _summarize() async {
    setState(() => _isLoading = true);

    try {
      final result = await summarizeText(
        widget.title ?? '',
        widget.content ?? '',
      );
      setState(() => _summary = result);
    } catch (e) {
      setState(() => _summary = '❌ 요약 실패: $e');
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
            '📝 메모리 요약',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),*/
          const SizedBox(height: 12),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_summary.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F9FF),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.notes, color: Color(0xFF4A90E2)),
                      SizedBox(width: 8),
                      Text(
                        'AI 요약 결과',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A90E2)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    _summary,
                    style: const TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (widget.onApplyTranslation != null) {
                          widget.onApplyTranslation!(_summary);
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.swap_horiz, size: 18),
                      label: const Text('본문 대체'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE6F0FB),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: const Color(0xFF4A90E2),
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
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
