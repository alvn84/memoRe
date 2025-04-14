import 'package:flutter/material.dart';
import 'folder_model.dart';
import 'folder_storage.dart';
import 'add_folder_dialog.dart';
import '../folder/folder_detail_screen.dart'; // 기존 폴더 디테일 화면

class Tab1Screen extends StatefulWidget {
  const Tab1Screen({super.key});

  @override
  State<Tab1Screen> createState() => _Tab1ScreenState();
}

class _Tab1ScreenState extends State<Tab1Screen> {
  List<Folder> folders = [];
  String _searchQuery = '';

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
            color: Colors.deepPurpleAccent,
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

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: const InputDecoration(
            hintText: '검색',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              setState(() {
                // 1. Default 폴더 분리
                final defaultFolder =
                    folders.firstWhere((folder) => folder.name == 'Default');
                final userFolders = folders
                    .where((folder) => folder.name != 'Default')
                    .toList();

                // 2. 사용자 폴더만 정렬
                userFolders.sort((a, b) => a.name.compareTo(b.name));

                // 3. 다시 합치기 (Default 맨 앞)
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.8,
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
                      if (folder.name == 'Default') return; // ⭐️ Default는 막기
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(folder.isStarred
                                  ? Icons.star
                                  : Icons.star_border),
                              title: Text(
                                  folder.isStarred ? '즐겨찾기 해제' : '즐겨찾기 추가'),
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
                            Icon(folder.icon, color: folder.color, size: 65),
                            if (folder.isStarred)
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 20),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          folder.name,
                          style: const TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _addNewFolder, // 폴더 추가 함수
                icon: const Icon(Icons.create_new_folder, color: Color(0xFF8B674C)),
                iconSize: 35,
                tooltip: '새 폴더 만들기',
              ),
              IconButton(
                onPressed: () {
                  // TODO: 새 메모 만들기 동작 (추가하고 싶으면 이 함수 지정)
                },
                icon: const Icon(Icons.note_add, color: Color(0xFF8B674C)),
                iconSize: 35,
                tooltip: '새 메모 만들기',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
