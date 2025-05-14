import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// pubspec.yaml에 추가
// dependencies:
// local_auth: ^2.1.7
// shared_preferences: ^2.2.2
//
// flutter pub get 실행


class LockSettingScreen extends StatefulWidget {
  const LockSettingScreen({super.key});

  @override
  State<LockSettingScreen> createState() => _LockSettingScreenState();
}

class _LockSettingScreenState extends State<LockSettingScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _useBiometrics = false;
  String _pin = '';

  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
    _loadLockSettings();
  }

  Future<void> _checkBiometricSupport() async {
    final available = await auth.canCheckBiometrics;
    setState(() {
      _canCheckBiometrics = available;
    });
  }

  Future<void> _loadLockSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useBiometrics = prefs.getBool('use_biometrics') ?? false;
      _pin = prefs.getString('pin_code') ?? '';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_biometrics', _useBiometrics);
    if (_pinController.text.length == 4) {
      await prefs.setString('pin_code', _pinController.text);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('설정이 저장되었습니다')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('앱 잠금 설정'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_canCheckBiometrics) ...[
            SwitchListTile(
              title: const Text('지문 / Face ID 사용'),
              value: _useBiometrics,
              onChanged: (value) async {
                final authenticated = await auth.authenticate(
                  localizedReason: '생체 인증을 사용하시려면 인증해주세요',
                );
                if (authenticated) {
                  setState(() {
                    _useBiometrics = value;
                  });
                }
              },
            ),
            const Divider(),
          ],
          const Text('PIN 설정 (숫자 4자리)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'PIN 코드 입력',
              border: const OutlineInputBorder(),
              hintText: '예: 1234',
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _saveSettings,
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}
