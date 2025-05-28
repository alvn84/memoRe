// - - - - - - - - - - - - - - - Tab1에서 개별 폴더 디자인 - - - - - - - - - - - - - - -
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../folder_feature/folder_model.dart';

class FolderTile extends StatelessWidget {
  final Folder folder;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isFavoriteMode; // ⭐️ 추가

  const FolderTile({
    super.key,
    required this.folder,
    this.onTap,
    this.onLongPress,
    this.isFavoriteMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = (folder.startDate != null && folder.endDate != null)
        ? '${DateFormat('yyyy.MM.dd').format(folder.startDate!)} ~ ${DateFormat('yyyy.MM.dd').format(folder.endDate!)}'
        : '날짜 미정';

    final locationText = folder.location ?? '위치 없음';

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: isFavoriteMode ? 120 : 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: folder.color,
            image: (folder.imageUrl != null &&
                    folder.imageUrl != "null" &&
                    folder.imageUrl!.isNotEmpty)
                ? DecorationImage(
                    image: folder.imageUrl!.startsWith('http')
                        ? NetworkImage(folder.imageUrl!)
                        : folder.imageUrl!.startsWith('assets/')
                            ? AssetImage(folder.imageUrl!) as ImageProvider
                            : FileImage(File(folder.imageUrl!)),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Stack(
            children: [
              // 배경 이미지
              // ✅ 즐겨찾기 아이콘 (오른쪽 상단에 조건부 표시)
              if (isFavoriteMode || folder.isStarred)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 28,
                  ),
                ),
              // 반투명 텍스트 배경 + 이름 표시
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
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
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        locationText,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        dateText,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
