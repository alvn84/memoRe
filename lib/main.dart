import 'package:flutter/material.dart';
import 'package:memore/presentation/screen/auth/login/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // 🔑 .env 파일 로딩 (가장 먼저 실행되어야 함)

  runApp(
    MaterialApp(
      title: 'Memo:Re',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Color(0xFFFAFAFA), // 배경 색상 통일
        // 다른 테마 속성도 같이 설정 가능
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    ),
  );
}
