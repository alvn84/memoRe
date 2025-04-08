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
          const Text(
            'Enter your Email',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // 나중에 이메일 검증 추가 가능
                if (_emailController.text.isNotEmpty) {
                  onNext(); // 다음 화면으로 이동
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter your email')),
                  );
                }
              },
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}