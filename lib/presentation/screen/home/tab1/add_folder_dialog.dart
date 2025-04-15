import 'package:flutter/material.dart';

Future<String?> showAddFolderDialog(BuildContext context) {
  String folderName = '';
  
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('새 폴더 만들기'),
      backgroundColor: Color(0xFFFFFBF5),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(hintText: '폴더 이름 입력'),
        onChanged: (value) => folderName = value,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            if (folderName.trim().isNotEmpty) {
              Navigator.of(context).pop(folderName.trim());
            }
          },
          child: const Text('확인'),
        ),
      ],
    ),
  );
}