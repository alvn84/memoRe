import 'package:flutter/material.dart';
import '../../ai/ai_travel_chat_screen.dart';

class Tab1FloatingButtons extends StatelessWidget {
  final bool isFabExpanded;
  final VoidCallback onToggle;
  final VoidCallback onAddFolder;
  final VoidCallback onNavigateToAi;

  const Tab1FloatingButtons({
    super.key,
    required this.isFabExpanded,
    required this.onToggle,
    required this.onAddFolder,
    required this.onNavigateToAi,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // AI Travel Picks
        AnimatedSlide(
          offset: isFabExpanded ? Offset.zero : const Offset(0, 0.3),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: isFabExpanded ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'aiTravel',
                  mini: true,
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xFF8B674C),
                  onPressed: onNavigateToAi,
                  child: const Icon(Icons.travel_explore,
                      color: Color(0xFFFFFBF5)),
                ),
                const SizedBox(height: 4),
                const Text('AI Travel Picks',
                    style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8B674C),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // New Folder
        AnimatedSlide(
          offset: isFabExpanded ? Offset.zero : const Offset(0, 0.3),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: isFabExpanded ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'addFolder',
                  mini: true,
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xFF8B674C),
                  onPressed: onAddFolder,
                  child: const Icon(Icons.create_new_folder,
                      color: Color(0xFFFFFBF5)),
                ),
                const SizedBox(height: 4),
                const Text('New Folder',
                    style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8B674C),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Main FAB
        FloatingActionButton(
          heroTag: 'mainFab',
          backgroundColor:
              isFabExpanded ? const Color(0xFFFDEEDC) : const Color(0xFF8B674C),
          shape: const CircleBorder(),
          onPressed: onToggle,
          child: Icon(
            isFabExpanded ? Icons.note_add : Icons.add,
            color: isFabExpanded ? const Color(0xFF8B674C) : Colors.white,
          ),
        ),
      ],
    );
  }
}
