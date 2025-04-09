import 'package:flutter/material.dart';
import '../signup/signup_screen.dart';
import 'login_form.dart';
import '../forgot_password/forgot_password.dart';
import 'social_login_buttons.dart';
import '../social_login/google_login_screen.dart';
import '../social_login/kakao_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {

  Key _formKey = UniqueKey(); // ⭐️ 키를 매번 새로 주기

  void _refreshForm() {
    setState(() {
      _formKey = UniqueKey(); // 새 키 부여 → LoginForm 강제 rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // 빈 공간도 터치 감지
      onTap: () {
        FocusScope.of(context).unfocus(); // 키보드 내리기
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      'Memo:Re',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  LoginForm(key: _formKey), // ✅ 여기에 key 줌
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        ).then((_) {
                          FocusScope.of(context).unfocus();
                          _refreshForm(); // ⭐️ 돌아왔을 때 폼 새로 만듦
                        });
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('OR'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SocialLoginButtons(
                    onGoogleLogin: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GoogleLoginScreen(),
                        ),
                      ).then((_) {
                        FocusScope.of(context).unfocus();
                        _refreshForm(); // 돌아오면 폼 새로 리셋
                      });
                    },
                    onKakaoLogin: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KakaoLoginScreen(),
                        ),
                      ).then((_) {
                        FocusScope.of(context).unfocus();
                        _refreshForm(); // 돌아오면 폼 새로 리셋
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        ).then((_) {
                          FocusScope.of(context).unfocus();
                          _refreshForm(); // ⭐️ 돌아왔을 때 폼 새로 만듦
                        });
                      },
                      child: const Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
