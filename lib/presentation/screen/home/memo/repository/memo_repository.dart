// memo_repository.dart (정리 후)

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/memo.dart';

class MemoRepository {

  
  Future<List<Memo>> getMemos(String folderKey) async {
    final prefs = await SharedPreferences.getInstance();
    final rawNotes = prefs.getStringList(folderKey) ?? [];
    final writtenDates = prefs.getStringList('${folderKey}_writtenDates') ?? [];
    final modifiedDates = prefs.getStringList('${folderKey}_modified') ?? [];

    return List.generate(rawNotes.length, (i) {
      final parts = rawNotes[i].split('\n');
      final title = parts.first;
      final contentJson = parts.skip(1).join('\n');
      return Memo(
        title: title,
        contentJson: contentJson,
        writtenDate: writtenDates.length > i ? writtenDates[i] : '',
        modifiedDate: modifiedDates.length > i ? modifiedDates[i] : '',
      );
    });
  }

  Future<void> saveMemo(String folderKey, Memo memo, {int? index}) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList(folderKey) ?? [];
    final modifiedDates = prefs.getStringList('${folderKey}_modified') ?? [];
    final writtenDates = prefs.getStringList('${folderKey}_writtenDates') ?? [];

    final content = '${memo.title}\n${memo.contentJson}';

    if (index != null && index < notes.length) {
      notes[index] = content;
      modifiedDates[index] = memo.modifiedDate;
      writtenDates[index] = memo.writtenDate;
    } else {
      notes.add(content);
      modifiedDates.add(memo.modifiedDate);
      writtenDates.add(memo.writtenDate);
    }

    await prefs.setStringList(folderKey, notes);
    await prefs.setStringList('${folderKey}_modified', modifiedDates);
    await prefs.setStringList('${folderKey}_writtenDates', writtenDates);
  }

  Future<void> deleteMemo(String folderKey, int index) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getStringList(folderKey) ?? [];
    final modifiedDates = prefs.getStringList('${folderKey}_modified') ?? [];
    final writtenDates = prefs.getStringList('${folderKey}_writtenDates') ?? [];

    if (index < notes.length) notes.removeAt(index);
    if (index < modifiedDates.length) modifiedDates.removeAt(index);
    if (index < writtenDates.length) writtenDates.removeAt(index);

    await prefs.setStringList(folderKey, notes);
    await prefs.setStringList('${folderKey}_modified', modifiedDates);
    await prefs.setStringList('${folderKey}_writtenDates', writtenDates);
  }
}
