import 'dart:convert'; // 🔧 delta 저장/복원용
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
      _titleController.text = title;
      String preview = '';

      try {
        final deltaString = parts.skip(1).join('\n');
        final deltaJson = jsonDecode(deltaString) as List<dynamic>;
        final doc = Document.fromJson(deltaJson); // ✅ Delta.fromJson() 대신
        _controller = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        final content = parts.skip(1).join('\n');
        final doc = Document()..insert(0, content);
        _controller = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
    } else {
      _controller = QuillController.basic();
    }
  }

  DateTime? _selectedDate;

  String _formattedDate() {
    final date = _selectedDate ?? DateTime.now();
    return DateFormat('yyyy.MM.dd').format(date);
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _autoSaveNote();
    super.dispose();
  }

  Future<void> _autoSaveNote() async {
    final title = _titleController.text.trim();
    final deltaJson = _controller.document.toDelta().toJson();
    final fullNote = '$title\n${jsonEncode(deltaJson)}';
    final dateString = DateFormat('yyyy.MM.dd').format(_selectedDate ?? DateTime.now());

    if ((title.isNotEmpty || _controller.document.length > 1) && widget.folderKey != null) {
      final prefs = await SharedPreferences.getInstance();
      final notes = prefs.getStringList(widget.folderKey!) ?? [];
      final modifiedDates = prefs.getStringList('${widget.folderKey!}_modified') ?? [];
      final writtenDates = prefs.getStringList('${widget.folderKey!}_writtenDates') ?? [];

      if (widget.noteIndex != null && widget.noteIndex! < notes.length) {
        notes[widget.noteIndex!] = fullNote;
        modifiedDates[widget.noteIndex!] = DateFormat('yyyy.MM.dd').format(DateTime.now());
        writtenDates[widget.noteIndex!] = dateString;
      } else {
        notes.add(fullNote);
        modifiedDates.add(DateFormat('yyyy.MM.dd').format(DateTime.now()));
        writtenDates.add(dateString);
      }

      await prefs.setStringList(widget.folderKey!, notes);
      await prefs.setStringList('${widget.folderKey!}_modified', modifiedDates);
      await prefs.setStringList('${widget.folderKey!}_writtenDates', writtenDates);
    }

    widget.onNoteSaved(fullNote);
  }

  void _summarizeNoteAI() async {
    final plainText = _controller.document.toPlainText();

    // 예시 요약 (로컬 처리 or 향후 OpenAI 연동)
    final summary = plainText.length > 100
        ? '${plainText.substring(0, 100)}...'
        : plainText;

    // 요약 결과를 Dialog로 표시
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI 요약 결과'),
        content: Text(summary.isNotEmpty ? summary : '요약할 내용이 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
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
        title: InkWell(
          onTap: _pickDate,
          child: Text(
            _formattedDate(),
            style: TextStyle(color: Color(0xFF8B674C)),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Color(0xFF8B674C)),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Color(0xFF8B674C)),
            tooltip: 'Save',
            onPressed: () {
              _autoSaveNote();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 제목 입력
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),
          ),

          // 본문
          Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,

                ),
                child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    controller: _controller,
                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('en')),
                  ),
                ),
              ),
            ),



          // 툴바 (간소화)
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  controller: _controller,
                  sharedConfigurations: const QuillSharedConfigurations(locale: Locale('en')),
                  showBackgroundColorButton: false,
                  showCodeBlock: false,
                  showInlineCode: false,
                  showQuote: false,
                  showDirection: false,
                  showDividers: false,
                  showClearFormat: false,
                  showUndo: true,
                  showRedo: true,
                  showListCheck: true, // ✅ 체크리스트 지원
                  showColorButton: false,
                  showListNumbers: true,
                  showListBullets: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showUnderLineButton: false,
                  showClipboardCopy: false,
                  showClipboardCut: false,
                  showClipboardPaste: false,
                  showCenterAlignment: false,
                  showItalicButton: false,
                  showIndent: false,
                  showFontFamily: false,

                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          onPressed: _summarizeNoteAI,
          backgroundColor: Color(0xFF8B674C),
          child: const Icon(Icons.smart_toy, color: Colors.white),
          shape: const CircleBorder(), // 둥근 테두리 유지
        ),
      ),
    );
  }
}