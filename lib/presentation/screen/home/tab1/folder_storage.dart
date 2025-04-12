import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'folder_model.dart';

class FolderStorage {
  static const _key = 'folder_list';

  // 폴더 리스트 저장
  static Future<void> saveFolders(List<Folder> folders) async {
    final prefs = await SharedPreferences.getInstance();
    final userFolders =
        folders.where((folder) => folder.name != 'Default').toList();
    final folderListJson = jsonEncode(
      folders.map((folder) => folder.toJson()).toList(),
    );
    await prefs.setString(_key, folderListJson);
  }

  // 폴더 리스트 불러오기
  static Future<List<Folder>> loadFolders() async {
    final prefs = await SharedPreferences.getInstance();
    final folderListJson = prefs.getString(_key);

    List<Folder> userFolders = [];

    if (folderListJson != null) {
      final decoded = jsonDecode(folderListJson) as List;
      userFolders = decoded.map((item) => Folder.fromJson(item)).toList();
    }

    // Default 폴더는 항상 존재
    return [
      Folder(name: 'Default', color: Color(0xFF000000), icon: Icons.folder),
      ...userFolders,
    ];
  }
}
