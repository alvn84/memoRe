import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../model/memo_model.dart';
import '../repository/memo_repository.dart';

class NoteEditScreen extends StatefulWidget {
  final Memo? initialMemo;
  final String storagePath;
  final VoidCallback onNoteSaved;

  const NoteEditScreen({
    super.key,
    required this.storagePath,
    required this.onNoteSaved,
    this.initialMemo,
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
      title: title,
      content: plainText,
      imageUrl: '', // 이미지 기능은 나중에
      storagePath: widget.storagePath,
    );

    try {
      await _repo.saveMemo(memo); // 서버 저장 로직
      widget.onNoteSaved(); // 목록 갱신 콜백
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('메모 저장 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        title: const Text('메모 작성'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF8B674C)),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF8B674C)),
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
    );
  }
}
