import 'package:flutter/material.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 필요 시 transparent로 변경 가능
      appBar: AppBar(
        title: const Text('앱 정보 및 피드백'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView( // 혹시라도 화면 넘칠 경우 대비
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 32), // 바깥쪽 padding 넉넉하게
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              '📱  앱 정보',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text('• 앱 이름: Memo:Re', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            const Text('• 버전: 1.0.0', style: TextStyle(fontSize: 15)),
            const SizedBox(height: 8),
            const Text('• 제작: Y2K20 팀', style: TextStyle(fontSize: 15)),

            const SizedBox(height: 32),
            const Divider(thickness: 1),

            const SizedBox(height: 32),
            const Text(
              '✉️  피드백 보내기',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // TODO: 이메일 보내기 기능 구현
              },
              icon: const Icon(Icons.mail_outline),
              label: const Text('이메일로 피드백 보내기'),
            ),
          ],
        ),
      ),
    );
  }
}
