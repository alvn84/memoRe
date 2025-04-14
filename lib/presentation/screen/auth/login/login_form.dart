import 'package:flutter/material.dart';
import '../../home/home_screen.dart';

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
                onPressed: () {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text;

                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter your email.',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                    return;
                  }
                  if (!emailRegex.hasMatch(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter a valid email address.',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                    return;
                  }
                  if (password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter your password.',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                    return;
                  }
                  if (password.length < 6) {
                    // ✨ 추가된 부분
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Password must be at least 6 characters.',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                    return;
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 14, // ⭐️ 폰트 크기
                    fontWeight: FontWeight.w900, // ⭐️ 약간 두껍게 (Montserrat랑 잘 어울림)
                    color: Color(0xFFFFFBF5), // 글씨 색상 (모카무스 느낌)
                  ),
                ),
              ),
            ),
          ),
        ),
/*
        const SizedBox(height: 12),
        Center(
          // skip 버튼 없애려면 여기 이 Center 컴포넌트랑 바로 위 SizedBox 날려버리기
          child: TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: const Text(
              'Skip (테스트용)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey, // ✅ 메인 포인트 컬러도 아님. 그냥 조용하게 회색.
              ),
            ),
          ),
        ),
*/
      ],
    );
  }
}
