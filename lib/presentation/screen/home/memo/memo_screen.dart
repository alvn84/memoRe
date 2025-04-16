import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:super_editor/super_editor.dart';

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
  late MutableDocument _document;
  late DocumentEditor _editor;
  late DocumentComposer _composer;

  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final parts = widget.initialContent?.split('\n') ?? [];
    final title = parts.isNotEmpty ? parts.first : '';
    final content = parts.length > 1 ? parts.sublist(1).join('\n') : '';

    _titleController.text = title;

    _document = MutableDocument(
      nodes: [
        ParagraphNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText(content),
        ),
      ],
    );

    _editor = DocumentEditor(document: _document);
    _composer = DocumentComposer();
  }

  void _autoSaveNote() async {
    final title = _titleController.text.trim();
    final content = _document.nodes
        .whereType<ParagraphNode>()
        .map((node) => node.text.text)
        .join('\n')
        .trim();
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

  String _formattedDate() {
    final now = DateTime.now();
    return DateFormat('MMM dd EEE').format(now);
  }

  @override
  void dispose() {
    _autoSaveNote();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
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
              padding: const EdgeInsets.all(12.0),
              child: SuperEditor(
                editor: _editor,
                composer: _composer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}