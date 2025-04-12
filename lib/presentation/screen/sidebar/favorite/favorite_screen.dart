import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
      ),
      body: const Center(
        child: Text(
          '즐겨찾기한 메모가 여기에 표시됩니다.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
