// - - - - - - - - - - - - - - - Tab1에서 폴더 리스트를 GridView 형식으로 보여주는 위젯 - - - - - - - - - - - - - - -
import 'package:flutter/material.dart';

import '../../folder_feature/folder_model.dart';
import 'folder_tile.dart';

class FolderGrid extends StatelessWidget {
  final List<Folder> folders;
  final List<Folder> filteredFolders;
  final void Function(Folder folder) onTapFolder;
  final void Function(int originalIndex) onLongPressFolder;
  final bool isFavoriteMode; // ⭐️ 추가

  const FolderGrid({
    super.key,
    required this.folders,
    required this.filteredFolders,
    required this.onTapFolder,
    required this.onLongPressFolder,
    this.isFavoriteMode = false, // ⭐️ 추가
  });

  @override
  Widget build(BuildContext context) {
    if (filteredFolders.isEmpty) {
      return const Center(child: Text('검색 결과 없음'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: filteredFolders.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isFavoriteMode ? 1 : 2, // ⭐️ 열 개수 조건부 설정
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: isFavoriteMode ? 3.2 : 0.95, // ⭐️ 비율도 다르게
        ),
        itemBuilder: (context, index) {
          final folder = filteredFolders[index];
          final originalIndex = folders.indexOf(folder);

          return InkWell(
            onTap: () => onTapFolder(folder),
            onLongPress: () => onLongPressFolder(originalIndex),
            child: FolderTile(
              key: ValueKey(
                  '${folder.id}_${folder.color.value}_${folder.imageUrl ?? ''}'),
              folder: folder,
              isFavoriteMode: isFavoriteMode, // ⭐️ 전달
            ),
          );
        },
      ),
    );
  }
}
