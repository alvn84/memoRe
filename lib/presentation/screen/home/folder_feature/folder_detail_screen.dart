import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_quill/flutter_quill.dart';
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
  bool _isGridView = true;

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

  List<String> writtenDates = [];

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList(widget.folderName) ?? [];
    final uniqueNotes = notes.toSet().toList();
    writtenDates = prefs.getStringList('${widget.folderName}_writtenDates') ?? [];

    // writtenDates가 notes 길이보다 짧을 수 있으므로 보정
    while (writtenDates.length < uniqueNotes.length) {
      writtenDates.add(DateFormat('yyyy.MM.dd').format(DateTime.now()));
    }

    setState(() {
      noteContents = uniqueNotes;
    });

    await prefs.setStringList(widget.folderName, uniqueNotes);
    await prefs.setStringList('${widget.folderName}_writtenDates', writtenDates);
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
            pinned: true,
            backgroundColor: const Color(0xFFFFFBF5),
            actions: [
              IconButton(
                icon: Icon(
                  _isGridView ? Icons.view_agenda : Icons.grid_view,
                  color: _isScrolled ? Colors.black : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
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
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.imagePath != null
                      ? Image.file(File(widget.imagePath!), fit: BoxFit.cover)
                      : Container(color: Color(0xFF8B674C)),
                  Container(color: Colors.black.withOpacity(0.3)),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const Divider(height: 1, thickness: 1),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: noteContents.isEmpty
                    ? const Center(child: Text('작성된 메모가 없습니다.'))
                    : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: noteContents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _isGridView ? 2 : 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: _isGridView ? 1 : 2.5,
                  ),
                  itemBuilder: (context, index) {
                    final fullNote = noteContents[index];
                    final split = fullNote.split('\n');
                    final title = split.first;
                    final deltaString = split.skip(1).join('\n');


                    String preview = '';
                    try {
                      final deltaJson = jsonDecode(deltaString) as List<dynamic>;
                      final doc = Document.fromJson(deltaJson);
                      preview = doc.toPlainText();
                    } catch (_) {
                      preview = deltaString;
                    }

                    final writeDate = (index < writtenDates.length) ? writtenDates[index] : 'Unknown';

                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Color(0xFFFFFBF5),
                            title: const Text('Delete Note', style: TextStyle(fontWeight: FontWeight.bold),),
                            content: const Text('Are you sure you want to delete this note?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel', style: TextStyle(color: Colors.black),),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);

                                  final prefs = await SharedPreferences.getInstance();
                                  final notes = prefs.getStringList(widget.folderName) ?? [];
                                  final modified = prefs.getStringList('${widget.folderName}_modified') ?? [];

                                  if (index < notes.length) {
                                    notes.removeAt(index);
                                    if (index < modified.length) modified.removeAt(index);
                                    await prefs.setStringList(widget.folderName, notes);
                                    await prefs.setStringList('${widget.folderName}_modified', modified);
                                    setState(() {
                                      noteContents = notes;
                                    });
                                  }
                                },
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
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
                                preview,
                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),
                              const Spacer(),
                              Text(
                                writeDate,
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
        backgroundColor: Color(0xFF8B674C),
        onPressed: _addNewNote,
        child: const Icon(Icons.add, color: Color(0xFFFFFBF5)),
      ),
    );
  }
}