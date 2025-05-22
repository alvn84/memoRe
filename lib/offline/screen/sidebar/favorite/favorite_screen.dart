import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/folder/folder_detail_screen.dart';
import '../../home/folder/folder_model.dart';
import '../../home/folder/folder_storage.dart';

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
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final allFolders = await FolderStorage.loadFolders();
    setState(() {
      favoriteFolders = allFolders.where((f) => f.isStarred).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: favoriteFolders.isEmpty
            ? const Center(child: Text('즐겨찾기한 폴더가 없습니다.'))
            : ListView.builder(
          itemCount: favoriteFolders.length,
          itemBuilder: (context, index) {
            final folder = favoriteFolders[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FolderDetailScreen(
                      folderName: folder.name,
                      imagePath: folder.imagePath,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: folder.imagePath == null ? folder.color : null,
                  image: folder.imagePath != null
                      ? DecorationImage(
                    image: FileImage(File(folder.imagePath!)),
                    fit: BoxFit.cover,
                  )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // 반투명 블러 박스
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          folder.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // ⭐️ 아이콘 표시 (오른쪽 상단)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(Icons.star, color: Colors.yellowAccent, size: 24),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}