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
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 제목 + 별 아이콘 가로 배치
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            memo.title,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Transform.translate(
                                          // 별 버튼 위치 조정
                                          offset: const Offset(10, -10),
                                          child: IconButton(
                                            icon: Icon(
                                              memo.isStarred
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: memo.isStarred
                                                  ? Colors.amber
                                                  : Colors.grey,
                                              size: 22,
                                            ),
                                            padding: EdgeInsets.zero,
                                            // 여백 최소화
                                            constraints: const BoxConstraints(),
                                            // 공간 최소화
                                            onPressed: () async {
                                              try {
                                                await _repo
                                                    .toggleStarred(memo.id!);
                                                _refresh(); // UI 갱신
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content:
                                                          Text('즐겨찾기 변경 실패')),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // 본문 텍스트
                                    Expanded(
                                      child: Text(
                                        memo.content,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    // 날짜 고정 위한 아래 공간 확보
                                  ],
                                ),
                              ),
                              // ✅ 날짜를 카드 맨 아래에 고정
                              Positioned(
                                bottom: 8,
                                left: 12,
                                child: Text(
                                  memo.updatedAt != null
                                      ? DateFormat('yyyy.MM.dd').format(
                                          DateTime.parse(memo.updatedAt!))
                                      : '날짜 없음',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            ],
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
