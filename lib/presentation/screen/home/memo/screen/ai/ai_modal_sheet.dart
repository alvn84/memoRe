import 'package:flutter/material.dart';
import 'package:memore/presentation/screen/home/memo/screen/ai/summary_tab.dart';
import 'package:memore/presentation/screen/home/memo/screen/ai/translate_tab.dart';
import 'package:memore/presentation/screen/home/memo/screen/ai/schedule_tab.dart';
import 'package:memore/presentation/screen/home/memo/screen/ai/place_tab.dart';
import 'package:memore/presentation/screen/home/memo/screen/ai/caption_tab.dart';
import 'ai_repository.dart';

class AiModalSheet extends StatelessWidget {
  final String title;
  final String content;
  final String? folderLocation; // ✅ 추가
  final void Function(String translatedText)? onApplyTranslation;

  const AiModalSheet({
    super.key,
    required this.title,
    required this.content,
    this.folderLocation, // ✅ 추가
    this.onApplyTranslation,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
                  /*Tab(icon: Icon(Icons.calendar_today), text: '일정'),*/
                  Tab(icon: Icon(Icons.place), text: '장소'),
                  Tab(
                    icon: Icon(Icons.tag),
                    child: (Text(
                      '캡션',
                      textAlign: TextAlign.center,
                    )),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8, // ✅ 70% 화면 높이
                child: TabBarView(
                  children: [
                    SummaryTab(title: title, content: content),
                    TranslateTab(
                      title: title,
                      content: content,
                      onApplyTranslation: onApplyTranslation, // ✅ 이 줄 추가
                    ),
                    /*ScheduleTab(title: title, content: content),*/
                    PlaceTab(
                      title: title,
                      content: content,
                      folderLocation: folderLocation, // ✅ 이 줄 추가!
                    ),
                    CaptionTab(title: title, content: content),
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
