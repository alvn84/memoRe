import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:memore/presentation/screen/home/memo/screen/llama/llama_modal_sheet.dart';

import '../../../auth/api_config.dart';
import '../../../auth/token_storage.dart';
import '../model/memo_model.dart';
import '../repository/memo_repository.dart';
import 'ai/ai_modal_sheet.dart';
import 'memo_editor.dart';
import 'memo_toolbar.dart';

class NoteEditScreen extends StatefulWidget {
  final Memo? initialMemo;
  final int? folderId; // ✅ folderId로 수정
  final VoidCallback onNoteSaved;
  final bool isQuickMemo; // ← ✅ 이걸 추가
  final String? folderLocation; // ✅ 추가

  const NoteEditScreen({
    super.key,
    this.folderId,
    required this.onNoteSaved,
    this.initialMemo,
    this.isQuickMemo = false, // 기본값은 일반 메모
    this.folderLocation, // ✅ 생성자에 추가
  });

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _editorFocusNode = FocusNode(); // ✅ 추가
  late QuillController _quillController;
  final _repo = MemoRepository();
  late DateTime _selectedDate = DateTime.now();
  File? _selectedImage;
  bool _isFabExpanded = false;

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
  @override
  void dispose() {
    _editorFocusNode.dispose(); // ✅ 누수 방지
    super.dispose();
  }

  Future<void> _insertImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final index = _quillController.selection.baseOffset;
      final length = _quillController.selection.extentOffset - index;
      _quillController.replaceText(
          index, length, BlockEmbed.image(picked.path), null);
    }
  }

  String _formattedDate() => DateFormat('yyyy.MM.dd').format(_selectedDate!);

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
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
      imageUrl: _selectedImage?.path ?? '',
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: InkWell(
          onTap: _pickDate,
          child: Text(_formattedDate(),
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo, color: Colors.black87),
            onPressed: () {
              _quillController.undo();
              FocusScope.of(context).unfocus(); // 🔧 undo 후 키보드 강제 해제
            },
          ),
          IconButton(
            icon: const Icon(Icons.redo, color: Colors.black87),
            onPressed: () => _quillController.redo(),
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
          Expanded(child: MemoEditor(controller: _quillController)),
          MemoToolbar(controller: _quillController),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                      onPressed: () {
                        final title = _titleController.text;
                        final content = _quillController.document.toPlainText();

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent, // 배경 투명하게
                          builder: (context) {
                            return DraggableScrollableSheet(
                              initialChildSize: 0.5,
                              // 시트가 처음 차지하는 화면 비율 (50%)
                              minChildSize: 0.3,
                              maxChildSize: 0.95,
                              // 최대 확장 가능 비율
                              expand: false,
                              builder: (context, scrollController) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    child: AiModalSheet(
                                      key: UniqueKey(),
                                      title: _titleController.text,
                                      content: _quillController.document
                                          .toPlainText(),
                                      folderLocation: widget.folderLocation, // ✅ 전달
                                      onApplyTranslation: (translatedText) {
                                        setState(() {
                                          _quillController = QuillController(
                                            document: Document()
                                              ..insert(0, translatedText),
                                            selection:
                                                const TextSelection.collapsed(
                                                    offset: 0),
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child:
                          const Icon(Icons.auto_awesome, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    const Text('Cloud-based AI',
                        style: TextStyle(fontSize: 12, color: Colors.black87)),
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
                      onPressed: () {
                        final title = _titleController.text;
                        final content = _quillController.document.toPlainText();

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent, // 배경 투명하게
                          builder: (context) {
                            return DraggableScrollableSheet(
                              initialChildSize: 0.5,
                              // 시트가 처음 차지하는 화면 비율 (50%)
                              minChildSize: 0.3,
                              maxChildSize: 0.95,
                              // 최대 확장 가능 비율
                              expand: false,
                              builder: (context, scrollController) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    child: LlamaModalSheet(
                                      key: UniqueKey(),
                                      title: _titleController.text,
                                      content: _quillController.document
                                          .toPlainText(),
                                      folderLocation: widget.folderLocation, // ✅ 전달
                                      onApplyTranslation: (translatedText) {
                                        setState(() {
                                          _quillController = QuillController(
                                            document: Document()
                                              ..insert(0, translatedText),
                                            selection:
                                            const TextSelection.collapsed(
                                                offset: 0),
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Image.asset(
                        'assets/icons/llama1.jpeg',
                        width: 28,
                        height: 28,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('Llama',
                        style: TextStyle(fontSize: 12, color: Colors.black87)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 메인 FAB 버튼 (열고 닫는 역할)
            FloatingActionButton(
              heroTag: 'main',
              backgroundColor: _isFabExpanded
                  ? const Color(0xFFFAFAFA)
                  : const Color(0xFF6495ED),
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
