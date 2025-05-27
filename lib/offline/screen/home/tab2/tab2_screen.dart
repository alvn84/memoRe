// ✅ 통합된 Tab2Screen 코드 (여행 일정 + 메모 일정 모두 표시)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../memo/memo_screen.dart';
import '../folder/folder_model.dart';
import '../folder/folder_storage.dart';
import '../folder/folder_detail_screen.dart';

class MemoEntry {
  final String folderKey;
  final int index;
  final String content;
  final String date;

  MemoEntry({
    required this.folderKey,
    required this.index,
    required this.content,
    required this.date,
  });
}

class Tab2Screen extends StatefulWidget {
  const Tab2Screen({super.key});

  @override
  State<Tab2Screen> createState() => _Tab2ScreenState();
}

class _Tab2ScreenState extends State<Tab2Screen> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  List<MemoEntry> _allNotes = [];
  List<MemoEntry> _filteredNotes = [];
  Set<DateTime> memoDates = {};
  Set<DateTime> travelDates = {};
  Map<DateTime, String> travelDateToTripName = {};
  String? _currentTripName;
  String _searchQuery = '';
  bool _sortNewestFirst = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _onDateSelected(_selectedDay!, _focusedDay);
  }

  Future<void> _loadTravelDates() async {
    final folders = await FolderStorage.loadFolders();
    final tempSet = <DateTime>{};
    final tempMap = <DateTime, String>{};

    for (final folder in folders) {
      print('📦 Folder: ${folder.name}, DateRange: ${folder.dateRange}');
    }

    for (final folder in folders) {
      if (folder.dateRange != null) {
        final range = folder.dateRange!;
        for (DateTime d = range.start;
        !d.isAfter(range.end);
        d = d.add(const Duration(days: 1))) {
          final day = DateTime(d.year, d.month, d.day);
          tempSet.add(day);
          tempMap[day] = folder.name;
        }
      }
    }

    setState(() {
      travelDates = tempSet;
      travelDateToTripName = tempMap;
    });
  }

  Future<List<MemoEntry>> _loadMemosForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    List<MemoEntry> result = [];
    final newMemoDates = <DateTime>{};

    for (String folderKey in prefs.getKeys()) {
      if (!folderKey.endsWith('_writtenDates')) continue;
      final notesKey = folderKey.replaceAll('_writtenDates', '');
      final notes = prefs.getStringList(notesKey) ?? [];
      final dates = prefs.getStringList(folderKey) ?? [];

      for (int i = 0; i < notes.length; i++) {
        final parsedDate = DateFormat('yyyy.MM.dd').parse(dates[i]);
        final normalized = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
        newMemoDates.add(normalized);

        if (dates[i] == DateFormat('yyyy.MM.dd').format(date)) {
          result.add(MemoEntry(
            folderKey: notesKey,
            index: i,
            content: notes[i],
            date: dates[i],
          ));
        }
      }
    }

    setState(() {
      memoDates = newMemoDates;
    });

    return result;
  }

  void _onDateSelected(DateTime selectedDay, DateTime focusedDay) async {
    final normalizedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    final memos = await _loadMemosForDate(selectedDay);
    await _loadTravelDates();

    setState(() {
      _allNotes = memos;
      _currentTripName = travelDateToTripName[normalizedDay]; // ✅ 여기!
      _applySearchAndSort();
    });
  }

  void _applySearchAndSort() {
    List<MemoEntry> filtered = _allNotes.where((entry) {
      return entry.content.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (_sortNewestFirst) {
      filtered = filtered.reversed.toList();
    }

    _filteredNotes = filtered;
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _applySearchAndSort();
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _sortNewestFirst = !_sortNewestFirst;
      _applySearchAndSort();
    });
  }

  void _reload() {
    if (_selectedDay != null) {
      _onDateSelected(_selectedDay!, _focusedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 360,
            flexibleSpace: Container(
              color: const Color(0xFFFAFAFA),
              child: FlexibleSpaceBar(
                background: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1),
                  child: Column(
                    children: [
                      TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        onDaySelected: _onDateSelected,
                        rowHeight: 40,
                        eventLoader: (day) {
                          final normalized = DateTime(day.year, day.month, day.day);
                          final events = <String>[];
                          if (memoDates.contains(normalized)) events.add('memo');
                          if (travelDates.contains(normalized)) events.add('travel');
                          return events;
                        },
                        headerStyle: const HeaderStyle(
                          titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        calendarStyle: const CalendarStyle(
                          markerDecoration: BoxDecoration(color: Color(0xFF6495ED), shape: BoxShape.circle),
                          selectedDecoration: BoxDecoration(color: Color(0xFF6495ED), shape: BoxShape.circle),
                          selectedTextStyle: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, events) {
                            if (events.isEmpty) return const SizedBox();

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: events.map((e) {
                                Color dotColor;

                                if (e == 'memo') {
                                  dotColor = const Color(0xFF6495ED); // 메모: 파란 점
                                } else if (e == 'travel') {
                                  dotColor = const Color(0xFFB3E5FC); // 여행: 주황 점
                                } else {
                                  dotColor = Colors.grey;
                                }

                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: dotColor,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: _onSearchChanged,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search, color: Color(0xFF6495ED)),
                                hintText: 'Search notes...',
                                filled: true,
                                fillColor: Color(0xFFF1F4F8),
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: Color(0xFF6495ED), width: 1.5),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(_sortNewestFirst ? Icons.arrow_downward : Icons.arrow_upward),
                            onPressed: _toggleSortOrder,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 여행 일정 카드 표시
                  if (_currentTripName != null)
                    GestureDetector(
                      onTap: () async {
                        final allFolders = await FolderStorage.loadFolders();
                        Folder? matchedFolder;
                        try {
                          matchedFolder = allFolders.firstWhere((f) => f.name == _currentTripName);
                        } catch (e) {
                          matchedFolder = null;
                        }

                        if (matchedFolder != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FolderDetailScreen(
                                folderName: matchedFolder!.name,
                                imagePath: matchedFolder.imagePath,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('해당 폴더를 찾을 수 없습니다.')),
                          );
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        color: const Color(0xFFDCEEFF),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Icon(Icons.flight_takeoff, color: Color(0xFF6495ED)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Trip: $_currentTripName',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // 메모 카드
                  if (_filteredNotes.isEmpty)
                    const Text('No Schedule.', style: TextStyle(fontSize: 18, color: Colors.grey))
                  else
                    Column(
                      children: _filteredNotes.map((entry) {
                        final lines = entry.content.split('\n');
                        final title = lines.first;
                        final deltaJson = lines.skip(1).join('\n');
                        String preview = '';

                        try {
                          final parsed = jsonDecode(deltaJson) as List<dynamic>;
                          final doc = Document.fromJson(parsed);
                          preview = doc.toPlainText().trim();
                        } catch (e) {
                          preview = deltaJson;
                        }

                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NoteEditScreen(
                                  folderKey: entry.folderKey,
                                  initialContent: entry.content,
                                  noteIndex: entry.index,
                                  onNoteSaved: (_) => _reload(),
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            color: const Color(0xFFF9FAFB),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    preview.length > 100 ? '${preview.substring(0, 100)}...' : preview,
                                    style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      DateFormat('MMM d').format(
                                          DateFormat('yyyy.MM.dd').parse(entry.date)),
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}