import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'folder_model.dart';

const String baseUrl = 'https://your.api.url'; // 실제 서버 주소로 변경

class FolderStorage {
  // 폴더 전체 조회
  static Future<List<Folder>> loadFolders() async {
    final response = await http.get(Uri.parse('$baseUrl/folders'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final folders = data.map((e) => Folder.fromJson(e)).toList();

      // ✅ Default 폴더 없으면 클라이언트에서 추가 (선택)
      final hasDefault = folders.any((f) => f.name == 'Default');
      if (!hasDefault) {
        final defaultFolder = Folder(
          name: 'Default',
          color: const Color(0xFFCFCFCF),
          icon: Icons.folder,
          createdAt: DateTime.now(),
        );

        await saveFolder(defaultFolder); // 서버에 추가 요청
        folders.insert(0, defaultFolder);
      }

      return folders;
    } else {
      print('❌ 폴더 불러오기 실패: ${response.statusCode}');
      throw Exception('폴더 로딩 실패');
    }
  }

  // 단일 폴더 저장
  static Future<void> saveFolder(Folder folder) async {
    final response = await http.post(
      Uri.parse('$baseUrl/folders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(folder.toJson()),
    );

    if (response.statusCode != 200) {
      print('❌ 폴더 저장 실패: ${response.statusCode}');
      throw Exception('폴더 저장 실패');
    }
  }

  // 전체 폴더 저장 (필요 시 일괄 저장 API가 있는 경우)
  static Future<void> saveFolders(List<Folder> folders) async {
    final response = await http.post(
      Uri.parse('$baseUrl/folders/bulk'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(folders.map((f) => f.toJson()).toList()),
    );

    if (response.statusCode != 200) {
      print('❌ 폴더 목록 저장 실패: ${response.statusCode}');
      throw Exception('폴더 목록 저장 실패');
    }
  }
}