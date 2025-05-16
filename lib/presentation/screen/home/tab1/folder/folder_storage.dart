import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../folder_feature/folder_model.dart';
import '../../../auth/token_storage.dart';
import '../../../auth/api_config.dart';


class FolderStorage {
  // 폴더 전체 조회
  static Future<List<Folder>> loadFolders() async {
    final token = await TokenStorage.getToken(); // 🔐 로그인 토큰 불러오기

    final response = await http.get(
      Uri.parse('$baseUrl/api/folders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Folder> folders = data.map((json) => Folder.fromJson(json)).toList();

      final hasDefault = folders.any((f) => f.name == 'Default');

      if (!hasDefault) {
        // 서버에 Default 폴더 생성 요청
        await saveFolder(Folder(
          id: 0,
          // 서버가 자동으로 처리
          name: 'Default',
          color: const Color(0xFFCFCFCF),
          icon: Icons.folder,
          createdAt: DateTime.now(),
        ));

        // 다시 폴더 목록 불러오기
        return await loadFolders();
      }

      return folders;
    } else {
      print('❌ 폴더 불러오기 실패: ${response.statusCode}');
      throw Exception('폴더 불러오기 실패');
    }
  }

  // 단일 폴더 저장
  static Future<void> saveFolder(Folder folder) async {
    final body = jsonEncode({'name': folder.name}); // 서버 요구사항에 맞게 name만 전송

    print('📤 서버에 보낼 폴더 데이터: $body'); // 🔍 전송 값 디버깅 로그

    final token = await TokenStorage.getToken(); // 👉 로그인 후 받은 토큰
    final response = await http.post(
      Uri.parse('$baseUrl/api/folders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // ✅ 여기에 추가
      },
      body: body,
    );

    if (response.statusCode != 200) {
      print('❌ 폴더 저장 실패: ${response.statusCode}');
      throw Exception('폴더 저장 실패');
    }
  }

  // 폴더 삭제
  static Future<void> deleteFolder(int? id) async {
    if (id == null) {
      print('❌ 삭제 실패: id가 null입니다.');
      return;
    }

    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/folders/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      print('❌ 폴더 삭제 실패: ${response.statusCode}');
      throw Exception('폴더 삭제 실패');
    }
  }
}
