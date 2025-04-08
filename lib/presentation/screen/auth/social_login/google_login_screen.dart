import 'package:flutter/material.dart';

class GoogleLoginScreen extends StatelessWidget {
  const GoogleLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google 로그인'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // TODO: 여기에 실제 구글 로그인 로직 연결할 거야
          },
          child: const Text('구글 계정으로 로그인'),
        ),
      ),
    );
  }
}