import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Tab2Screen extends StatefulWidget {
  const Tab2Screen({super.key});

  @override
  State<Tab2Screen> createState() => _Tab2ScreenState();
}

class _Tab2ScreenState extends State<Tab2Screen> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5FF),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 360,
            backgroundColor: const Color(0xFFFAF5FF),
            flexibleSpace: Container(
              color: const Color(0xFFFAF5FF),
              child: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TableCalendar(
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                    },
                    rowHeight: 42,
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarStyle: const CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(),
                    ),
                    calendarBuilders: CalendarBuilders(
                      todayBuilder: (context, day, focusedDay) {
                        final isSelected =
                            _selectedDay != null && isSameDay(day, _selectedDay);
                        return Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 100),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(), // 자연스러운 스크롤
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          10, // ← 백엔드에서 받아올 메모 수에 따라 유동적. 스크롤 기능 테스트용. 숫자 늘리면 텍스트 늘어남.
                              (index) => const Padding(
                            padding: EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              '오늘의 메모가 없습니다.',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 72,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  print('Tab2 - 새 폴더 만들기');
                },
                icon: const Icon(Icons.create_new_folder),
                iconSize: 35,
                tooltip: '새 폴더',
              ),
              IconButton(
                onPressed: () {
                  print('Tab2 - 새 파일 만들기');
                },
                icon: const Icon(Icons.note_add),
                iconSize: 35,
                tooltip: '새 파일',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
