// // - - - - - - - - - - - - - - - Tab1 메인 - - - - - - - - - - - - - - -
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memore/presentation/screen/home/tab1/tab1_controller.dart';

import '../ai/ai_travel_chat_screen.dart';
import '../folder_feature/folder_model.dart';
import '../folder_feature/folder_reorder.dart';
import '../folder_feature/folder_screen.dart';
import 'folder/folder_repository.dart';
import 'floating_action_button/add_folder_dialog.dart';
import 'floating_action_button/tab1_fab.dart';
import 'folder/folder_grid.dart';
import 'folder/folder_option_sheet.dart';
import 'tab1_search_appbar.dart';
import '../memo/screen/note_edit_screen.dart';
import 'folder/folder_repository.dart';

class Tab1Screen extends StatefulWidget {
  const Tab1Screen({super.key});

  @override
  State<Tab1Screen> createState() => _Tab1ScreenState();
}

class _Tab1ScreenState extends State<Tab1Screen> {
  List<Folder> folders = [];
  String _searchQuery = '';
  bool _isFabExpanded = false;
  bool _fabPressedOnce = false; // ✅ 최초 클릭 여부 추적
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

  void _handleMainFabPressed() {
    if (!_isFabExpanded) {
      setState(() {
        _isFabExpanded = true;
        _fabPressedOnce = true;
      });
    } else {
      // 두 번째 눌렀을 때 → 메모 작성 진입
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NoteEditScreen(
            isQuickMemo: true,
            onNoteSaved: _loadFolders,
          ),
        ),
      );

      // FAB 닫기
      setState(() {
        _isFabExpanded = false;
        _fabPressedOnce = false;
      });
    }
  }

  Future<void> _loadFolders() async {
    folders = await Tab1Controller.loadFolders();
    setState(() {});
  }

  Future<void> _saveFolder(Folder folder) async {
    try {
      await FolderRepository.saveFolder(folder); // 서버에 저장
      folders.add(folder); // UI 목록에도 반영
      setState(() {}); // 새로고침
    } catch (e) {
      print('❌ 폴더 저장 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('폴더 저장에 실패했습니다.')),
      );
    }
  }

  Future<void> _addNewFolder() async {
    final result = await showAddFolderDialog(context);

    if (result != null &&
        result['name'] != null &&
        result['location'] != null &&
        result['startDate'] != null &&
        result['endDate'] != null) {
      final folder = Folder(
        name: result['name'],
        color: const Color(0xFFFFE082),
        icon: Icons.folder,
        createdAt: DateTime.now(),
        location: result['location'],
        startDate: result['startDate'],
        endDate: result['endDate'],
        imageUrl: result['imageUrl'], // ✅ 이미지 경로 추가
      );

      await _saveFolder(folder); // 서버 저장
      await _loadFolders();      // 서버에서 목록 다시 로딩
      setState(() {});           // UI 갱신
    }
  }

  // 폴더 삭제 함수
  Future<void> _deleteFolder(int index) async {
    final folder = folders[index];

    try {
      await FolderRepository.deleteFolder(folder.id); // 서버에 삭제 요청

      setState(() {
        folders.removeAt(index); // UI에서도 제거
      });
    } catch (e) {
      print('❌ 폴더 삭제 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('폴더 삭제에 실패했습니다.')),
      );
    }
  }

  void _toggleStar(int index) async {
    final folderId = folders[index].id;
    if (folderId == null) return;

    try {
      final updated = await FolderRepository.toggleStarred(folderId);
      setState(() {
        folders[index] = updated;
      });
    } catch (e) {
      print('❌ 즐겨찾기 상태 변경 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('즐겨찾기 변경 실패')),
      );
    }
  }

  // 폴더 색상 변경 함수
  void _showColorPicker(BuildContext context, int index) {
    showModalBottomSheet(
      backgroundColor: Color(0xFFFAFAFA),
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
              onTap: () async {
                final updatedFolder = await FolderRepository.updateFolderColor(
                  folders[index].id!,
                  color,
                );

                setState(() {
                  folders[index] = updatedFolder; // ✅ 서버 응답 기반으로 갱신
                });

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
            onPressed: () async {
              if (newName.trim().isNotEmpty) {
                try {
                  await FolderRepository.renameFolder(
                      folders[index].id!, newName.trim());
                  setState(() {
                    folders[index] =
                        folders[index].copyWith(name: newName.trim());
                  });
                } catch (e) {
                  print('❌ 폴더 이름 변경 실패: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('이름 변경에 실패했습니다.')),
                  );
                }
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
      final updated = folders[index].copyWith(imageUrl: pickedFile.path);

      try {
        await FolderRepository.updateFolderImage(updated.id!, pickedFile.path);
        setState(() {
          folders[index] = updated;
        });
      } catch (e) {
        print('❌ 이미지 업데이트 실패: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지 저장에 실패했습니다.')),
        );
      }
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
        appBar: Tab1SearchAppBar(
          searchQuery: _searchQuery,
          onSearchChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          onSort: () {
            setState(() {
              final defaultFolder =
                  folders.firstWhere((f) => f.name == 'Default');
              final userFolders =
                  folders.where((f) => f.name != 'Default').toList();
              userFolders.sort((a, b) => a.name.compareTo(b.name));
              folders = [defaultFolder, ...userFolders];
            });
          },
          searchFocusNode: _searchFocusNode,
        ),
        body: FolderGrid(
          folders: folders,
          filteredFolders: filteredFolders,
          onTapFolder: (folder) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FolderDetailScreen(
                  folderId: folder.id!,
                  // ✅ 추가
                  folderName: folder.name,
                  imageUrl: folder.imageUrl,
                  folderColor: folder.color,
                  // ✅ 전달
                  folders: folders, // ✅ 현재 폴더 목록 전체 전달
                ),
              ),
            );
          },
          // 꾹 눌렀을 때
          onLongPressFolder: (originalIndex) {
            if (folders[originalIndex].name == 'Default') return;

            showModalBottomSheet(
              backgroundColor: const Color(0xFFFAFAFA),
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => FolderOptionSheet(
                folder: folders[originalIndex],
                index: originalIndex,
                onSetProfileImage: () =>
                    _setProfileImage(context, originalIndex),
                onChangeColor: () => _showColorPicker(context, originalIndex),
                onRename: () => _renameFolder(context, originalIndex),
                onReorder: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FolderReorder(
                        folders: folders,
                        onReorder: (newFolders) {
                          setState(() {
                            folders = newFolders;
                          });
                        },
                      ),
                    ),
                  );
                },
                onToggleStar: () => _toggleStar(originalIndex),
                onDelete: () => _deleteFolder(originalIndex),
              ),
            );
          },
        ),
        floatingActionButton: Tab1FloatingButtons(
          isFabExpanded: _isFabExpanded,
          onNavigateToAi: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AITravelChatScreen()),
            );
          },
          onAddFolder: () {
            setState(() {
              _isFabExpanded = false;
            });
            _addNewFolder();
          },
          onToggle: () {
            setState(() {
              if (_isFabExpanded && _fabPressedOnce) {
                // ✅ 두 번째 누름 → 메모 작성 화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NoteEditScreen(
                      folderId: 3, // default 폴더 ID
                      onNoteSaved: _loadFolders,
                    ),
                  ),
                );
              } else {
                // ✅ 첫 번째 누름 → FAB 확장만
                _isFabExpanded = true;
                _fabPressedOnce = true;
              }
            });
          },
          onMainFabPressed: _handleMainFabPressed, // ✅ 추가
        ),
      ),
    );
  }
}
