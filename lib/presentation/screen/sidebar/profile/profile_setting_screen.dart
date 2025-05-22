import 'package:flutter/material.dart';
import 'package:memore/presentation/screen/auth/login/login_screen.dart';
import 'package:http/http.dart' as http;

import '../../auth/api_config.dart';
import '../../auth/token_storage.dart';
import '../model/user_model.dart';
import 'dart:convert';

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.edit, size: 24),
                      onPressed: () {
                        // 프로필 사진 수정 기능 연결 예정
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('이름', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              decoration: const InputDecoration(
                hintText: '사용자 이름 입력',
              ),
            ),
            const SizedBox(height: 24),
            const Text('이메일', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              readOnly: true,
              decoration: const InputDecoration(
                hintText: 'email@example.com',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // 비밀번호 변경 기능 연결 예정
              },
              child: const Text('비밀번호 변경'),
            ),
            const Spacer(),
            Center(
              child: Text(
                '앱 버전 1.0.0',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
            // Spacer()
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()), // 🔥 로그인 스크린으로 이동
                      (route) => false, // 🔥 기존 화면 스택 다 제거
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('로그아웃'),
            ),

            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }
}