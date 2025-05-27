// Quill 하단 툴바 담당
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../repository/memo_repository.dart';
import 'memo_screen.dart';
import 'ai/ai_repository.dart';

class MemoToolbar extends StatelessWidget {
  final QuillController controller;

  const MemoToolbar({super.key, required this.controller});

  // 메모 번역 임시 함수
  void _translateMemo(BuildContext context) async {
    final plainText = controller.document.toPlainText(); // Quill 텍스트 가져오기
    final result = await translateText(plainText, 'en'); // 실제 번역 실행

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAFAFA),
        title: const Text(
          'Translate to English',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          result.isNotEmpty ? result : '번역 결과 없음',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              // 번역 결과를 에디터에 추가하는 로직 등 추가 가능
              Navigator.pop(context);
            },
            child: const Text(
              '적용',
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
            /*IconButton(
              onPressed: () => _translateMemo(context),
              icon: const Icon(Icons.translate, color: Colors.black87),
              tooltip: 'Translate',
            ),
            const SizedBox(width: 16),*/
          ]
        ),
      ),
    );
  }
}