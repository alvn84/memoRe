import 'package:flutter/material.dart';

class AiModalSheet extends StatelessWidget {
  const AiModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TabBar(
                labelColor: Color(0xFF6495ED),
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(icon: Icon(Icons.summarize), text: '요약'),
                  Tab(icon: Icon(Icons.translate), text: '번역'),
                  Tab(icon: Icon(Icons.calendar_today), text: '일정'),
                  Tab(
                    icon: Icon(Icons.tag),
                    child: (Text(
                      '캡션',
                      textAlign: TextAlign.center,
                    )),
                  ),
                  Tab(icon: Icon(Icons.place), text: '장소'), // ← 추가
                ],
              ),
              SizedBox(
                height: 300, // 적당한 높이 설정
                child: const TabBarView(
                  children: [
                    Center(child: Text('📝 요약 탭')),
                    Center(child: Text('🌐 번역 탭')),
                    Center(child: Text('📅 일정 탭')),
                    Center(child: Text('🏷️ 캡션/해시태그 탭')),
                    Center(child: Text('📍️ 장소')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
