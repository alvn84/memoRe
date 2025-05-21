// - - - - - - - - - - - - - - - 새 폴더 만들기 창 - - - - - - - - - - - - - - -
import 'package:flutter/material.dart';

Future<String?> showAddFolderDialog(BuildContext context) {
  String folderName = '';

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Make New Memo:Re',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Color(0xFFFAFAFA),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(hintText: '메모리 이름 입력'),
        onChanged: (value) => folderName = value,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        TextButton(
          onPressed: () {
            if (folderName.trim().isNotEmpty) {
              Navigator.of(context).pop(folderName.trim());
            }
          },
          child: Text(
            'Confirm',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF6495ED)),
          ),
        ),
      ],
    ),
  );
}
