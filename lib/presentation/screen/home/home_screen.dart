import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'tab1/tab1_screen.dart';
import 'tab2/tab2_screen.dart';
import '../sidebar/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 0; // ✅ 현재 페이지 상태 저장

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Memo:Re'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _isSearching
                        ? MediaQuery.of(context).size.width - 64
                        : 0,
                    // 아이콘 포함 고려
                    height: 40,
                    // ✅ 높이 고정
                    curve: Curves.easeInOut,
                    child: Opacity(
                      opacity: _isSearching ? 1 : 0,
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: '검색어를 입력하세요',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(_isSearching ? Icons.close : Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (!_isSearching) {
                        _searchController.clear();
                        FocusScope.of(context).unfocus(); // ✅ 키보드 숨기기
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: 2,
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 12,
              activeDotColor: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 20),
          // 탭 간 구분 선
          // SizedBox(
          //   height: 2,
          //   child: AnimatedBuilder(
          //     animation: _pageController,
          //     builder: (context, child) {
          //       double position =
          //           _pageController.hasClients && _pageController.page != null
          //               ? _pageController.page!
          //               : 0.0;
          //
          //       double alignment = (position * 2) - 1; // -1(왼쪽) ~ 1(오른쪽)
          //
          //       return Align(
          //         alignment: Alignment(alignment, 0),
          //         child: Container(
          //           width: MediaQuery.of(context).size.width / 2,
          //           height: 2,
          //           color: Colors.grey.shade400,
          //         ),
          //       );
          //     },
          //   ),
          // ),
          const SizedBox(height: 8),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
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
