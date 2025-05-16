import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../memo/model/memo_model.dart';
import '../memo/repository/memo_repository.dart';
import '../memo/screen/note_edit_screen.dart';

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
  late Future<List<Memo>> _memosFuture;
  final _repo = MemoRepository();
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _loadMemos();

    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 100;
      });
    });
  }

  void _loadMemos() {
    _memosFuture = _repo.getMemos(widget.folderName);
  }

  Future<void> _refresh() async {
    setState(() {
      _loadMemos();
    });
  }

  void _addNewNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditScreen(
          storagePath: widget.folderName,
          onNoteSaved: _refresh,
        ),
      ),
    );
  }

  Future<void> _deleteMemo(String id) async {
    await _repo.deleteMemo(id);
    _refresh();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          FutureBuilder<List<Memo>>(
            future: _memosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(
                    child: Center(child: Text('에러: \${snapshot.error}')));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverToBoxAdapter(
                    child: Center(child: Text('작성된 메모가 없습니다.')));
              }

              final memos = snapshot.data!;

              return SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _isGridView ? 2 : 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: _isGridView ? 1 : 2.5,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final memo = memos[index];
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NoteEditScreen(
                                storagePath: memo.storagePath,
                                initialMemo: memo,
                                onNoteSaved: _refresh,
                              ),
                            ),
                          );
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('메모 삭제'),
                              content: Text('이 메모를 삭제하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    //_deleteMemo(memo.id);
                                  },
                                  child: const Text('삭제',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(memo.title,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 8),
                                Text(memo.content,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14)),
                                const Spacer(),
                                Text(
                                  DateFormat('yyyy.MM.dd')
                                      .format(DateTime.now()),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: memos.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNote,
        backgroundColor: const Color(0xFF8B674C),
        child: const Icon(Icons.add),
      ),
    );
  }
}
