import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onGoogleLogin;
  final VoidCallback onKakaoLogin;

  const SocialLoginButtons({
    super.key,
    required this.onGoogleLogin,
    required this.onKakaoLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onGoogleLogin,
          icon: SizedBox(
            width: 36,
            height: 36,
            child: Image.asset('assets/icons/google_logo.png'),
          ),
        ),
        const SizedBox(width: 24),
        IconButton(
          onPressed: onKakaoLogin,
          icon: SizedBox(
            width: 42,
            height: 42,
            child: Image.asset('assets/icons/kakao_logo.png'),
          ),
        ),
      ],
    );
  }
}
