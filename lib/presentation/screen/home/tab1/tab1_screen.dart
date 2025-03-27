import 'package:flutter/material.dart';

class Tab1Screen extends StatelessWidget {
  const Tab1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 메인 내용
        const Center(
          child: Text(
            'Tab 1 화면',
            style: TextStyle(fontSize: 20),
          ),
        ),

        // 하단 아이콘 버튼
        Positioned(
          bottom: 24,
          left: 24,
          child: FloatingActionButton(
            heroTag: 'create_folder',
            onPressed: () {
              // 새 폴더 생성 로직
              print('새 폴더 만들기');
            },
            tooltip: '새 폴더',
            child: const Icon(Icons.create_new_folder),
          ),
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            heroTag: 'create_file',
            onPressed: () {
              // 새 파일 생성 로직
              print('새 파일 만들기');
            },
            tooltip: '새 파일',
            child: const Icon(Icons.note_add),
          ),
        ),
      ],
    );
  }
}