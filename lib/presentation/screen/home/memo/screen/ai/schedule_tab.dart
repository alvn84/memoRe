import 'package:flutter/material.dart';

class ScheduleTab extends StatelessWidget {
  final String? title;
  final String? content;

  const ScheduleTab({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // 긴 텍스트 대비 스크롤 가능하게
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📅 메모리 일정',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            '제목: $title',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            (content?.isEmpty ?? true) ? '(내용 없음)' : content!,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: 요약 기능 실행
              },
              icon: const Icon(Icons.auto_fix_high),
              label: const Text('요약하기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6495ED),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}