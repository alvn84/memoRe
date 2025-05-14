import 'package:flutter/material.dart';
import 'signup_email.dart';
import 'signup_password.dart';
import 'signup_profile.dart';
import '../login/login_screen.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpData {
  String email = '';
  String password = '';
  String passwordConfirm = '';
  String birthDate = '';
  String gender = '';
  String job = '';

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
      'birthDate': birthDate,
      'gender': gender,
      'job': job,
    };
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PageController _pageController = PageController();
  final SignUpData _signUpData = SignUpData(); // ✅ 여기 추가
  int _currentPage = 0;

  Future<void> _submitSignUp() async {
    print('🔥 [디버깅] 회원가입 데이터: ${_signUpData.toJson()}');
    try {
      final url = Uri.parse('http://223.194.135.221:8080/user');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_signUpData.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('회원가입 성공!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()), // ✅ 추가
        );
      } else {
        print('회원가입 실패: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입에 실패했습니다')),
        );
      }
    } catch (e) {
      print('에러 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('네트워크 오류가 발생했습니다')),
      );
    }
  }

  void _goToNextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // 화면 들어올 때 포커스 끊어주기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (_currentPage == 0) {
                    Navigator.pop(context);
                  } else {
                    _goToPreviousPage();
                  }
                },
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SignUpEmail(onNext: _goToNextPage, signUpData: _signUpData),
                  // ✅ 수정
                  SignUpPassword(
                      onNext: _goToNextPage, signUpData: _signUpData),
                  // ✅ 수정
                  SignUpProfile(
                    onComplete: () {
                      _submitSignUp(); // ✅ 서버에 보내기
                    },
                    signUpData: _signUpData,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
