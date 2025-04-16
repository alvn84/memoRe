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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 320,
            flexibleSpace: Container(
              color: Color(0xFFFFFBF5), // 예: 연베이지톤 배경색
              child: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TableCalendar(
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                    },
                    rowHeight: 40,
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
                    headerStyle: const HeaderStyle(
                      titleTextStyle: TextStyle(
                        fontWeight: FontWeight.w700, // 년도, 월 글씨 두껍게
                        fontSize: 18,
                        color: Color(0xFF4F4F4F), // 연검정
                      ),
                      formatButtonVisible: false, // format 변경 버튼 제거
                      titleCentered: true, // 년도, 월 가운데 정렬
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        fontWeight: FontWeight.w600, // 평일 요일 글씨 두껍게
                        color: Color(0xFF4F4F4F),
                      ),
                      weekendStyle: TextStyle(
                        fontWeight: FontWeight.w600, // 주말 요일 글씨 두껍게
                        color: Colors.redAccent,
                      ),
                    ),
                    calendarStyle: const CalendarStyle(
                      defaultTextStyle: TextStyle(
                        fontWeight: FontWeight.w600, // 평소 글씨 두껍게
                        color: Color(0xFF4F4F4F), // 살짝 연한 검정 느낌
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Color(0xFFE5CFC3),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(
                        fontWeight: FontWeight.w900, // 선택 날짜 글씨 더 두껍게
                        color: Colors.white, // 선택 날짜 글씨색 (배경이 진하니까 흰색)
                      ),
                      todayDecoration: BoxDecoration(),
                    ),
                    calendarBuilders: CalendarBuilders(
                      todayBuilder: (context, day, focusedDay) {
                        final isSelected = _selectedDay != null &&
                            isSameDay(day, _selectedDay);
                        return Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w900
                                  : FontWeight.normal,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        );
                      },

                      // 🔥 여기가 핵심
                      defaultBuilder: (context, day, focusedDay) {
                        final isSaturday = day.weekday == DateTime.saturday;
                        final isSunday = day.weekday == DateTime.sunday;

                        Color textColor = const Color(0xFF4F4F4F); // 평일 기본색
                        if (isSaturday) {
                          textColor = Colors.blueAccent;
                        } else if (isSunday) {
                          textColor = Colors.redAccent;
                        }
                        return Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        );
                      },
                      // ✅ 요일 헤더 색상 따로 지정
                      dowBuilder: (context, day) {
                        final weekday = day.weekday;
                        final text = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][weekday % 7];
                        Color color = const Color(0xFF4F4F4F); // 기본 평일색
                        if (weekday == DateTime.saturday) {
                          color = Colors.blueAccent;
                        } else if (weekday == DateTime.sunday) {
                          color = Colors.redAccent;
                        }
                        return Center(
                          child: Text(
                            text,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 100),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(), // 자연스러운 스크롤
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          1,
                          // ← 백엔드에서 받아올 메모 수에 따라 유동적. 스크롤 기능 테스트용. 숫자 늘리면 텍스트 늘어남.
                          (index) => const Padding(
                            padding: EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              '오늘의 메모가 없습니다.',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
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
    );
  }
}
