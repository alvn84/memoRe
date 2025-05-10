import 'package:flutter/material.dart';
import 'signup_screen.dart';

class SignUpPassword extends StatefulWidget {
  final VoidCallback onNext;
  final SignUpData signUpData; // ✅ 추가

  const SignUpPassword(
      {super.key, required this.onNext, required this.signUpData});

  @override
  State<SignUpPassword> createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  // ✅ 수정
  bool isPasswordValid(String password) {
    // 8자 이상, 영어 + 숫자
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _handleNext(
      BuildContext context,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController) {
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar(context, 'Please fill in all fields.');
      return;
    }

    /*if (!isPasswordValid(password)) {
      _showSnackBar(context,
          'Password must be at least 8 characters long\nand include both letters and numbers.');
      return;
    }*/

    if (password != confirmPassword) {
      _showSnackBar(context, 'Passwords do not match.');
      return;
    }

    // ✅ 입력한 비밀번호를 signUpData에 저장
    widget.signUpData.password = password;
    widget.signUpData.passwordConfirm = password;

    FocusScope.of(context).unfocus();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Set your Password',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25), // ✅ 둥글게
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16), // ✅ 안쪽 여백 추가
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25), // ✅ 둥글게
              ),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16), // ✅ 안쪽 여백 추가
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => _handleNext(
                      context, _passwordController, _confirmPasswordController),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600, // ✨ 버튼 텍스트도 굵게
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
