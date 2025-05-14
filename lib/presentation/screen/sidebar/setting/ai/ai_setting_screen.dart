import 'package:flutter/material.dart';

class AiSettingScreen extends StatefulWidget {
  const AiSettingScreen({super.key});

  @override
  State<AiSettingScreen> createState() => _AiSettingScreenState();
}

class _AiSettingScreenState extends State<AiSettingScreen> {
  bool enableAiSummary = true;
  bool enableAiCorrection = true;
  bool enableVoiceToText = false;
  bool enableAutoCategorization = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 설정'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            title: const Text('메모 자동 요약'),
            subtitle: const Text('작성한 메모를 요약하여 핵심 정보만 표시합니다'),
            value: enableAiSummary,
            onChanged: (value) {
              setState(() {
                enableAiSummary = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('문장 자동 교정'),
            subtitle: const Text('맞춤법, 문법 등을 자동으로 교정합니다'),
            value: enableAiCorrection,
            onChanged: (value) {
              setState(() {
                enableAiCorrection = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('메모 자동 분류'),
            subtitle: const Text('메모 내용을 분석하여 카테고리에 자동 분류합니다'),
            value: enableAutoCategorization,
            onChanged: (value) {
              setState(() {
                enableAutoCategorization = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
