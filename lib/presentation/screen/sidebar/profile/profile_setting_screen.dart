import 'package:flutter/material.dart';
import 'package:memore/presentation/screen/auth/login/login_screen.dart';
import 'package:http/http.dart' as http;

import '../../auth/api_config.dart';
import '../../auth/token_storage.dart';
import '../model/user_model.dart';
import 'dart:convert';

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필')),
      body: FutureBuilder<User?>(
        future: fetchCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 360,
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 400),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 50),
                                const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Color(0xFFD9D9D9),
                                  child: Icon(Icons.person,
                                      size: 50, color: Colors.white),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  user?.email ?? '이메일 불러오기 실패',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                if (user?.job != null)
                                  Text('직업: ${user!.job}',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                                if (user?.gender != null)
                                  Text('성별: ${user!.gender}',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                                if (user?.birthDate != null)
                                  Text('생년월일: ${user!.birthDate}',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 48),
                          /*Text(
                            '앱 버전 1.0.0',
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 12),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '로그아웃',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
