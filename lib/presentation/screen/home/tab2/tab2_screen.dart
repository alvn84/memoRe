import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Tab2Screen extends StatefulWidget {
  const Tab2Screen({super.key});

  @override
  State<Tab2Screen> createState() => _Tab2ScreenState();
}

class _Tab2ScreenState extends State<Tab2Screen>
    with AutomaticKeepAliveClientMixin {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay; // ← 처음 진입 시 오늘 날짜를 선택된 걸로 설정
  }

  @override
  bool get wantKeepAlive => true; // ✅ 이걸 true로 설정해야 상태가 유지됨

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ 꼭 호출해야 함 (KeepAliveMixin 쓸 때)

    return Stack(
      children: [
        Column(
          children: [
            TableCalendar(
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
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                '오늘의 메모가 없습니다.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ],
        ),

        // 하단 FAB 고정
        Positioned(
          bottom: 24,
          left: 24,
          child: FloatingActionButton(
            heroTag: 'create_folder_tab2',
            onPressed: () {
              print('Tab2 - 새 폴더 만들기');
            },
            tooltip: '새 폴더',
            child: const Icon(Icons.create_new_folder),
          ),
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            heroTag: 'create_file_tab2',
            onPressed: () {
              print('Tab2 - 새 파일 만들기');
            },
            tooltip: '새 파일',
            child: const Icon(Icons.note_add),
          ),
        ),
      ],
    );
  }
}
