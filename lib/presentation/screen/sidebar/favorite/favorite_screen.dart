import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  final List<String> folderList = const [
    '여행 메모',
    '업무 기록',
    '일상 노트',
  ];

  final List<Map<String, String>> memoList = const [
    {
      'title': '제주도 여행 준비물',
      'date': '2025.04.10',
    },
    {
      'title': '회의록 - 서비스 기획',
      'date': '2025.04.08',
    },
    {
      'title': '맛집 리스트',
      'date': '2025.04.01',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '폴더',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...folderList.map((folder) => ListTile(
            leading: const Icon(Icons.folder, color: Color(0xFFE5CFC3)),
            title: Text(folder),
          )),
          const Divider(height: 32),
          const Text(
            '메모',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...memoList.map((memo) => ListTile(
            leading: const Icon(Icons.note, color: Color(0xFF8B674C)),
            title: Text(memo['title']!),
            subtitle: Text('${memo['date']}'),
          )),
        ],
      ),
    );
  }
}
