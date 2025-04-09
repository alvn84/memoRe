import 'package:flutter/material.dart';
import '../folder/folder_detail.dart';

class Tab1Screen extends StatefulWidget {
  const Tab1Screen({super.key});

  @override
  State<Tab1Screen> createState() => _Tab1ScreenState();
}

class _Tab1ScreenState extends State<Tab1Screen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> folders = [
    {'name': 'Default', 'color': Colors.black, 'icon': Icons.check_box},
    {'name': 'Starred', 'color': Colors.black, 'icon': Icons.star},
    {'name': 'Trash', 'color': Colors.black, 'icon': Icons.delete},
    {'name': 'Japan', 'color': Colors.deepPurple, 'icon': Icons.folder},
    {'name': 'Yeonnam', 'color': Colors.teal, 'icon': Icons.folder},
    {'name': 'Hongkong', 'color': Colors.redAccent, 'icon': Icons.folder},
  ];

  void _addNewFolder(String name) {
    setState(() {
      folders.add({
        'name': name,
        'color': Colors.blueAccent,
        'icon': Icons.folder,
      });
    });
  }

  void _showAddFolderDialog() {
    String folderName = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 폴더 만들기'),
        content: TextField(
          decoration: const InputDecoration(hintText: '폴더 이름 입력'),
          onChanged: (value) => folderName = value,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (folderName.trim().isNotEmpty) {
                _addNewFolder(folderName.trim());
              }
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredFolders = folders
        .where((folder) => folder['name']
        .toLowerCase()
        .contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '검색',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredFolders.isEmpty
                  ? const Center(child: Text('검색 결과 없음'))
                  : GridView.builder(
                itemCount: filteredFolders.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final folder = filteredFolders[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FolderDetailScreen(
                              folderName: folder['name']),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          folder['icon'],
                          color: folder['color'],
                          size: 65,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          folder['name'],
                          style: const TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 72,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _showAddFolderDialog,
                icon: const Icon(Icons.create_new_folder),
                iconSize: 35,
                tooltip: '새 폴더',
              ),
              IconButton(
                onPressed: () {
                  print('새 파일 만들기');
                },
                icon: const Icon(Icons.note_add),
                iconSize: 35,
                tooltip: '새 파일',
              ),
            ],
          ),
        ),
      ),
    );
  }
}