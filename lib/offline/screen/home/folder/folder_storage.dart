import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'folder_model.dart';

class FolderStorage {
  static const _key = 'folder_list';

  // 폴더 리스트 저장
  static Future<void> saveFolders(List<Folder> folders) async {
    final prefs = await SharedPreferences.getInstance();
    final folderJsonList = folders.map((f) => jsonEncode(f.toJson())).toList();
    await prefs.setStringList('folders', folderJsonList);
  }

  // 폴더 리스트 불러오기
  static Future<List<Folder>> loadFolders() async {
    final prefs = await SharedPreferences.getInstance();
    final folderJsonList = prefs.getStringList('folders') ?? [];

    return folderJsonList.map((jsonStr) {
      final jsonMap = jsonDecode(jsonStr);
      return Folder.fromJson(jsonMap);
    }).toList();
  }
}