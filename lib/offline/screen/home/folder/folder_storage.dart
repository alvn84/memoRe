import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'folder_model.dart';

class FolderStorage {
  static const _key = 'folder_list';

  // 폴더 리스트 저장
  static Future<void> saveFolders(List<Folder> folders) async {
    final prefs = await SharedPreferences.getInstance();
    final folderListJson = jsonEncode(
      folders.map((folder) => folder.toJson()).toList(),
    );
    await prefs.setString(_key, folderListJson);
  }

  // 폴더 리스트 불러오기
  static Future<List<Folder>> loadFolders() async {
    final prefs = await SharedPreferences.getInstance();
    final folderListJson = prefs.getString(_key);

    List<Folder> loadedFolders = [];

    if (folderListJson != null) {
      final decoded = jsonDecode(folderListJson) as List;
      loadedFolders = decoded.map((item) => Folder.fromJson(item)).toList();
    }

    // ✅ Default 폴더가 없으면 추가
    final hasDefault = loadedFolders.any((f) => f.name == 'Default');
    if (!hasDefault) {
      loadedFolders.insert(
        0,
        Folder(
          name: 'Default',
          imagePath: 'assets/images/plane_image.png',
          color: const Color(0xFFCFCFCF),
          icon: Icons.folder,
          createdAt: DateTime.now(),
        ),
      );
    }

    return loadedFolders;
  }
}