// - - - - - - - - - - - - - - - Tab1에서 개별 폴더 디자인 - - - - - - - - - - - - - - -
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../folder_feature/folder_model.dart';

class FolderTile extends StatelessWidget {
  final Folder folder;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const FolderTile({
    super.key,
    required this.folder,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: folder.color,
            ),
            child: CircleAvatar(
              radius: 33,
              backgroundColor: const Color(0xFFFFFBF5),
              backgroundImage: folder.imagePath != null
                  ? FileImage(File(folder.imagePath!))
                  : null,
              child: folder.imagePath == null
                  ? Icon(Icons.flight_takeoff, color: folder.color, size: 30)
                  : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            folder.name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            DateFormat('yy/MM/dd').format(folder.createdAt),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}