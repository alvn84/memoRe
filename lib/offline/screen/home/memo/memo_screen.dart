import 'dart:convert'; // 🔧 delta 저장/복원용
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class NoteEditScreen extends StatefulWidget {
  // 메모 저장 콜백, 기존 내용, 메모 인덱스, 폴더 키
  final Function(String) onNoteSaved;
  final String? initialContent;
  final int? noteIndex;
  final String? folderKey;
  final String? initialDate; // 예: '2025.05.20'

  const NoteEditScreen({
    super.key,
    required this.onNoteSaved,
    this.initialContent,
    this.noteIndex,
    this.folderKey,
    this.initialDate,
  });

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late QuillController _controller;
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    // ✅ 기존 메모 로딩 또는 새 문서 생성
    if (widget.initialContent != null) {
      final parts = widget.initialContent!.split('\n');
      final title = parts.first;
      _titleController.text = title;

      try {
        final deltaString = parts.skip(1).join('\n');
        final deltaJson = jsonDecode(deltaString) as List<dynamic>;
        final doc = Document.fromJson(deltaJson);
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
    if (widget.initialDate != null) {
      _selectedDate = DateFormat('yyyy.MM.dd').parse(widget.initialDate!);
    } else {
      _selectedDate = DateTime.now();
    }
  }

  // ✅ 선택된 날짜를 "yyyy.MM.dd" 형식으로 반환
  String _formattedDate() {
    final date = _selectedDate ?? DateTime.now();
    return DateFormat('yyyy.MM.dd').format(date);
  }

  // ✅ 날짜 선택 다이얼로그 열기
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
    await _autoSaveNote();
    print('선택된 날짜: $_selectedDate');
  }

  @override
  void dispose() {
    _autoSaveNote(); // ✅ 화면 닫을 때 자동 저장
    super.dispose();
  }

  // ✅ 메모 자동 저장 함수 (SharedPreferences에 저장)
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
        // 수정 모드: 인덱스에 덮어쓰기
        notes[widget.noteIndex!] = fullNote;
        modifiedDates[widget.noteIndex!] = DateFormat('yyyy.MM.dd').format(DateTime.now());
        writtenDates[widget.noteIndex!] = dateString;
      } else {
        // 새 메모 추가
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


  // ✅ 메모 내용을 요약해서 다이얼로그로 보여주는 기능 (AI 요약 자리)
  void _summarizeNoteAI() async {
    final plainText = _controller.document.toPlainText();
    final summary = plainText.length > 100
        ? '${plainText.substring(0, 100)}...'
        : plainText;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFAFAFA),
        title: const Text('AI Summary', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('New York City, also known as “The Big Apple,” is a vibrant global hub for finance, arts, and culture. \n\nFamous for landmarks like the Statue of Liberty, Times Square, and Central Park, it consists of five boroughs: Manhattan, Brooklyn, Queens, The Bronx, and Staten Island. \n\nKnown for its diversity, energy, and iconic attractions, NYC is often called “the city that never sleeps.”'),
        //Text(summary.isNotEmpty ? summary : 'No content to summarize.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Add to Memo',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6495ED)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Confirm', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ 상단 앱바 - 날짜 선택 및 저장, Undo/Redo
      appBar: AppBar(
        title: InkWell(
          onTap: _pickDate,
          child: Text(
            _formattedDate(),
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo, color: Colors.black87),
            tooltip: 'Undo',
            onPressed: () => _controller.undo(),
          ),
          IconButton(
            icon: const Icon(Icons.redo, color: Colors.black87),
            tooltip: 'Redo',
            onPressed: () => _controller.redo(),
          ),
          /* IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF6495ED)),
            tooltip: 'Save',
            onPressed: () {
              _autoSaveNote();
              Navigator.pop(context);
            },
          ), */
        ],
      ),

      // ✅ 본문 UI 구성
      body: Column(
        children: [
          // 제목 입력란
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.black26,),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // 본문 에디터
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
          ),

          // 하단 툴바
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  buttonOptions: QuillSimpleToolbarButtonOptions(
                    base: QuillToolbarBaseButtonOptions(
                      iconSize: 18,
                    )
                  ),
                  controller: _controller,
                  sharedConfigurations: const QuillSharedConfigurations(locale: Locale('en')),
                  showListCheck: true,
                  showListNumbers: true,
                  showSearchButton: true,
                  showListBullets: true,
                  // 나머지 버튼은 다 숨김
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
            ),
          ),
        ],
      ),

      // ✅ 우측 하단 요약 버튼 (AI)
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          onPressed: _summarizeNoteAI,
          backgroundColor: const Color(0xFFFAFAFA),
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