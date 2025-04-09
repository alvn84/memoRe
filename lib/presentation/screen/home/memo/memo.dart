import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteEditScreen extends StatefulWidget {
  final Function(String) onNoteSaved;

  const NoteEditScreen({super.key, required this.onNoteSaved});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _autoSaveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isNotEmpty || content.isNotEmpty) {
      widget.onNoteSaved('$title\n$content');
    }
  }

  @override
  void dispose() {
    _autoSaveNote();
    super.dispose();
  }

  String _formattedDate() {
    final now = DateTime.now();
    return DateFormat('MMM dd EEE').format(now); // 예: Mar 16 Sun
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
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
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  SizedBox(width: 16),
                  Icon(Icons.text_fields, size: 33),
                  SizedBox(width: 32),
                  Icon(Icons.auto_fix_high, size: 33),
                  SizedBox(width: 32),
                  Icon(Icons.check_box_outlined, size: 33),
                  SizedBox(width: 32),
                  Icon(Icons.image_outlined, size: 33),
                  SizedBox(width: 32),
                  Icon(Icons.location_on_outlined, size: 33),
                  SizedBox(width: 32),
                  Icon(Icons.link, size: 33),
                  SizedBox(width: 32),
                  Icon(Icons.alarm, size: 33),
                  SizedBox(width: 32),
                  Icon(Icons.color_lens_outlined, size: 33),
                  SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}