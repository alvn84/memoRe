import 'package:flutter/material.dart';
import '../login/login_screen.dart';
import '../setting/setting_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer 상단 유저 정보 영역
          const UserAccountsDrawerHeader(
            accountName: Text('사용자 이름'),
            accountEmail: Text('email@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/profile.png'), // 프로필 이미지 있으면 사용
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
          ),

          // 메뉴 리스트
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('홈'),
            onTap: () {
              Navigator.pop(context); // 드로어 닫기
              // Navigator.push(context, MaterialPageRoute(...)); ← 홈 이동 예시
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('설정'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('앱 정보'),
              onTap: () {
                Navigator.pop(context); // 드로어 닫기
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('앱 정보'),
                      content: const Text('버전: 1.0.0\n개발자: TRAVELOG Team\n이 앱은 여행 메모를 위한 앱입니다.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('닫기'),
                        ),
                      ],
                    );
                  },
                );
              }
          ),
          const Divider(),

          // 로그아웃
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('로그아웃'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false, // ← 이전 스택 모두 제거
              );
            },
          ),
        ],
      ),
    );
  }
}
