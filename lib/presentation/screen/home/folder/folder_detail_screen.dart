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
  List<String> noteContents = [];
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  bool _isGridView = true; // ✅ 2열/1열 토글 상태

  @override
  void initState() {
    super.initState();
    _loadNotes();

    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 100;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList(widget.folderName) ?? [];
    final uniqueNotes = notes.toSet().toList();
    setState(() {
      noteContents = uniqueNotes;
    });
    await prefs.setStringList(widget.folderName, uniqueNotes);
  }

  void _addNewNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(
          folderKey: widget.folderName,
          onNoteSaved: (_) => _loadNotes(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFFFFFBF5),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
                icon: Icon(
                  _isGridView ? Icons.view_agenda : Icons.grid_view,
                  color: _isScrolled ? Colors.black : Colors.white,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.folderName,
                style: TextStyle(
                  color: _isScrolled ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: _isScrolled
                      ? []
                      : const [
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: noteContents.isEmpty
                    ? const Center(child: Text('작성된 메모가 없습니다.'))
                    : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: noteContents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _isGridView ? 2 : 1,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: _isGridView ? 1 : 2,
                  ),
                  itemBuilder: (context, index) {
                    final fullNote = noteContents[index];
                    final split = fullNote.split('\n');
                    final title = split.first;
                    final content = split.skip(1).join('\n');
                    final now = DateTime.now();
                    final formattedDate = DateFormat('yyyy.MM.dd').format(now); // 날짜 포맷

                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NoteEditScreen(
                              folderKey: widget.folderName,
                              initialContent: fullNote,
                              noteIndex: index,
                              onNoteSaved: (_) => _loadNotes(),
                            ),
                          ),
                        );
                        _loadNotes();
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                content,
                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),
                              const Spacer(),
                              Text(
                                formattedDate,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
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