// - - - - - - - - - - - - - - - Tab1 검색 앱 바 - - - - - - - - - - - - - - -
import 'package:flutter/material.dart';

class Tab1SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSort;

  const Tab1SearchAppBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: SizedBox(
        height: 40,
        child: TextField(
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.black12, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFF6495ED), width: 1.2),
            ),
            filled: true,
            fillColor: Colors.transparent,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.sort, color: Color(0xFF6495ED)),
          onPressed: onSort,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
