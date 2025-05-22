import 'package:flutter/material.dart';
import 'profile_setting_screen.dart'; // ⭐️ 프로필 설정 화면 임포트

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 앱 이름
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                MaterialPageRoute(builder: (context) => const ProfileSettingScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xFFF1F4F8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  // 👤 프로필 이미지 (원형)
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                    backgroundColor: Color(0xFFE0E0E0),
                  ),
                  const SizedBox(width: 16),

                  // 이름 및 상태
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Guest',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Not logged in',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // 🔵 로그인 버튼
                  ElevatedButton(
                    onPressed: () {
                      // 로그인 페이지로 이동 로직 작성
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6495ED),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}