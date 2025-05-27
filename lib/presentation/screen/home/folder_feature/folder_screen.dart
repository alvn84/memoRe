import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../memo/model/memo_model.dart';
import '../memo/repository/memo_repository.dart';
import '../memo/screen/note_edit_screen.dart';
import '../folder_feature/folder_model.dart';

class FolderDetailScreen extends StatefulWidget {
  final Folder folder; // ✅ 폴더 전체 객체로 변경
  final List<Folder> folders;

  const FolderDetailScreen({
    super.key,
    required this.folder,
    required this.folders,
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
    _memosFuture = _repo.getMemos(widget.folder.id!);
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
          folderId: widget.folder.id!,
          onNoteSaved: _refresh,
        ),
      ),
    );
  }

  Future<void> _deleteMemo(int id) async {
    await _repo.deleteMemo(id);
    _refresh();
  }

  void _showMoveMemoDialog(Memo memo) async {
    final foldersExcludingCurrent =
        widget.folders.where((f) => f.id != memo.folderId).toList();

    int? selectedFolderId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('메모 이동'),
          content: DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: '이동할 폴더 선택'),
            items: foldersExcludingCurrent.map((folder) {
              return DropdownMenuItem<int>(
                value: folder.id!,
                child: Text(folder.name),
              );
            }).toList(),
            onChanged: (value) {
              selectedFolderId = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedFolderId != null) {
                  await _repo.moveMemo(memo.id!, selectedFolderId!);
                  Navigator.pop(context);
                  _refresh(); // 이동 후 다시 불러오기
                }
              },
              child: const Text('이동'),
            ),
          ],
        );
      },
    );
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
            backgroundColor: const Color(0xFFFAFAFA),
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
                widget.folder.name,
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
                  widget.folder.imageUrl != null
                      ? Image.file(File(widget.folder.imageUrl!),
                          fit: BoxFit.cover)
                      : Container(color: widget.folder.color), // ✅ 폴더 색상 적용
                  Container(color: Colors.black.withOpacity(0.3)), // 어두운 오버레이
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('AI 여행 가이드'),
                      content: SingleChildScrollView(
                        child: Text(
                          widget.folder.aiGuide?.trim() ?? 'AI 가이드를 불러오지 못했습니다.',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('닫기'),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4F8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.tips_and_updates, size: 18, color: Colors.blueAccent),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'AI 가이드 보기',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    ],
                  ),
                ),
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
                    child: Center(child: Text('에러: ${snapshot.error}')));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverToBoxAdapter(
                    child: Center(child: Text('작성된 메모가 없습니다.')));
              }

              final memos = snapshot.data!;

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _isGridView ? 2 : 1,
                    crossAxisSpacing: 7,
                    mainAxisSpacing: 7,
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
                                folderId: widget.folder.id!,
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
                              title: const Text('메모 옵션'),
                              content: const Text('이 메모에 대해 어떤 작업을 하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteMemo(memo.id!);
                                  },
                                  child: const Text('삭제',
                                      style: TextStyle(color: Colors.red)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _showMoveMemoDialog(
                                        memo); // ✅ 이동 다이얼로그 함수 호출
                                  },
                                  child: const Text('다른 폴더로 이동'),
                                ),
                              ],
                            ),
                          );
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
                                // ✅ 날짜 표시를 가장 위로 이동

                                // 제목 + 별 아이콘
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('MMM d').format(DateTime.parse(memo.updatedAt!)),
                                      style: const TextStyle(fontSize: 18, color: Colors.blueAccent,),
                                    ),
                                    const Spacer(), // 👉 날짜와 별 버튼 사이 여백을 최대한 벌려줌
                                    IconButton(
                                      icon: Icon(
                                        memo.isStarred ? Icons.star : Icons.star_border,
                                        color: memo.isStarred ? Colors.amber : Colors.grey,
                                        size: 20,
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                                      onPressed: () async {
                                        try {
                                          await _repo.toggleStarred(memo.id!);
                                          _refresh();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('즐겨찾기 변경 실패')),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                    memo.title,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),

                                SizedBox(height: 6.5),
                                // 본문 텍스트
                                Expanded(
                                  child: Text(
                                    memo.content,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
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
        backgroundColor: const Color(0xFF6495ED),
        child: const Icon(Icons.add),
      ),
    );
  }
}
