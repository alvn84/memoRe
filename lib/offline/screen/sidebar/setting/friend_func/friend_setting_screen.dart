import 'package:flutter/material.dart';

class FriendSettingScreen extends StatefulWidget {
  const FriendSettingScreen({super.key});

  @override
  State<FriendSettingScreen> createState() => _FriendSettingScreenState();
}

class _FriendSettingScreenState extends State<FriendSettingScreen> {
  bool autoAcceptFriendRequest = false;
  bool isFriendListPublic = true;
  bool allowMemoShareFromFriend = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구 기능 설정'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // 👤 친구 기능
          const Text(
            '친구 기능',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 10),

          SwitchListTile(
            title: const Text('친구 요청 자동 수락'),
            subtitle: const Text('받은 친구 요청을 자동으로 수락'),
            value: autoAcceptFriendRequest,
            onChanged: (value) {
              setState(() {
                autoAcceptFriendRequest = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('친구 목록 공개'),
            subtitle: const Text('내 친구 목록을 다른 사용자에게 공개'),
            value: isFriendListPublic,
            onChanged: (value) {
              setState(() {
                isFriendListPublic = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('친구 메모 공유 허용'),
            subtitle: const Text('나에게 메모를 공유할 수 있도록 허용'),
            value: allowMemoShareFromFriend,
            onChanged: (value) {
              setState(() {
                allowMemoShareFromFriend = value;
              });
            },
          ),

          const Divider(height: 40),

          const Text(
            '친구 관리',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          const ListTile(
            leading: Icon(Icons.person_add_alt),
            title: Text('친구 추가'),
            subtitle: Text('이메일로 친구를 추가할 수 있습니다'),
          ),
          const ListTile(
            leading: Icon(Icons.list),
            title: Text('친구 목록 보기'),
            subtitle: Text('추가한 친구들을 확인하고 관리하세요'),
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('차단된 사용자 관리'),
            subtitle: const Text('차단한 친구들을 확인하고 해제할 수 있습니다'),
            onTap: () {
              // 차단된 사용자 관리 화면으로 이동 예정
            },
          ),
        ],
      ),
    );
  }
}
