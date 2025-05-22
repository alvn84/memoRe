import 'package:flutter/material.dart';
import 'package:memore/offline/screen/sidebar/setting/info/info_screen.dart';
import 'package:memore/offline/screen/sidebar/setting/security/secure_screen.dart';
import 'package:memore/offline/screen/sidebar/setting/data/data_screen.dart';
import 'package:memore/offline/screen/sidebar/setting/friend_func/friend_setting_screen.dart';
import 'package:memore/offline/screen/sidebar/setting/ai/ai_setting_screen.dart';
import 'package:memore/offline/screen/sidebar/setting/notify/notify_screen.dart';
import 'package:memore/offline/screen/sidebar/setting/display/display_setting_screen.dart';
import 'package:memore/offline/screen/sidebar/setting/language/lang_setting_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent, // 배경 투명
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15.0), // 위아래 + 양옆 padding
        children: [

          // 🔧 일반 설정
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'General',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('언어 설정'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageSettingScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('디스플레이 설정'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DisplaySettingScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('알림 설정'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationSettingScreen()),
              );
            },
          ),
          const SizedBox(height: 10),


          // 🧠 AI 및 기능 설정
          const Divider(),
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Functions',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.auto_awesome),
            title: Text('AI 설정'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AiSettingScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.groups),
            title: Text('친구 설정'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendSettingScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.folder_copy),
            title: Text('데이터 관리'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DataManageScreen()),
              );
            },
          ),
          const SizedBox(height: 10),


          // 🔒 보안
          const Divider(),
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Security',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('개인정보 및 보안'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacySecurityScreen()),
              );
            },
          ),
          const SizedBox(height: 10),


          // ℹ️ 기타
          const Divider(),
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Etc',
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