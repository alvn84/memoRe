import 'dart:io';
import 'package:flutter/material.dart';
import '../folder/folder_model.dart';

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
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // 배경 이미지
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: folder.color,
                image: folder.imagePath != null
                    ? DecorationImage(
                  image: folder.imagePath!.startsWith('assets/')
                      ? AssetImage(folder.imagePath!) as ImageProvider
                      : FileImage(File(folder.imagePath!)),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
            ),
            // 반투명 텍스트 배경 + 이름 표시
            // Positioned 위젯 안을 다음처럼 수정:
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      folder.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black38)],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (folder.destination != null || folder.dateRange != null)
                      const SizedBox(height: 4),
                    if (folder.destination != null)
                      Text(
                        folder.destination!,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    if (folder.dateRange != null)
                      Text(
                        '${folder.dateRange!.start.year}.${folder.dateRange!.start.month.toString().padLeft(2, '0')}.${folder.dateRange!.start.day.toString().padLeft(2, '0')}'
                            ' - ${folder.dateRange!.end.year}.${folder.dateRange!.end.month.toString().padLeft(2, '0')}.${folder.dateRange!.end.day.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}