import 'package:flutter/material.dart';
import '../../home/tab1/folder/folder_grid.dart';
import '../../home/tab1/folder/folder_repository.dart';
import '../../home/folder_feature/folder_model.dart';
import '../../home/folder_feature/folder_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Folder> favoriteFolders = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteFolders();
  }

  Future<void> _loadFavoriteFolders() async {
    try {
      final allFolders = await FolderRepository.loadFolders(); // 📡 전체 폴더 불러오기
      final starred =
          allFolders.where((f) => f.isStarred == true).toList(); // ⭐️ 즐겨찾기 필터링
      setState(() {
        favoriteFolders = starred;
      });
    } catch (e) {
      print('❌ 즐겨찾기 폴더 로딩 실패: $e');
    }
  }

  void _onTapFolder(Folder folder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FolderDetailScreen(
          folder: folder,
          folders:
              favoriteFolders, // 👉 또는 전체 folders 리스트가 필요한 경우 loadFolders() 결과 전체 전달
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
        backgroundColor: Colors.transparent,
      ),
      body: favoriteFolders.isEmpty
          ? const Center(child: Text('즐겨찾기된 폴더가 없습니다.'))
          : FolderGrid(
              folders: favoriteFolders,
              filteredFolders: favoriteFolders,
              onTapFolder: _onTapFolder,
              onLongPressFolder: (_) {},
              // 롱프레스 동작 필요 없으면 빈 함수
              isFavoriteMode: true,
            ),
    );
  }
}
