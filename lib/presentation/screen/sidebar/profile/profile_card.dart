import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../auth/api_config.dart';
import '../../auth/token_storage.dart';
import '../model/user_model.dart';
import 'profile_setting_screen.dart'; // ⭐️ 추가: 프로필 설정 화면 임포트
import '../../../screen/auth/login/login_screen.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  Future<User?> fetchCurrentUser() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return User.fromJson(json);
    } else {
      print('사용자 정보 요청 실패: ${response.statusCode}');
      return null;
    }
  }

  String extractIdFromEmail(String email) {
    if (!email.contains('@')) return email;
    return email.split('@').first;
  }

  String extractDomainFromEmail(String email) {
    if (!email.contains('@')) return '';
    return '@${email.split('@').last}';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: fetchCurrentUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 앱 로고
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Image.asset(
                'assets/images/logo.png',
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 5),

            // 프로필 카드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProfileSettingScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F4F8),
                    borderRadius: BorderRadius.circular(20),
                    /* boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFF1E6),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],*/
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                        backgroundColor: Color(0xFFE0E0E0),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user != null ? extractIdFromEmail(user.email) : '로딩 중...',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user != null ? extractDomainFromEmail(user.email) : '',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),

                      // 🔵 로그인 버튼
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6495ED),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Sign out'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
