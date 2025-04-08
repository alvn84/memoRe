import 'package:flutter/material.dart';
import 'sign_up_email.dart';
import 'sign_up_password.dart';
import 'sign_up_profile.dart';

class SignUpScreen extends StatefulWidget {
  final TabController tabController; // ✅ TabController를 외부에서 받는다!

  const SignUpScreen({super.key, required this.tabController});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToNextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (_currentPage != page) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            children: [
              if (_currentPage > 0) // 첫 번째 페이지(email)에서는 안 보이게
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goToPreviousPage,
                ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // 손가락 스와이프 막기
              children: [
                SignUpEmail(onNext: _goToNextPage),
                SignUpPassword(onNext: _goToNextPage),
                SignUpProfile(onComplete: () {
                  // ✅ 여기서 로그인 탭으로 이동
                  widget.tabController.animateTo(0);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}