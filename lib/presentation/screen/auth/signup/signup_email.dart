import 'package:flutter/material.dart';

class SignUpEmail extends StatefulWidget {
  final VoidCallback onNext;

  const SignUpEmail({super.key, required this.onNext});

  @override
  State<SignUpEmail> createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  late final TextEditingController _emailController;
  late final RegExp emailRegex;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleNext() {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your email',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      );
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid email address',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      );
      return;
    }

    // ✅ 이메일 형식까지 맞으면 통과
    FocusScope.of(context).unfocus();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
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
                onSubmitted: (_) => _handleNext(), // ✨ 여기 추가
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
                      String email = _emailController.text.trim();

                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter your email',
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
                              'Please enter a valid email address',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                        return;
                      }

                      // ✅ 이메일 형식까지 맞으면 통과
                      FocusScope.of(context).unfocus();
                      widget.onNext();
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
