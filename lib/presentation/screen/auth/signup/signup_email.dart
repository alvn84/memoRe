import 'package:flutter/material.dart';

class SignUpEmail extends StatelessWidget {
  final VoidCallback onNext;

  const SignUpEmail({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Enter your Email',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Center(
            child: SizedBox(
              width: 290,
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                // ✅ 고쳤다! (자동 키보드 뜨지 않게)
                autocorrect: false,
                textInputAction: TextInputAction.done,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25), // ✨ 둥글기 추가
                  ),
                ),
              ),
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
                      if (_emailController.text.isNotEmpty) {
                        FocusScope.of(context).unfocus(); // ✅ 키보드 먼저 내리기
                        onNext(); // ✅ 그 다음 페이지 이동
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Please enter your email',
                              style: TextStyle(
                                fontSize: 14, // ✨ 폰트 크기도 조금 정리
                                fontWeight: FontWeight.w600, // ✨ 굵기 추가
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600, // ✨ 버튼 글자 굵게
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
