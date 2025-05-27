import 'package:flutter/material.dart';

class LanguageSettingScreen extends StatefulWidget {
  const LanguageSettingScreen({super.key});

  @override
  State<LanguageSettingScreen> createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen> {
  String _selectedAppLanguage = '한국어';
  String _selectedTranslationLanguage = 'English';

  final List<String> _languages = [
    '한국어',
    'English',
    '日本語',
    '中文',
    'Español',
    'Français',
  ];

  void _onAppLanguageChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedAppLanguage = value;
        // TODO: 앱 언어 변경 로직 (locale 변경 등)
      });
    }
  }

  void _onTranslationLanguageChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedTranslationLanguage = value;
        // TODO: 번역 대상 언어 변경 로직 저장
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('언어 설정'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '앱 언어 선택',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          for (final lang in _languages)
            RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: _selectedAppLanguage,
              onChanged: _onAppLanguageChanged,
            ),
          const Divider(height: 40),
          const Text(
            '번역 언어 선택',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          for (final lang in _languages)
            RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: _selectedTranslationLanguage,
              onChanged: _onTranslationLanguageChanged,
            ),
        ],
      ),
    );
  }
}
