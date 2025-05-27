// - - - - - - - - - - - - - - - Tab1의 FAB 버튼 - - - - - - - - - - - - - - -
import 'package:flutter/material.dart';
import '../../memo/screen/memo_screen.dart';
import '../../memo/screen/note_edit_screen.dart';

class Tab1FloatingButtons extends StatefulWidget {
  final bool isFabExpanded;
  final VoidCallback onMainFabPressed;
  final VoidCallback onToggle;
  final VoidCallback onAddFolder;
  final VoidCallback onNavigateToAi;

  const Tab1FloatingButtons({
    super.key,
    required this.onMainFabPressed,
    required this.isFabExpanded,
    required this.onToggle,
    required this.onAddFolder,
    required this.onNavigateToAi,
  });

  @override
  State<Tab1FloatingButtons> createState() => _Tab1FloatingButtonsState();
}

class _Tab1FloatingButtonsState extends State<Tab1FloatingButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // AI Travel Picks
        AnimatedSlide(
          offset: widget.isFabExpanded ? Offset.zero : const Offset(0, 0.3),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: widget.isFabExpanded ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'aiTravel',
                  mini: true,
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xFF6495ED),
                  onPressed: widget.onNavigateToAi,
                  child: const Icon(Icons.travel_explore,
                      color: Color(0xFFFAFAFA)),
                ),
                const SizedBox(height: 4),
                const Text('AI Travel Picks',
                    style: TextStyle(
                        shadows: [
                          Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: Colors.black54)
                        ],
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // New Folder
        AnimatedSlide(
          offset: widget.isFabExpanded ? Offset.zero : const Offset(0, 0.3),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: widget.isFabExpanded ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'addFolder',
                  mini: true,
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xFF6495ED),
                  onPressed: widget.onAddFolder,
                  child: const Icon(Icons.create_new_folder,
                      color: Color(0xFFFAFAFA)),
                ),
                const SizedBox(height: 4),
                const Text('New Folder',
                    style: TextStyle(
                        shadows: [
                          Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: Colors.black54)
                        ],
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Main FAB
        FloatingActionButton(
          heroTag: 'mainFab',
          backgroundColor: widget.isFabExpanded
              ? const Color(0xFFFAFAFA)
              : const Color(0xFF6495ED),
          shape: const CircleBorder(),
          onPressed: widget.onMainFabPressed,
          // ← 이걸로 변경
          child: Icon(
            widget.isFabExpanded ? Icons.note_add : Icons.add,
            color:
                widget.isFabExpanded ? const Color(0xFF6495ED) : Colors.white,
          ),
        ),
      ],
    );
  }
}
