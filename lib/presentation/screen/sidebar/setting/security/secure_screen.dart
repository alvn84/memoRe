import 'package:flutter/material.dart';
import 'package:memore/presentation/screen/sidebar/setting/security/lock_setting_screen.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보 및 보안'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. 사용자 정보 관리
          const Text('사용자 정보 관리',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('내 정보 보기 / 수정'),
            onTap: () {
              // TODO: 내 정보 화면으로 이동
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('비밀번호 변경'),
            onTap: () {
              // TODO: 비밀번호 변경 화면으로 이동
            },
          ),
          const Divider(height: 30),

          // 2. 로그인 및 인증 설정
          const SizedBox(height: 5),
          const Text('로그인 및 인증 설정',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('소셜 로그인 연동 관리'),
            onTap: () {
              // TODO: 연동 관리 화면으로 이동
            },
          ),
          const Divider(height: 30),

          // 3. 앱 보안 설정
          const SizedBox(height: 5),
          const Text('앱 보안 설정',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: const Text('앱 잠금 설정 (PIN/지문)'),
            onTap: () {
              // TODO: 앱 잠금 설정 화면으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LockSettingScreen()),
              );
            },
          ),
          const Divider(height: 30),

          // 4. 데이터 보호
          const SizedBox(height: 5),
          const Text('데이터 보호',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('내 데이터 다운로드'),
            onTap: () {
              // TODO: 데이터 백업 실행
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('내 데이터 삭제 요청'),
            onTap: () {
              // TODO: 데이터 삭제 확인 Dialog
            },
          ),
          const Divider(height: 30),

          // 5. 계정 탈퇴
          const SizedBox(height: 5),
          const Text('계정 탈퇴',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('계정 삭제'),
            textColor: Colors.red,
            onTap: () {
              // TODO: 계정 삭제 확인 Dialog
            },
          ),
        ],
      ),
    );
  }
}
