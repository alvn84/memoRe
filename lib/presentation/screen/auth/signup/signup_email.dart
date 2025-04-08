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
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            // ✅ 고쳤다! (자동 키보드 뜨지 않게)
            autocorrect: false,
            textInputAction: TextInputAction.done,
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
                  if (_emailController.text.isNotEmpty) {
                    FocusScope.of(context).unfocus(); // ✅ 키보드 먼저 내리기
                    onNext(); // ✅ 그 다음 페이지 이동
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter your email')),
                    );
                  }
                },
                child: const Text('Continue'),
              )),
        ],
      ),
    );
  }
}
