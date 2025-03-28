import 'package:flutter/material.dart';

class Tab1Screen extends StatelessWidget {
  const Tab1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // 더미 폴더 데이터
    final List<Map<String, dynamic>> folders = [
      {'name': 'Default', 'color': Colors.black, 'icon': Icons.check_box},
      {'name': 'Starred', 'color': Colors.black, 'icon': Icons.star},
      {'name': 'Trash', 'color': Colors.black, 'icon': Icons.delete},
      {'name': 'Japan', 'color': Colors.deepPurple, 'icon': Icons.folder},
      {'name': 'Yeonnam', 'color': Colors.teal, 'icon': Icons.folder},
      {'name': 'Hongkong', 'color': Colors.redAccent, 'icon': Icons.folder},
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: GridView.builder(
          itemCount: folders.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3열
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8, // 높이 조절
          ),
          itemBuilder: (context, index) {
            final folder = folders[index];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  folder['icon'],
                  color: folder['color'],
                  size: 65, // 아이콘 크기 조절
                ),
                const SizedBox(height: 8),
                Text(
                  folder['name'],
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 72,
        decoration: BoxDecoration(
          border: const Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  print('새 폴더 만들기');
                },
                icon: const Icon(Icons.create_new_folder),
                iconSize: 35,
                tooltip: '새 폴더',
              ),
              IconButton(
                onPressed: () {
                  print('새 파일 만들기');
                },
                icon: const Icon(Icons.note_add),
                iconSize: 35,
                tooltip: '새 파일',
              ),
            ],
          ),
        ),
      ),
    );
  }
}