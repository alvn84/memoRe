import 'package:flutter/material.dart';

class SignUpPassword extends StatelessWidget {
  final VoidCallback onNext;

  const SignUpPassword({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set your Password',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in both fields')),
                  );
                  return;
                }
                if (_passwordController.text != _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                  return;
                }
                onNext(); // 다음 화면으로 이동
              },
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}