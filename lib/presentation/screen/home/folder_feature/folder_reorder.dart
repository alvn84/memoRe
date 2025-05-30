// - - - - - - - - - - - - - - - 폴더 배치 재정렬 - - - - - - - - - - - - - - -
import 'package:flutter/material.dart';

import 'folder_model.dart';

class FolderReorder extends StatefulWidget {
  final List<Folder> folders;
  final Function(List<Folder>) onReorder;

  const FolderReorder({
    super.key,
    required this.folders,
    required this.onReorder,
  });

  @override
  State<FolderReorder> createState() => _FolderReorderState();
}

class _FolderReorderState extends State<FolderReorder> {
  late List<Folder> _folders;

  @override
  void initState() {
    super.initState();
    _folders = List.from(widget.folders); // 복사본
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Reorder Folders',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: ReorderableListView.builder(
        itemCount: _folders.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) newIndex -= 1;
            final folder = _folders.removeAt(oldIndex);
            _folders.insert(newIndex, folder);
          });
        },
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final folder = _folders[index];
          return ListTile(
            key: ValueKey(folder.name),
            leading: Icon(Icons.flight_takeoff, color: folder.color),
            title: Text(folder.name),
            trailing: const Icon(Icons.drag_handle),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF6495ED),
        onPressed: () {
          widget.onReorder(_folders); // 변경사항 반영
          Navigator.pop(context);
        },
        child: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}
