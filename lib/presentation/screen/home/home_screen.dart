import 'package:flutter/material.dart';
import '../sidebar/app_drawer.dart'; // 사이드바 가져오기
import 'tab1/tab1_screen.dart';
import 'tab2/tab2_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
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
      drawer: const AppDrawer(), // ✅ 드로어 등록
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Memo:Re'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu), // 햄버거 아이콘
              onPressed: () {
                Scaffold.of(context).openDrawer(); // ✅ 드로어 열기
              },
            );
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.deepPurple,
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
            ],
          ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Tab1Screen(),
                Tab2Screen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}