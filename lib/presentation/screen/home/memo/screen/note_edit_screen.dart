import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../../auth/token_storage.dart';
import '../model/memo_model.dart';
import '../repository/memo_repository.dart';
import '../../../auth/api_config.dart';
import '../../../auth/token_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import '';

class NoteEditScreen extends StatefulWidget {
  final Memo? initialMemo;
  final int? folderId; // ✅ folderId로 수정
  final VoidCallback onNoteSaved;
  final bool isQuickMemo; // ← ✅ 이걸 추가

  const NoteEditScreen({
    super.key,
    this.folderId,
    required this.onNoteSaved,
    this.initialMemo,
    this.isQuickMemo = false, // 기본값은 일반 메모
  });

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  late QuillController _quillController;
  final _repo = MemoRepository();

  @override
  void initState() {
    super.initState();

    if (widget.initialMemo != null) {
      _titleController.text = widget.initialMemo!.title;
      _quillController = QuillController(
        document: Document()..insert(0, widget.initialMemo!.content),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _quillController = QuillController.basic();
    }
  }

  Future<void> saveMemo() async {
    final title = _titleController.text.trim();
    final plainText = _quillController.document.toPlainText().trim();

    if (title.isEmpty && plainText.isEmpty) return;

    final memo = Memo(
      id: widget.initialMemo?.id,
      title: title,
      content: plainText,
      imageUrl: '',
      folderId: widget.folderId, // 퀵메모면 서버가 무시함
    );

    try {
      if (widget.initialMemo != null) {
        // ✅ 수정
        await _repo.updateMemo(memo);
      } else {
        // ✅ 새 메모: 일반 / 퀵메모 분기
        if (widget.isQuickMemo) {
          await _repo.saveQuickMemo(memo);
        } else {
          await _repo.saveMemo(memo);
        }
      }

      widget.onNoteSaved();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('메모 저장 실패')),
      );
    }
  }

  Future<String> summarizeText(String title, String content) async {
    final combined = '$title\n$content';
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/api/summarize'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'text': combined}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['summary'] ?? '요약 결과 없음';
    } else {
      return '요약 실패: ${response.statusCode}';
    }
  }

  Future<String> previewMemoText(String title, String content) async {
    return content;
  }

  static const MethodChannel _channel = MethodChannel('genie_channel');

  static Future<String> runGenie(String prompt) async {
    try {
      final String result =
          await _channel.invokeMethod('runGenie', {'prompt': prompt});
      return result;
    } on PlatformException catch (e) {
      return 'Genie 실행 오류: ${e.message}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('메모 작성'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF6495ED)),
        actions: [
          // ✅ 새로 추가한 버튼 (예: 별 버튼)
          IconButton(
              icon: const Icon(Icons.translate, color: Color(0xFF6495ED)),
              onPressed: () async {
                final title = _titleController.text;
                final body = _quillController.document.toPlainText();
                final combined = '$body';

                final translated =
                    await translateText(combined, 'en'); // 영어로 번역

                if (!context.mounted) return;

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('번역 결과'),
                    content: Text(translated),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('닫기'),
                      ),
                    ],
                  ),
                );
              }),
          IconButton(
            icon: Image.asset(
              'assets/icons/ai_summary.png',
              width: 33,
              height: 35,
            ),
            onPressed: () async {
              // 그대로 출력
              final preview = await previewMemoText(
                _titleController.text,
                _quillController.document.toPlainText(),
              );
              if (!context.mounted) return;

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('요약 결과'),
                  content: Text(preview),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('닫기'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF6495ED)),
            onPressed: saveMemo,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: '제목을 입력하세요',
                border: InputBorder.none,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  controller: _quillController,
                  sharedConfigurations:
                      const QuillSharedConfigurations(locale: Locale('ko')),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          onPressed: () async {
            final preview = await previewMemoText(
              _titleController.text,
              _quillController.document.toPlainText(),
            );

            if (!context.mounted) return;

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('미리보기'),
                content: Text(preview),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('닫기'),
                  ),
                ],
              ),
            );
          },
          shape: const CircleBorder(),
          child: Image.asset(
            'assets/icons/meta_icon.png',
            width: 28,
            height: 28,
          ),
        ),
      ),
    );
  }
}
