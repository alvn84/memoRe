// - - - - - - - - - - - - - - - Tab1에서의 상태 관리 코드 - - - - - - - - - - - - - - -
import '../folder_feature/folder_model.dart';
import 'folder/folder_repository.dart';

class Tab1Controller {
  // 폴더 불러오기
  static Future<List<Folder>> loadFolders() async {
    final folders = await FolderRepository.loadFolders();
    print('✅ 서버에서 받은 폴더: $folders');
    return folders;
  }


  // 폴더 추가
  static List<Folder> addFolder(List<Folder> folders, Folder folder) {
    return [...folders, folder];
  }

  // 폴더 삭제
  static Future<List<Folder>> deleteFolder(
      List<Folder> folders, int index) async {
    final folder = folders[index];

    try {
      await FolderRepository.deleteFolder(folder.id!); // 서버에 삭제 요청
      final newList = [...folders]..removeAt(index); // UI 목록에서도 제거
      return newList;
    } catch (e) {
      print('❌ 폴더 삭제 실패: $e');
      return folders; // 실패 시 기존 목록 유지
    }
  }

  // 즐겨찾기 토글
  static List<Folder> toggleStar(List<Folder> folders, int index) {
    final folder = folders[index];
    final updated = Folder(
      name: folder.name,
      color: folder.color,
      icon: folder.icon,
      isStarred: !folder.isStarred,
      createdAt: folder.createdAt,
      imageUrl: folder.imageUrl,
    );
    final newList = [...folders];
    newList[index] = updated;
    return newList;
  }

  // 이름 변경
  static List<Folder> renameFolder(
      List<Folder> folders, int index, String newName) {
    final folder = folders[index];
    final updated = Folder(
      name: newName.trim(),
      color: folder.color,
      icon: folder.icon,
      isStarred: folder.isStarred,
      createdAt: folder.createdAt,
      imageUrl: folder.imageUrl,
    );
    final newList = [...folders];
    newList[index] = updated;
    return newList;
  }

  // 이미지 변경
  static List<Folder> setProfileImage(
      List<Folder> folders, int index, String imageUrl) {
    final folder = folders[index];
    final updated = Folder(
      name: folder.name,
      color: folder.color,
      icon: folder.icon,
      isStarred: folder.isStarred,
      createdAt: folder.createdAt,
      imageUrl: imageUrl,
    );
    final newList = [...folders];
    newList[index] = updated;
    return newList;
  }
}
