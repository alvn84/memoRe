// Quill 하단 툴바 담당
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:tuple/tuple.dart';
import 'memo_screen.dart';

class MemoToolbar extends StatelessWidget {
  final QuillController controller;

  const MemoToolbar({super.key, required this.controller});

  // 메모 번역 임시 함수
  void _translateMemo(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAFAFA),
        title: const Text(
          'Translate to Korean',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          '서울에 대하여 서울은 대한민국의 수도이자 정치, 경제, 문화의 중심지입니다. 현대적인 도시 경관과 고궁, 사찰 같은 전통적인 명소가 조화를 이루고 있습니다.한류, 맛집, 활기찬 야경 등으로 세계적인 관광지로 손꼽힙니다.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              // 실제 적용 로직이 들어갈 수 있음
              Navigator.pop(context);
            },
            child: const Text(
              'Apply',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF6495ED),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
              controller: controller,
              sharedConfigurations: const QuillSharedConfigurations(locale: Locale('en')),
              buttonOptions: QuillSimpleToolbarButtonOptions(
                base: QuillToolbarBaseButtonOptions(
                    iconSize: 18,
                    iconTheme: QuillIconTheme(
                      iconButtonSelectedData: IconButtonData(
                        iconSize: 22,
                        color: Colors.white, // 아이콘 색
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color(0xFF6495ED)), // ✅ 너희 테마 색상
                        ),
                      ),
                      iconButtonUnselectedData: IconButtonData(
                        iconSize: 22,
                        color: Colors.black87, // 비선택 아이콘 색
                      ),
                    )
                ),
              ),
              showListCheck: true,
              showListNumbers: true,
              showListBullets: true,
              showSearchButton: true,
              showLink: false,
              showStrikeThrough: false,
              showDividers: false,
              showHeaderStyle: false,
              showBackgroundColorButton: false,
              showInlineCode: false,
              showUndo: false,
              showRedo: false,
              showColorButton: false,
              showItalicButton: false,
              showFontFamily: false,
              showFontSize: false,
              showSubscript: false,
              showSuperscript: false,
              showUnderLineButton: false,
              showCenterAlignment: false,
              showIndent: false,
              showCodeBlock: false,
              showQuote: false,
              showDirection: false,
              showClearFormat: false,
              showClipboardCopy: false,
              showClipboardCut: false,
              showClipboardPaste: false,
            ),
          ),
            // 🔵 번역 버튼
            const SizedBox(width: 1),
            // 🔵 번역 버튼 (아이콘만)
            IconButton(
              onPressed: () => _translateMemo(context),
              icon: const Icon(Icons.translate, color: Colors.black87),
              tooltip: 'Translate',
            ),
            const SizedBox(width: 16),
          ]
        ),
      ),
    );
  }
}