import 'dart:convert';
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
  DateTime? _selectedDate;
  String _selectedEmoji = '📝'; // 기본 이모지

  @override
  void initState() {
    super.initState();

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
      } catch (_) {
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
    final title = '$_selectedEmoji ${_titleController.text.trim()}';
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
    final summary = plainText.length > 100
        ? '${plainText.substring(0, 100)}...'
        : plainText;

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

  Future<void> _pickEmoji() async {
    final emoji = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        final emojis = ['✈️', '📌', '📅', '🗂', '🏝️'];
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: emojis.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (_, index) {
            return GestureDetector(
              onTap: () => Navigator.pop(context, emojis[index]),
              child: Center(
                child: Text(emojis[index], style: const TextStyle(fontSize: 28)),
              ),
            );
          },
        );
      },
    );

    if (emoji != null) {
      setState(() {
        _selectedEmoji = emoji;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: InkWell(
          onTap: _pickDate,
          child: Text(
            _formattedDate(),
            style: const TextStyle(color: Color(0xFF8B674C)),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFFFBF5),
        elevation: 0,
        leading: const BackButton(color: Color(0xFF8B674C)),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF8B674C)),
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
          // 제목 입력 (배경 및 여백 추가)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _pickEmoji,
                    child: Text(
                      _selectedEmoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(color: Colors.black26),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    ),

          // 본문
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
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

          const Divider(height: 1),

          // 툴바는 하단 고정 (올라가지 않음)
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
                  showListCheck: true,
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
                  showFontSize: false,
                  showHeaderStyle: false,
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
          backgroundColor: const Color(0xFF8B674C),
          child: const Icon(Icons.smart_toy, color: Colors.white),
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}