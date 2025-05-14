// 리팩토링된 note_edit_screen.dart (MemoRepository 사용 기반)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:intl/intl.dart';
import '../repository/memo_repository.dart';
import '../model/memo.dart';

class NoteEditScreen extends StatefulWidget {
  final Memo? initialMemo;
  final int? noteIndex;
  final String folderKey;
  final VoidCallback onNoteSaved;

  const NoteEditScreen({
    super.key,
    required this.folderKey,
    required this.onNoteSaved,
    this.initialMemo,
    this.noteIndex,
  });

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late QuillController _controller;
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDate;
  final _repo = MemoRepository();

  @override
  void initState() {
    super.initState();
    if (widget.initialMemo != null) {
      _titleController.text = widget.initialMemo!.title;
      _selectedDate = DateFormat('yyyy.MM.dd').parse(widget.initialMemo!.writtenDate);

      try {
        final deltaJson = jsonDecode(widget.initialMemo!.contentJson);
        final doc = Document.fromJson(deltaJson);
        _controller = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (_) {
        _controller = QuillController.basic();
      }
    } else {
      _controller = QuillController.basic();
      _selectedDate = DateTime.now();
    }
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

  Future<void> _saveMemo() async {
    final title = _titleController.text.trim();
    final deltaJson = jsonEncode(_controller.document.toDelta().toJson());
    final now = DateFormat('yyyy.MM.dd').format(DateTime.now());
    final written = DateFormat('yyyy.MM.dd').format(_selectedDate ?? DateTime.now());

    if (title.isEmpty && _controller.document.length <= 1) return;

    final memo = Memo(
      title: title,
      contentJson: deltaJson,
      writtenDate: written,
      modifiedDate: now,
    );

    await _repo.saveMemo(widget.folderKey, memo, index: widget.noteIndex);
    widget.onNoteSaved();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        title: InkWell(
          onTap: _pickDate,
          child: Text(
            DateFormat('yyyy.MM.dd').format(_selectedDate ?? DateTime.now()),
            style: const TextStyle(color: Color(0xFF8B674C)),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF8B674C)),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF8B674C)),
            onPressed: _saveMemo,
          ),
        ],
      ),
      body: Column(
        children: [
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
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  controller: _controller,
                  sharedConfigurations:
                  const QuillSharedConfigurations(locale: Locale('en')),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  controller: _controller,
                  sharedConfigurations:
                  const QuillSharedConfigurations(locale: Locale('en')),
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}