import '../folder_feature/folder_model.dart';
import '../folder_feature/folder_storage.dart';

class Tab1Controller {
  // 폴더 불러오기
  static Future<List<Folder>> loadFolders() async {
    return await FolderStorage.loadFolders();
  }

  // 폴더 저장
  static Future<void> saveFolders(List<Folder> folders) async {
    await FolderStorage.saveFolders(folders);
  }

  // 폴더 추가
  static List<Folder> addFolder(List<Folder> folders, Folder folder) {
    return [...folders, folder];
  }

  // 폴더 삭제
  static List<Folder> deleteFolder(List<Folder> folders, int index) {
    final newList = [...folders];
    newList.removeAt(index);
    return newList;
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
      imagePath: folder.imagePath,
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
      imagePath: folder.imagePath,
    );
    final newList = [...folders];
    newList[index] = updated;
    return newList;
  }

  // 이미지 변경
  static List<Folder> setProfileImage(
      List<Folder> folders, int index, String imagePath) {
    final folder = folders[index];
    final updated = Folder(
      name: folder.name,
      color: folder.color,
      icon: folder.icon,
      isStarred: folder.isStarred,
      createdAt: folder.createdAt,
      imagePath: imagePath,
    );
    final newList = [...folders];
    newList[index] = updated;
    return newList;
  }
}
