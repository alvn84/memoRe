import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'memo_editor.dart';
import 'memo_toolbar.dart';
import 'memo_storage_helper.dart';

class NoteEditScreen extends StatefulWidget {
  final Function(String) onNoteSaved;
  final String? initialContent;
  final int? noteIndex;
  final String? folderKey;
  final String? initialDate;

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

  void _translateMemo() {
    final text = _controller.document.toPlainText();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Translate'),
        content: Text('This would translate:\n\n$text'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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

  bool _isFabExpanded = false;

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

    _selectedDate = widget.initialDate != null
        ? DateFormat('yyyy.MM.dd').parse(widget.initialDate!)
        : DateTime.now();
  }

  String _formattedDate() => DateFormat('yyyy.MM.dd').format(_selectedDate!);

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      await MemoStorageHelper.autoSaveMemo(
        titleController: _titleController,
        controller: _controller,
        folderKey: widget.folderKey,
        memoIndex: widget.noteIndex,
        selectedDate: _selectedDate!,
        onSaved: widget.onNoteSaved,
      );
    }
  }

  @override
  void dispose() {
    MemoStorageHelper.autoSaveMemo(
      titleController: _titleController,
      controller: _controller,
      folderKey: widget.folderKey,
      memoIndex: widget.noteIndex,
      selectedDate: _selectedDate!,
      onSaved: widget.onNoteSaved,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: InkWell(
          onTap: _pickDate,
          child: Text(_formattedDate(), style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo, color: Colors.black87),
            onPressed: () => _controller.undo(),
          ),
          IconButton(
            icon: const Icon(Icons.redo, color: Colors.black87),
            onPressed: () => _controller.redo(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.black26),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(child: MemoEditor(controller: _controller)),
          MemoToolbar(controller: _controller),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 번역 버튼
            AnimatedSlide(
              offset: _isFabExpanded ? Offset.zero : const Offset(0, 0.3),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: _isFabExpanded ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'translate',
                      mini: true,
                      shape: const CircleBorder(),
                      backgroundColor: const Color(0xFF6495ED),
                      onPressed: _translateMemo,
                      child: const Icon(Icons.auto_awesome, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    const Text('Cloud-based AI', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 요약 버튼
            AnimatedSlide(
              offset: _isFabExpanded ? Offset.zero : const Offset(0, 0.3),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: _isFabExpanded ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'summarize',
                      mini: true,
                      shape: const CircleBorder(),
                      backgroundColor: const Color(0xFFFAFAFA),
                      onPressed: _summarizeNoteAI,
                      child: Image.asset(
                        'assets/icons/meta_icon.png',
                        width: 28,
                        height: 28,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('Llama', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 메인 FAB 버튼 (열고 닫는 역할)
            FloatingActionButton(
              heroTag: 'main',
              backgroundColor: _isFabExpanded ? const Color(0xFFFAFAFA) : const Color(0xFF6495ED),
              shape: const CircleBorder(),
              onPressed: () {
                setState(() {
                  _isFabExpanded = !_isFabExpanded;
                });
              },
              child: Icon(
                _isFabExpanded ? Icons.close : Icons.add,
                color: _isFabExpanded ? const Color(0xFF6495ED) : Colors.white,
              ),
            ),
          ],
        ),
      ),

    );
  }
}