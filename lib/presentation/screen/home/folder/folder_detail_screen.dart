import 'package:flutter/material.dart';
import '../memo/memo_screen.dart';

class FolderDetailScreen extends StatefulWidget {
  final String folderName;

  const FolderDetailScreen({super.key, required this.folderName});

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  List<Map<String, dynamic>> subFolders = [];
  List<String> notes = [];

  void _addSubFolder(String name) {
    setState(() {
      subFolders.add({
        'name': name,
        'color': Colors.green,
        'icon': Icons.folder,
      });
    });
  }

  void _handleNoteSaved(String newNote) {
    setState(() {
      notes.add(newNote);  // 메모 저장
    });
  }

  void _addNewNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(
          onNoteSaved: (noteText) {
            setState(() {
              notes.add(noteText); // 🟢 한 번만 저장됨
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView( // SliverAppBar와 함께 사용하기 위해 CustomScrollView로 감싸기
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0, // 앱바 확장 높이 설정
            floating: false,
            pinned: true, // 스크롤 시에도 앱바가 남아있게 하기
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.folderName),
              centerTitle: false,

            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const Divider(height: 1, thickness: 1), // ✅ 여기 추가!
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: notes.isEmpty
                      ? const Center(child: Text('작성된 메모가 없습니다.'))
                      : GridView.builder(
                    itemCount: notes.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                            notes[index],
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 6,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditScreen(onNoteSaved: _handleNoteSaved),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}