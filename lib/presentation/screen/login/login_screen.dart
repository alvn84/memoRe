import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'sign_up/sign_up.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 80),
          const Text(
            'Memo:Re',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.deepPurple,
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Sign In'),
              Tab(text: 'Sign Up'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const SignIn(),
                SignUpScreen(tabController: _tabController),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
