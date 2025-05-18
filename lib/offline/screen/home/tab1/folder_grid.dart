import 'package:flutter/material.dart';
import '../folder/folder_model.dart';
import 'folder_tile.dart';

class FolderGrid extends StatelessWidget {
  final List<Folder> folders;
  final List<Folder> filteredFolders;
  final void Function(Folder folder) onTapFolder;
  final void Function(int originalIndex) onLongPressFolder;

  const FolderGrid({
    super.key,
    required this.folders,
    required this.filteredFolders,
    required this.onTapFolder,
    required this.onLongPressFolder,
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
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 20.0,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final folder = filteredFolders[index];
          final originalIndex = folders.indexOf(folder);

          return InkWell(
            onTap: () => onTapFolder(folder),
            onLongPress: () => onLongPressFolder(originalIndex),
            child: FolderTile(folder: folder),
          );
        },
      ),
    );
  }
}