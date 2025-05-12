import 'package:flutter/material.dart';

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
          const ListTile(
          leading: Icon(Icons.brightness_6),
            title: Text('다크 모드 설정'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('알림 설정'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.lock),
            title: Text('개인정보 및 보안'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('앱 정보'),
          ),
        ],
      ),
    );
  }
}