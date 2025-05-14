// 리팩토링된 memo_screen.dart 예시 (repository 사용 기반)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../repository/memo_repository.dart';
import '../model/memo.dart';
import 'note_edit_screen.dart';

class MemoScreen extends StatefulWidget {
  final String folderKey;

  const MemoScreen({super.key, required this.folderKey});

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  late Future<List<Memo>> _memoFuture;
  final _repo = MemoRepository();

  @override
  void initState() {
    super.initState();
    _memoFuture = _repo.getMemos(widget.folderKey);
  }

  void _refresh() {
    setState(() {
      _memoFuture = _repo.getMemos(widget.folderKey);
    });
  }

  void _navigateToEdit({Memo? existingMemo, int? index}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditScreen(
          folderKey: widget.folderKey,
          noteIndex: index,
          initialMemo: existingMemo,
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
                subtitle: Text('작성일: ${memo.writtenDate}\n수정일: ${memo.modifiedDate}'),
                isThreeLine: true,
                onTap: () => _navigateToEdit(existingMemo: memo, index: index),
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
