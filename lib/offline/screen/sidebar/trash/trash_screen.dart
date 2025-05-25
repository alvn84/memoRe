import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/folder/folder_model.dart';
import '../../home/folder/folder_storage.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({super.key});

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  List<Folder> trashFolders = [];

  @override
  void initState() {
    super.initState();
    _loadTrash();
  }

  Future<void> _loadTrash() async {
    final prefs = await SharedPreferences.getInstance();
    final trashJson = prefs.getStringList('trash_folders') ?? [];

    setState(() {
      trashFolders =
          trashJson.map((e) => Folder.fromJson(jsonDecode(e))).toList();
    });
  }

  Future<void> _restoreFolder(Folder folder) async {
    final current = await FolderStorage.loadFolders();
    current.add(folder);
    await FolderStorage.saveFolders(current);

    // 휴지통에서 제거
    trashFolders.remove(folder);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'trash_folders',
      trashFolders.map((f) => jsonEncode(f.toJson())).toList(),
    );

    setState(() {});

    Navigator.pop(context,true);
  }

  Future<void> _deletePermanently(Folder folder) async {
    trashFolders.remove(folder);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'trash_folders',
      trashFolders.map((f) => jsonEncode(f.toJson())).toList(),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: trashFolders.isEmpty
            ? const Center(
          child: Text(
            'Trash is empty.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: trashFolders.length,
          itemBuilder: (context, index) {
            final folder = trashFolders[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: folder.imagePath == null ? folder.color : null,
                image: folder.imagePath != null
                    ? DecorationImage(
                  image: FileImage(File(folder.imagePath!)),
                  fit: BoxFit.cover,
                )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // 하단 텍스트 정보
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              folder.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.restore,
                                    color: Colors.white),
                                tooltip: '복원',
                                onPressed: () =>
                                    _restoreFolder(folder),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_forever,
                                    color: Colors.redAccent),
                                tooltip: '영구삭제',
                                onPressed: () =>
                                    _deletePermanently(folder),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}