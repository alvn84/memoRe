import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class NoteEditScreen extends StatefulWidget {
  final Function(String) onNoteSaved;
  final String? initialContent; // ✅ 새로 추가
  final int? noteIndex;         // ✅ 새로 추가
  final String? folderKey;      // ✅ 메모 저장을 위해 폴더 이름

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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String _formattedDate() {
    final now = DateTime.now();
    return DateFormat('MMM dd EEE').format(now);
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialContent != null) {
      final lines = widget.initialContent!.split('\n');
      _titleController.text = lines.first;
      _contentController.text = lines.skip(1).join('\n');
    }
  }

  @override
  void dispose() {
    _autoSaveNote();
    super.dispose();
  }

  void _autoSaveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final fullText = '$title\n$content';

    if ((title.isNotEmpty || content.isNotEmpty) && widget.folderKey != null) {
      final prefs = await SharedPreferences.getInstance();
      final existing = prefs.getStringList(widget.folderKey!) ?? [];

      if (widget.noteIndex != null && widget.noteIndex! < existing.length) {
        existing[widget.noteIndex!] = fullText; // ✅ 덮어쓰기
      } else {
        existing.add(fullText); // 새로 추가
      }

      await prefs.setStringList(widget.folderKey!, existing);
    }

    widget.onNoteSaved('$title\n$content');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.transparent,
        title: Text(_formattedDate()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _autoSaveNote();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: TextField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: '내용을 입력하세요...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}