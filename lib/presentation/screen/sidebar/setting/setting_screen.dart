import 'package:flutter/material.dart';
import 'package:memore/presentation/screen/sidebar/setting/info/info_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
        backgroundColor: Colors.transparent, // 배경 투명
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15.0), // 위아래 + 양옆 padding
        children: [

          // 🔧 일반 설정
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '일반 설정',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('언어 설정'),
          ),
          const ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('디스플레이 설정'),
          ),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('알림 설정'),
          ),
          const SizedBox(height: 10),


          // 🧠 AI 및 기능 설정
          const Divider(),
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'AI 및 기능 설정',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          const ListTile(
            leading: Icon(Icons.auto_awesome),
            title: Text('AI 설정'),
          ),
          const ListTile(
            leading: Icon(Icons.groups),
            title: Text('친구 및 팀 기능 설정'),
          ),
          const ListTile(
            leading: Icon(Icons.folder_copy),
            title: Text('데이터 관리'),
          ),
          const SizedBox(height: 10),


          // 🔒 보안
          const Divider(),
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '보안',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          const ListTile(
            leading: Icon(Icons.lock),
            title: Text('개인정보 및 보안'),
          ),
          const SizedBox(height: 10),


          // ℹ️ 기타
          const Divider(),
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '기타',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('앱 정보 및 피드백'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppInfoScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}