import 'package:flutter/material.dart';

import 'tab2_calendar.dart';

class Tab2Screen extends StatefulWidget {
  const Tab2Screen({super.key});

  @override
  State<Tab2Screen> createState() => _Tab2ScreenState();
}

class _Tab2ScreenState extends State<Tab2Screen> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 320,
            flexibleSpace: Container(
              color: Color(0xFFFFFBF5), // 예: 연베이지톤 배경색
              child: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Tab2Calendar(
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 100),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(), // 자연스러운 스크롤
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          1,
                          // ← 백엔드에서 받아올 메모 수에 따라 유동적. 스크롤 기능 테스트용. 숫자 늘리면 텍스트 늘어남.
                          (index) => const Padding(
                            padding: EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              '오늘의 메모가 없습니다.',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
