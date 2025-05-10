import 'package:flutter/material.dart';
import 'package:memore/presentation/screen/home/tab1/folder_tile.dart';
import 'package:memore/presentation/screen/home/tab1/tab1_controller.dart';
import '../ai/ai_travel_chat_screen.dart';
import '../folder/folder_model.dart';
import '../folder/folder_storage.dart';
import '../folder/folder_reorder_screen.dart';
import '../folder/add_folder_dialog.dart';
import '../folder/folder_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'folder_grid.dart';
import 'folder_toolbar.dart';
import 'folder_option_sheet.dart';

class Tab1Screen extends StatefulWidget {
  const Tab1Screen({super.key});

  @override
  State<Tab1Screen> createState() => _Tab1ScreenState();
}

class _Tab1ScreenState extends State<Tab1Screen> {
  List<Folder> folders = [];
  String _searchQuery = '';
  bool _isFabExpanded = false;
  final FocusNode _searchFocusNode = FocusNode(); // FocusNode 추가
  final List<Color> pastelColors = [
    Color(0xFFFFC1CC), // 연핑크
    Color(0xFFFFAB91), // 살구색
    Color(0xFFFFE082), // 연노랑
    Color(0xFFAED581), // 연초록
    Color(0xFF81D4FA), // 하늘색
    Color(0xFFCE93D8), // 연보라
    Color(0xFFB0BEC5), // 그레이블루
  ];

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    folders = await Tab1Controller.loadFolders();
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
            color: Color(0xFFFFE082),
            icon: Icons.folder,
            createdAt: DateTime.now(),
          ),
        );
      });
      _saveFolders();
    }
  }

  // 폴더 삭제 함수
  void _deleteFolder(int index) {
    setState(() {
      folders.removeAt(index);
    });
    _saveFolders();
  }

  // 즐겨찾기 등록 함수
  void _toggleStar(int index) {
    setState(() {
      folders[index] = Folder(
        name: folders[index].name,
        color: folders[index].color,
        icon: folders[index].icon,
        isStarred: !folders[index].isStarred,
        // 즐겨찾기 상태만 변경
        createdAt: folders[index].createdAt,
        imagePath: folders[index].imagePath, // ⭐️ 프로필 이미지 유지
      );
    });
    _saveFolders();
  }

  // 폴더 색상 변경 함수
  void _showColorPicker(BuildContext context, int index) {
    showModalBottomSheet(
      backgroundColor: Color(0xFFFFFBF5),
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: pastelColors.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  folders[index] = Folder(
                    name: folders[index].name,
                    color: color,
                    // 테두리 색상만 변경
                    icon: folders[index].icon,
                    isStarred: folders[index].isStarred,
                    createdAt: folders[index].createdAt,
                    imagePath: folders[index].imagePath, // ⭐️ 프로필 이미지 유지
                  );
                });
                _saveFolders();
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundColor: color,
                radius: 16,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // 폴더 이름 변경
  void _renameFolder(BuildContext context, int index) {
    String newName = folders[index].name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('폴더 이름 변경'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '새 폴더 이름 입력',
          ),
          onChanged: (value) {
            newName = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newName.trim().isNotEmpty) {
                setState(() {
                  folders[index] = Folder(
                    name: newName.trim(),
                    color: folders[index].color,
                    icon: folders[index].icon,
                    isStarred: folders[index].isStarred,
                    createdAt: folders[index].createdAt,
                  );
                });
                _saveFolders();
                Navigator.pop(context);
              }
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  // 메모리 배경 화면 설정
  void _setProfileImage(BuildContext context, int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        folders[index] = Folder(
          name: folders[index].name,
          color: folders[index].color,
          icon: folders[index].icon,
          isStarred: folders[index].isStarred,
          createdAt: folders[index].createdAt,
          imagePath: pickedFile.path,
        );
      });
      _saveFolders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredFolders = folders
        .where((folder) =>
            folder.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus(); // 키보드 완전 해제
        setState(() {
          _isFabExpanded = false; // FAB 닫기
        });
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: SizedBox(
            height: 40,
            child: TextField(
              focusNode: _searchFocusNode, // FocusNode 연결
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
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
                  borderSide: BorderSide(
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
              icon: Icon(Icons.sort, color: Color(0xFF8B674C)),
              onPressed: () {
                setState(() {
                  final defaultFolder =
                      folders.firstWhere((folder) => folder.name == 'Default');
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
        body: FolderGrid(
          folders: folders,
          filteredFolders: filteredFolders,
          onTapFolder: (folder) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FolderDetailScreen(
                  folderName: folder.name,
                  imagePath: folder.imagePath,
                ),
              ),
            );
          },
          // 꾹 눌렀을 때
          onLongPressFolder: (originalIndex) {
            if (folders[originalIndex].name == 'Default') return;

            showModalBottomSheet(
              backgroundColor: const Color(0xFFFFFBF5),
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.image, color: Color(0xFF8B674C)),
                    title: const Text('Set Background Image',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.pop(context);
                      _setProfileImage(context, originalIndex);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.color_lens, color: Color(0xFF8B674C)),
                    title: const Text('Change Border Color',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.pop(context);
                      _showColorPicker(context, originalIndex);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.edit, color: Color(0xFF8B674C)),
                    title: const Text('Rename Folder',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.pop(context);
                      _renameFolder(context, originalIndex);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.swap_vert, color: Color(0xFF8B674C)),
                    title: const Text('Reorder Folders',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FolderReorderScreen(
                            folders: folders,
                            onReorder: (newFolders) {
                              setState(() {
                                folders = newFolders;
                              });
                              _saveFolders();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      folders[originalIndex].isStarred ? Icons.star : Icons.star_border,
                      color: Color(0xFF8B674C),
                    ),
                    title: Text(
                      folders[originalIndex].isStarred
                          ? 'Remove from Favorites'
                          : 'Add to Favorites',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _toggleStar(originalIndex);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.redAccent),
                    title: const Text('Delete',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.pop(context);
                      _deleteFolder(originalIndex);
                    },
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 확장 FAB: AI 여행지 추천
            AnimatedSlide(
              offset: _isFabExpanded ? const Offset(0, 0) : const Offset(0, 0.3),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: _isFabExpanded ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'aiTravel',
                      mini: true,
                      shape: const CircleBorder(),
                      backgroundColor: Color(0xFF8B674C),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AITravelChatScreen(),
                          ),
                        );
                      },
                      child: const Icon(Icons.travel_explore, color: Color(0xFFFFFBF5)),
                    ),
                    const SizedBox(height: 4),
                    Text('AI Travel Picks',
                        style: TextStyle(fontSize: 11, color: Color(0xFF8B674C), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 확장 FAB: New Folder
            AnimatedSlide(
              offset: _isFabExpanded ? const Offset(0, 0) : const Offset(0, 0.3),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: _isFabExpanded ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'addFolder',
                      mini: true,
                      shape: const CircleBorder(),
                      backgroundColor: Color(0xFF8B674C),
                      onPressed: () {
                        setState(() {
                          _isFabExpanded = false;
                        });
                        _addNewFolder();
                      },
                      child: const Icon(Icons.create_new_folder,
                          color: Color(0xFFFFFBF5)),
                    ),
                    const SizedBox(height: 4),
                    Text('New Folder',
                        style: TextStyle(fontSize: 11, color: Color(0xFF8B674C), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 메인 FAB (기본은 +, 열렸을 땐 ✏️으로 동작 = New Memo)
            FloatingActionButton(
              heroTag: 'mainFab',
              backgroundColor:
              _isFabExpanded ? const Color(0xFFFDEEDC) : Color(0xFF8B674C),
              shape: const CircleBorder(),
              onPressed: () {
                if (_isFabExpanded) {
                  // 열렸을 때 = New Memo 역할
                  // TODO: 메모 추가 동작
                } else {
                  setState(() {
                    _isFabExpanded = true;
                  });
                }
              },
              child: Icon(
                _isFabExpanded ? Icons.note_add : Icons.add,
                color: _isFabExpanded ? Color(0xFF8B674C) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
