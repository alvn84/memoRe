import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'tab1/tab1_screen.dart';
import 'tab2/tab2_screen.dart';
import '../sidebar/app_drawer.dart';

class OfflineScreen extends StatefulWidget {
  const OfflineScreen({super.key});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
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
        backgroundColor: Colors.transparent, // 완전 투명 처리
        elevation: 0,  // 그림자 제거 (없애는게 깔끔)
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu,color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'List',  // 여기에 원하는 텍스트 넣기
          style: TextStyle(
            fontSize: 17,  // 글씨 크기
            fontWeight: FontWeight.bold,
            color: Colors.black87,  // 글씨 색상
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 3),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: 2,
            effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 12,
              activeDotColor: Color(0xFF6495ED),
            ),
          ),
          const SizedBox(height: 15),
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