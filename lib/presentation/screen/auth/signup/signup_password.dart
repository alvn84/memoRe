import 'package:flutter/material.dart';

class SignUpPassword extends StatelessWidget {
  final VoidCallback onNext;

  const SignUpPassword({super.key, required this.onNext});

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
                  onPressed: () {
                    if (_passwordController.text.isEmpty ||
                        _confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill in all fields',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                      return;
                    }

                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Passwords do not match',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                      return;
                    }

                    FocusScope.of(context).unfocus(); // ✅ 먼저 키보드 내리기
                    onNext(); // ✅ 그 다음에 다음 페이지 이동
                  },
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
