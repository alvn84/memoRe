import 'package:flutter/material.dart';
import '../model/memo_model.dart';
import '../repository/memo_repository.dart';
import 'note_edit_screen.dart';

class MemoScreen extends StatefulWidget {
  final String storagePath;

  const MemoScreen({super.key, required this.storagePath});

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  late Future<List<Memo>> _memoFuture;
  final _repo = MemoRepository();

  @override
  void initState() {
    super.initState();
    _loadMemos();
  }

  void _loadMemos() {
    _memoFuture = _repo.getMemos(widget.storagePath);
  }

  Future<void> _refresh() async {
    setState(() {
      _loadMemos();
    });
  }

  void _navigateToEdit({Memo? memo}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditScreen(
          initialMemo: memo,
          storagePath: widget.storagePath,
          onNoteSaved: _refresh,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메모 목록'),
        backgroundColor: const Color(0xFF8B674C),
      ),
      body: FutureBuilder<List<Memo>>(
        future: _memoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('메모가 없습니다.'));
          }

          final memos = snapshot.data!;

          return ListView.builder(
            itemCount: memos.length,
            itemBuilder: (context, index) {
              final memo = memos[index];
              return ListTile(
                title: Text(memo.title),
                subtitle: Text(
                  memo.content.length > 50
                      ? '${memo.content.substring(0, 50)}...'
                      : memo.content,
                ),
                trailing: Text(memo.storagePath), // 혹은 날짜 정보로 교체 가능
                onTap: () => _navigateToEdit(memo: memo),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8B674C),
        child: const Icon(Icons.add),
        onPressed: () => _navigateToEdit(),
      ),
    );
  }
}
