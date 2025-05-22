import 'package:flutter/material.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() => _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool newMemoNotification = true;
  bool scheduleNotification = true;
  bool aiSuggestionNotification = true;
  bool friendRequestNotification = true;
  bool backupCompleteNotification = false;
  bool securityAlertNotification = false;
  bool appUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림 설정'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            title: const Text('새 메모 알림'),
            subtitle: const Text('새로 작성된 메모에 대한 알림'),
            value: newMemoNotification,
            onChanged: (value) {
              setState(() {
                newMemoNotification = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('일정 알림'),
            subtitle: const Text('등록된 일정이 다가올 때 알림'),
            value: scheduleNotification,
            onChanged: (value) {
              setState(() {
                scheduleNotification = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('친구 요청 알림 받기'),
            subtitle: const Text('새 친구 요청이 오면 알림'),
            value: friendRequestNotification,
            onChanged: (value) {
              setState(() {
                friendRequestNotification = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('AI 추천 알림'),
            subtitle: const Text('AI가 새로운 요약/추천을 제공할 때'),
            value: aiSuggestionNotification,
            onChanged: (value) {
              setState(() {
                aiSuggestionNotification = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('백업 완료 알림'),
            subtitle: const Text('메모 자동 백업 또는 수동 백업 완료 후'),
            value: backupCompleteNotification,
            onChanged: (value) {
              setState(() {
                backupCompleteNotification = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('보안 알림'),
            subtitle: const Text('다른 기기에서 로그인 시도 등 보안 알림'),
            value: securityAlertNotification,
            onChanged: (value) {
              setState(() {
                securityAlertNotification = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('앱 업데이트 및 소식'),
            subtitle: const Text('앱 관련 공지 및 기능 업데이트'),
            value: appUpdates,
            onChanged: (value) {
              setState(() {
                appUpdates = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
