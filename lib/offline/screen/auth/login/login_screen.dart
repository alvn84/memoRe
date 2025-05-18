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

// ⭐️ 스타일 통합
const TextStyle logoTextStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Colors.deepPurple,
  fontFamily: 'Montserrat',
);

const TextStyle forgotPasswordStyle = TextStyle(
  fontSize: 13,
  color: Color(0xFF8B674C),
  fontFamily: 'Montserrat',
  fontWeight: FontWeight.w800,

);

const TextStyle signUpLinkStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w800,
    color: Color(0xFF8B674C)

);

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
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70),
                    Center(
                      child:
                      Image.asset(
                        'assets/images/logo.png',
                        height: 60,  // 로고 크기 조절
                        fit: BoxFit.contain,  // 비율 유지하면서 꽉 차게
                      ),
                    ),
                    const SizedBox(height: 24),
                    LoginForm(key: _formKey),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            ).then((_) {
                              FocusScope.of(context).unfocus();
                              _refreshForm();
                            });
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: forgotPasswordStyle, // ⭐️ 통합 스타일 사용
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      // 중간선
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    // 회원가입 문장과 버튼
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              ).then((_) {
                                FocusScope.of(context).unfocus();
                                _refreshForm();
                              });
                            },
                            child: const Text(
                              "Sign Up",
                              style: signUpLinkStyle,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Center(
                      child: Text(
                        "Continue with Social Account",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SocialLoginButtons(
                      onGoogleLogin: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GoogleLoginScreen(),
                          ),
                        ).then((_) {
                          FocusScope.of(context).unfocus();
                          _refreshForm();
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
                          _refreshForm();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
