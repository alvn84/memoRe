// 메모 저장 관련 로직 담당(SharedPreferences)
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoStorageHelper {
  static Future<void> autoSaveMemo({
    required TextEditingController titleController,
    required QuillController controller,
    required String? folderKey,
    required int? memoIndex,
    required DateTime selectedDate,
    required Function(String) onSaved,
  }) async {
    final title = titleController.text.trim();
    final deltaJson = controller.document.toDelta().toJson();
    final fullMemo = '$title\n${jsonEncode(deltaJson)}';
    final dateString = DateFormat('yyyy.MM.dd').format(selectedDate);

    if ((title.isNotEmpty || controller.document.length > 1) && folderKey != null) {
      final prefs = await SharedPreferences.getInstance();
      final memos = prefs.getStringList(folderKey) ?? [];
      final modifiedDates = prefs.getStringList('${folderKey}_modified') ?? [];
      final writtenDates = prefs.getStringList('${folderKey}_writtenDates') ?? [];

      if (memoIndex != null && memoIndex < memos.length) {
        memos[memoIndex] = fullMemo;
        modifiedDates[memoIndex] = DateFormat('yyyy.MM.dd').format(DateTime.now());
        writtenDates[memoIndex] = dateString;
      } else {
        memos.add(fullMemo);
        modifiedDates.add(DateFormat('yyyy.MM.dd').format(DateTime.now()));
        writtenDates.add(dateString);
      }

      await prefs.setStringList(folderKey, memos);
      await prefs.setStringList('${folderKey}_modified', modifiedDates);
      await prefs.setStringList('${folderKey}_writtenDates', writtenDates);
    }

    onSaved(fullMemo);
  }
}