import 'dart:io';
import 'package:intl/intl.dart';
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
  List<String> modifiedDates = [];

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList(widget.folderName) ?? [];
    final uniqueNotes = notes.toSet().toList();
    writtenDates = prefs.getStringList('${widget.folderName}_writtenDates') ?? [];
    modifiedDates = prefs.getStringList('${widget.folderName}_modified') ?? [];

    // writtenDates가 notes 길이보다 짧을 수 있으므로 보정
    while (writtenDates.length < uniqueNotes.length) {
      writtenDates.add(DateFormat('yyyy.MM.dd').format(DateTime.now()));
    }

    while (modifiedDates.length < noteContents.length) {
      modifiedDates.add(DateFormat('yyyy.MM.dd').format(DateTime.now()));
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

  // 정렬 함수
  void _sortNotes(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList(widget.folderName) ?? [];
    final written = prefs.getStringList('${widget.folderName}_writtenDates') ?? [];
    final modified = prefs.getStringList('${widget.folderName}_modified') ?? [];

    List<Map<String, dynamic>> zipped = [];

    for (int i = 0; i < notes.length; i++) {
      zipped.add({
        'note': notes[i],
        'written': i < written.length ? written[i] : '2000.01.01',
        'modified': i < modified.length ? modified[i] : '2000.01.01',
      });
    }

    zipped.sort((a, b) {
      DateTime dateA, dateB;

      if (mode.contains('written')) {
        dateA = DateFormat('yyyy.MM.dd').parse(a['written']);
        dateB = DateFormat('yyyy.MM.dd').parse(b['written']);
      } else {
        dateA = DateFormat('yyyy.MM.dd').parse(a['modified']);
        dateB = DateFormat('yyyy.MM.dd').parse(b['modified']);
      }

      if (mode.endsWith('desc')) {
        return dateB.compareTo(dateA);
      } else {
        return dateA.compareTo(dateB);
      }
    });

    setState(() {
      noteContents = zipped.map((e) => e['note'] as String).toList();
      writtenDates = zipped.map((e) => e['written'] as String).toList();
      // 필요하면 modifiedDates도 저장
    });

    // 저장 (원할 경우)
    await prefs.setStringList(widget.folderName, noteContents);
    await prefs.setStringList('${widget.folderName}_writtenDates', writtenDates);
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
            backgroundColor: const Color(0xFFFAFAFA),
            actions: [
              IconButton(
                icon: Icon(Icons.sort, color: _isScrolled ? Colors.black : Colors.white),
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(1000, 80, 16, 0), // 위치 조정 가능
                    items: [
                      PopupMenuItem(value: 'written-desc', child: Text('날짜 내림차순')),
                      PopupMenuItem(value: 'written-asc', child: Text('날짜 올림차순')),
                      PopupMenuItem(value: 'modified-desc', child: Text('수정일 최신순')),
                      PopupMenuItem(value: 'modified-asc', child: Text('수정일 오래된순')),
                    ],
                  ).then((selected) {
                    if (selected != null) {
                      _sortNotes(selected);
                    }
                  });
                },
              ),
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
                      : Container(color: Color(0xFF6495ED)),
                  Container(color: Colors.black.withOpacity(0.3)),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(top:0, left: 15, right: 15, bottom: 15),
                child: noteContents.isEmpty
                    ? const Center(child: Text('작성된 메모가 없습니다.'))
                    : GridView.builder(
                  padding: EdgeInsets.only(top:12,),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: noteContents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _isGridView ? 2 : 1,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: _isGridView ? 1.1 : 2.6,
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

                    String formattedDate = writeDate;
                    try {
                      final parsedDate = DateFormat('yyyy.MM.dd').parse(writeDate);
                      formattedDate = DateFormat('MMM d', 'en_US').format(parsedDate); // "May 28"
                    } catch (_) {}

                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Color(0xFFFAFAFA),
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
                              folderKey: widget.folderName,           // 폴더 이름 그대로 전달
                              initialContent: noteContents[index],     // 전체 note 문자열 전달
                              noteIndex: index,                        // 수정 시 사용할 인덱스
                              onNoteSaved: (_) => _loadNotes(),        // 저장 후 리로드
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
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formattedDate,
                                  style: const TextStyle(fontSize: 18, color: Color(0xFF6495ED), fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  preview,
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
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
        backgroundColor: Color(0xFF6495ED),
        onPressed: _addNewNote,
        child: const Icon(Icons.add, color: Color(0xFFFAFAFA)),
      ),
    );
  }
}