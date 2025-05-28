import 'package:flutter/material.dart';
import '../../../../auth/token_storage.dart';
import '../../../../auth/api_config.dart';
import 'ai_repository.dart'; // ✅ 요약 로직 사용

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
          const Text('📝 메모리 요약',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_summary.isNotEmpty)
            Text(_summary, style: const TextStyle(fontSize: 14))
          else
            const Text('(요약 결과 없음)',
                style: TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }
}
