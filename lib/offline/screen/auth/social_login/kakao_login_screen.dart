import 'package:flutter/material.dart';

class KakaoLoginScreen extends StatelessWidget {
  const KakaoLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kakao 로그인'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // TODO: 여기에 실제 카카오 로그인 로직 연결할 거야
          },
          child: const Text('카카오 계정으로 로그인'),
        ),
      ),
    );
  }
}