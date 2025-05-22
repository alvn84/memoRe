import 'package:flutter/material.dart';

class DisplaySettingScreen extends StatefulWidget {
  const DisplaySettingScreen({super.key});

  @override
  State<DisplaySettingScreen> createState() => _DisplaySettingScreenState();
}

class _DisplaySettingScreenState extends State<DisplaySettingScreen> {
  bool isDarkMode = false;
  double fontSize = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('디스플레이 설정'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '테마 설정',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text('다크 모드'),
            subtitle: const Text('앱을 어두운 테마로 전환합니다'),
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
              // 여기에 실제 테마 변경 로직 추가 가능
            },
          ),
          const SizedBox(height: 20),
          const Text(
            '글꼴 크기',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Slider(
            value: fontSize,
            min: 12,
            max: 24,
            divisions: 6,
            label: '${fontSize.toInt()}pt',
            onChanged: (value) {
              setState(() {
                fontSize = value;
              });
              // 여기에 글꼴 크기 적용 로직 추가 가능
            },
          ),
        ],
      ),
    );
  }
}
