import 'package:isar/isar.dart';

part 'note.g.dart'; // build_runner가 생성할 파일

@Collection()
class Note {
  Id id = Isar.autoIncrement;

  late String title;
  late String content;

  DateTime createdAt = DateTime.now();
}