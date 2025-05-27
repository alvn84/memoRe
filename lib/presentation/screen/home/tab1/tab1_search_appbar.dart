// - - - - - - - - - - - - - - - Tab1 검색 앱 바 - - - - - - - - - - - - - - -
import 'package:flutter/material.dart';

class Tab1SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSort;
  final FocusNode searchFocusNode;

  const Tab1SearchAppBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onSort,
    required this.searchFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: SizedBox(
        height: 43,
        child: TextField(
          focusNode: searchFocusNode,
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFF6495ED),
            ),
            hintText: 'Search',
            hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  const BorderSide(color: Color(0xFF6495ED), width: 1.5),
            ),
            filled: true,
            fillColor: Color(0xFFF1F4F8),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.sort, color: Colors.black87),
          onPressed: onSort,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
