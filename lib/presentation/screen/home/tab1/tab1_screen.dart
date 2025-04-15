import 'package:flutter/material.dart';
import 'folder_model.dart';
import 'folder_storage.dart';
import 'add_folder_dialog.dart';
import '../folder/folder_detail_screen.dart';

class Tab1Screen extends StatefulWidget {
  const Tab1Screen({super.key});

  @override
  State<Tab1Screen> createState() => _Tab1ScreenState();
}

class _Tab1ScreenState extends State<Tab1Screen> {
  List<Folder> folders = [];
  String _searchQuery = '';
  bool _isFabExpanded = false;
  final FocusNode _searchFocusNode = FocusNode();  // FocusNode 추가

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    folders = await FolderStorage.loadFolders();
    setState(() {});
  }

  Future<void> _saveFolders() async {
    await FolderStorage.saveFolders(folders);
  }

  Future<void> _addNewFolder() async {
    final folderName = await showAddFolderDialog(context);
    if (folderName != null && folderName.isNotEmpty) {
      setState(() {
        folders.add(
          Folder(
            name: folderName,
            color: Color(0xFF8B674C),
            icon: Icons.folder,
          ),
        );
      });
      _saveFolders();
    }
  }

  void _deleteFolder(int index) {
    setState(() {
      folders.removeAt(index);
    });
    _saveFolders();
  }

  void _toggleStar(int index) {
    setState(() {
      folders[index] = Folder(
        name: folders[index].name,
        color: folders[index].color,
        icon: folders[index].icon,
        isStarred: !folders[index].isStarred,
      );
    });
    _saveFolders();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFolders = folders
        .where((folder) =>
        folder.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();  // 키보드 완전 해제
        setState(() {
          _isFabExpanded = false;    // FAB 닫기
        });
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: SizedBox(
            height: 40,
            child: TextField(
              focusNode: _searchFocusNode,  // FocusNode 연결
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: '검색',
                hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.black12, // unfocused 시 색상
                    width: 0.5,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF8B674C),
                    width: 1.2,
                  ),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.sort, color: Color(0xFF8B674C)),
              onPressed: () {
                setState(() {
                  final defaultFolder = folders
                      .firstWhere((folder) => folder.name == 'Default');
                  final userFolders = folders
                      .where((folder) => folder.name != 'Default')
                      .toList();
                  userFolders.sort((a, b) => a.name.compareTo(b.name));
                  folders = [defaultFolder, ...userFolders];
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: filteredFolders.isEmpty
              ? const Center(child: Text('검색 결과 없음'))
              : GridView.builder(
            itemCount: filteredFolders.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final folder = filteredFolders[index];
              final originalIndex = folders.indexOf(folder);
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FolderDetailScreen(folderName: folder.name),
                    ),
                  );
                },
                onLongPress: () {
                  if (folder.name == 'Default') return;
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(folder.isStarred
                              ? Icons.star
                              : Icons.star_border),
                          title: Text(folder.isStarred
                              ? '즐겨찾기 해제'
                              : '즐겨찾기 추가'),
                          onTap: () {
                            Navigator.pop(context);
                            _toggleStar(originalIndex);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('삭제'),
                          onTap: () {
                            Navigator.pop(context);
                            _deleteFolder(originalIndex);
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Icon(folder.icon,
                            color: folder.color, size: 50),
                        if (folder.isStarred)
                          const Icon(Icons.star,
                              color: Colors.amber, size: 20),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      folder.name,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSlide(
              offset: _isFabExpanded
                  ? const Offset(0, 0)
                  : const Offset(0, 0.3),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: _isFabExpanded ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: FloatingActionButton(
                  heroTag: 'addFolder',
                  mini: true,
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xFFFFFBF5),
                  onPressed: () {
                    setState(() {
                      _isFabExpanded = false;
                    });
                    _addNewFolder();
                  },
                  child: const Icon(Icons.create_new_folder,
                      color: Color(0xFF8B674C)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              backgroundColor: const Color(0xFF8B674C),
              shape: const CircleBorder(),
              onPressed: () {
                setState(() {
                  _isFabExpanded = !_isFabExpanded;
                });
              },
              child: Icon(
                _isFabExpanded ? Icons.note_add : Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}