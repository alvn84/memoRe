import 'package:flutter/material.dart';

class FolderToolbar extends StatelessWidget {
  final bool isFabExpanded;
  final VoidCallback onToggle;
  final VoidCallback onAddFolder;

  const FolderToolbar({
    super.key,
    required this.isFabExpanded,
    required this.onToggle,
    required this.onAddFolder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 확장 FAB
        AnimatedSlide(
          offset: isFabExpanded ? const Offset(0, 0) : const Offset(0, 0.3),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: isFabExpanded ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: FloatingActionButton(
              heroTag: 'addFolder',
              mini: true,
              shape: const CircleBorder(),
              backgroundColor: const Color(0xFF8B674C),
              onPressed: onAddFolder,
              child: const Icon(Icons.create_new_folder, color: Color(0xFFFFFBF5)),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 메인 FAB
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFabExpanded ? const Color(0xFFFDEEDC) : const Color(0xFF8B674C),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: const CircleBorder(),
            onPressed: onToggle,
            child: Icon(
              isFabExpanded ? Icons.note_add : Icons.add,
              color: isFabExpanded ? const Color(0xFF8B674C) : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}