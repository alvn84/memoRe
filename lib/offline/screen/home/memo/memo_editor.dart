// 본문 영역 Quill Editor 담당
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/extensions.dart';

class MemoEditor extends StatelessWidget {
  final QuillController controller;

  const MemoEditor({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: QuillEditor.basic(
          configurations: QuillEditorConfigurations(
            controller: controller,
            sharedConfigurations: const QuillSharedConfigurations(locale: Locale('en')),
          ),
        ),
      ),
    );
  }
}