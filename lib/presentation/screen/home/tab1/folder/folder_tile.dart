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
                image: (folder.imageUrl != null &&
                    folder.imageUrl != "null" &&
                    folder.imageUrl!.isNotEmpty)
                    ? DecorationImage(
                  image: folder.imageUrl!.startsWith('http')
                      ? NetworkImage(folder.imageUrl!) // ✅ 서버 이미지 처리 추가
                      : folder.imageUrl!.startsWith('assets/')
                      ? AssetImage(folder.imageUrl!) as ImageProvider
                      : FileImage(File(folder.imageUrl!)), // 기존 로컬 파일 처리 유지
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {
                    print('❌ 이미지 로딩 실패: $error');
                  },
                )
                    : null,
              ),
            ),
            // ✅ 즐겨찾기 아이콘 (오른쪽 상단에 조건부 표시)
            if (folder.isStarred)
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
                child: Text(
                  folder.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 29,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
