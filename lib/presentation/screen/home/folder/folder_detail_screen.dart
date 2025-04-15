import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../memo/memo_screen.dart';

class FolderDetailScreen extends StatefulWidget {
  final String folderName;
  final String? imagePath;

  const FolderDetailScreen({
    super.key,
    required this.folderName,
    this.imagePath,
  });

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  List<String> noteTitles = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList(widget.folderName) ?? [];
    final uniqueNotes = notes.toSet().toList(); // 중복 제거
    setState(() {
      noteTitles = uniqueNotes.map((e) => e.split('\n').first).toList();
    });
    await prefs.setStringList(widget.folderName, uniqueNotes); // 중복 제거 후 저장
  }

  void _addNewNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(folderKey: widget.folderName),
      ),
    );
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: Color(0xFF8B674C),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.folderName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              centerTitle: false,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.imagePath != null
                      ? Image.file(
                    File(widget.imagePath!),
                    fit: BoxFit.cover,
                  )
                      : Container(color: const Color(0xFF8B674C)),
                  Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const Divider(height: 1, thickness: 1),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: noteTitles.isEmpty
                    ? const Center(child: Text('작성된 메모가 없습니다.'))
                    : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: noteTitles.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          noteTitles[index],
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF8B674C),
        elevation: 6,
        onPressed: _addNewNote,
        child: const Icon(
          Icons.add,
          color: Color(0xFFFFFBF5),
        ),
      ),
    );
  }
}
