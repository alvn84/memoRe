import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class NoteEditScreen extends StatefulWidget {
  final Function(String) onNoteSaved;
  final String? initialContent;
  final int? noteIndex;
  final String? folderKey;

  const NoteEditScreen({
    super.key,
    required this.onNoteSaved,
    this.initialContent,
    this.noteIndex,
    this.folderKey,
  });

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late QuillController _controller;
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialContent != null) {
      final parts = widget.initialContent!.split('\n');
      final title = parts.first;
      final content = parts.skip(1).join('\n');
      _titleController.text = title;
      final doc = Document()..insert(0, content);
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _controller = QuillController.basic();
    }
  }

  @override
  void dispose() {
    _autoSaveNote();
    super.dispose();
  }

  String _formattedDate() {
    final now = DateTime.now();
    return DateFormat('MMM dd EEE').format(now);
  }

  void _autoSaveNote() async {
    final title = _titleController.text.trim();
    final content = _controller.document.toPlainText().trim();
    final fullNote = '$title\n$content';

    if ((title.isNotEmpty || content.isNotEmpty) && widget.folderKey != null) {
      final prefs = await SharedPreferences.getInstance();
      final notes = prefs.getStringList(widget.folderKey!) ?? [];

      if (widget.noteIndex != null && widget.noteIndex! < notes.length) {
        notes[widget.noteIndex!] = fullNote;
      } else {
        notes.add(fullNote);
      }

      await prefs.setStringList(widget.folderKey!, notes);
    }

    widget.onNoteSaved(fullNote);
  }

  void _runAISummary() {
    final plainText = _controller.document.toPlainText();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('AI 요약'),
        content: Text('🧠 요약 (예시):\n\n${plainText.substring(0, plainText.length > 100 ? 100 : plainText.length)}...'),
        actions: [
          TextButton(
            child: const Text('닫기'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        title: Text(_formattedDate()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.bolt),
            tooltip: 'AI 요약',
            onPressed: _runAISummary,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: '저장',
            onPressed: () {
              _autoSaveNote();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          // 제목 입력
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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

          // 본문 에디터
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    controller: _controller,
                    sharedConfigurations: const QuillSharedConfigurations(
                      locale: Locale('ko'),
                    ),
                  ),
                  // readOnly: false,
                ),
              ),
            ),
          ),

          // 하단 툴바
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: _controller,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('ko'),
                ),
                showAlignmentButtons: false,
                showBackgroundColorButton: false,
                showCodeBlock: false,
                showDividers: false,
                showDirection: false,
                showInlineCode: false,
                showQuote: false,
                showSearchButton: false,
                showRedo: false,
                showUndo: false,
                showClearFormat: false,
                showLeftAlignment: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}