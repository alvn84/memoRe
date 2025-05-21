import 'package:flutter/material.dart';
import 'package:memore/offline/screen/home/home_screen.dart';
import '../../home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../token_storage.dart';
import '../api_config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return; // ✅ mounted 확인
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (!mounted) return; // ✅ await 이후에도 항상 mounted 체크
      if (response.statusCode == 200) {
        print('로그인 성공: ${response.body}');

        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        await TokenStorage.saveToken(token);
        print('✅ 저장된 토큰: $token');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        print('로그인 실패: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    } catch (e) {
      if (!mounted) return; // ✅ 예외 처리 후에도 확인
      print('에러 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('네트워크 오류가 발생했습니다')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Center(
          child: SizedBox(
            width: 250,
            child: TextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              style: const TextStyle(
                // ✨ 추가
                fontWeight: FontWeight.w600, // 몬트세라트 w500 중간 두께
              ),
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), // 텍스트필드 둥글기 조절
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5CFC3), // 기본 테두리 색상
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFFB89B89), // 포커스(선택 시) 테두리 색상
                    width: 2.0, // 테두리 두께 (선택)
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 16), // ✨ 추가
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: SizedBox(
            width: 250,
            child: TextField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              obscureText: true,
              autofocus: false,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), // 텍스트필드 둥글기 조절
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5CFC3), // 기본 테두리 색상
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFFB89B89), // 포커스(선택 시) 테두리 색상
                    width: 2.0, // 테두리 두께 (선택)
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 16), // ✨ 추가
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Center(
          child: FractionallySizedBox(
            widthFactor: 0.4,
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB89B89), // 배경색
                ),
                onPressed: _handleLogin,
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 14,
                    // ⭐️ 폰트 크기
                    fontWeight: FontWeight.w900,
                    // ⭐️ 약간 두껍게 (Montserrat랑 잘 어울림)
                    color: Color(0xFFFAFAFA), // 글씨 색상 (모카무스 느낌)
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          // skip 버튼 없애려면 여기 이 Center 컴포넌트랑 바로 위 SizedBox(12) 날려버리기
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFAFAFA), // 배경색
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const OfflineScreen()),
              );
            },
            child: const Text(
              '로그인 없이 사용',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFFB89B89), // ✅ 메인 포인트 컬러도 아님. 그냥 조용하게 회색.
              ),
            ),
          ),
        ),
      ],
    );
  }
}
