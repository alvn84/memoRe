import 'package:flutter/material.dart';
import 'package:memore/presentation/screen/home/folder_feature/folder_model.dart';

class FolderOptionSheet extends StatelessWidget {
  final Folder folder;
  final int index;
  final void Function() onSetProfileImage;
  final void Function() onChangeColor;
  final void Function() onRename;
  final void Function() onReorder;
  final void Function() onToggleStar;
  final void Function() onDelete;

  const FolderOptionSheet({
    super.key,
    required this.folder,
    required this.index,
    required this.onSetProfileImage,
    required this.onChangeColor,
    required this.onRename,
    required this.onReorder,
    required this.onToggleStar,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.image, color: Color(0xFF8B674C)),
          title: const Text('배경 이미지 설정', style: _style),
          onTap: () {
            Navigator.pop(context);
            onSetProfileImage();
          },
        ),
        ListTile(
          leading: Icon(Icons.color_lens, color: Color(0xFF8B674C)),
          title: const Text('메모리 테두리 변경', style: _style),
          onTap: () {
            Navigator.pop(context);
            onChangeColor();
          },
        ),
        ListTile(
          leading: Icon(Icons.edit, color: Color(0xFF8B674C)),
          title: const Text('메모리 이름 변경', style: _style),
          onTap: () {
            Navigator.pop(context);
            onRename();
          },
        ),
        ListTile(
          leading: Icon(Icons.swap_vert, color: Color(0xFF8B674C)),
          title: const Text('배치 변경', style: _style),
          onTap: () {
            Navigator.pop(context);
            onReorder();
          },
        ),
        ListTile(
          leading: Icon(
            folder.isStarred ? Icons.star : Icons.star_border,
            color: Color(0xFF8B674C),
          ),
          title: Text(
            folder.isStarred ? '즐겨찾기 해제' : '즐겨찾기 추가',
            style: _style,
          ),
          onTap: () {
            Navigator.pop(context);
            onToggleStar();
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete, color: Colors.redAccent),
          title: const Text('삭제', style: _style),
          onTap: () {
            Navigator.pop(context);
            onDelete();
          },
        ),
      ],
    );
  }
}

const TextStyle _style = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);