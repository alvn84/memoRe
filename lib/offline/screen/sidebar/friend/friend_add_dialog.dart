import 'package:flutter/material.dart';

Future<void> showAddFriendDialog(BuildContext context) {
  String name = '';
  String email = '';

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('친구 추가'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(hintText: '이메일 입력'),
            onChanged: (value) => email = value,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            if (name.trim().isNotEmpty && email.trim().isNotEmpty) {
              // TODO: 친구 추가 처리
              print('이름: $name / 이메일: $email'); // 테스트용 출력
              Navigator.of(context).pop(); // 창 닫기
            }
          },
          child: const Text('추가'),
        ),
      ],
    ),
  );
}
