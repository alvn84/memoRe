import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.language, color: Color(0xFF6495ED)),
            title: Text('언어 설정',style: TextStyle(fontSize: 14)),
          ),


          const ListTile(
            leading: Icon(Icons.notifications, color: Color(0xFF6495ED)),
            title: Text('알림 설정',style: TextStyle(fontSize: 14)),
          ),


          const ListTile(
            leading: Icon(Icons.lock, color: Color(0xFF6495ED)),
            title: Text('개인정보 및 보안',style: TextStyle(fontSize: 14)),
          ),

          const ListTile(
            leading: Icon(Icons.info, color: Color(0xFF6495ED)),
            title: Text('앱 정보',style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}