import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Tab2Calendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  const Tab2Calendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      rowHeight: 40,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: onDaySelected,
      headerStyle: const HeaderStyle(
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF4F4F4F)),
        formatButtonVisible: false,
        titleCentered: true,
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle:
            TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4F4F4F)),
        weekendStyle:
            TextStyle(fontWeight: FontWeight.w600, color: Colors.redAccent),
      ),
      calendarStyle: const CalendarStyle(
        defaultTextStyle:
            TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4F4F4F)),
        selectedDecoration:
            BoxDecoration(color: Color(0xFF6495ED), shape: BoxShape.circle),
        selectedTextStyle:
            TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        todayDecoration: BoxDecoration(),
      ),
      calendarBuilders: CalendarBuilders(
        todayBuilder: (context, day, focusedDay) {
          final isSelected = selectedDay != null && isSameDay(day, selectedDay);
          return Center(
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          );
        },
        defaultBuilder: (context, day, focusedDay) {
          final isSaturday = day.weekday == DateTime.saturday;
          final isSunday = day.weekday == DateTime.sunday;

          Color textColor = const Color(0xFF4F4F4F);
          if (isSaturday)
            textColor = Colors.blueAccent;
          else if (isSunday) textColor = Colors.redAccent;

          return Center(
            child: Text(
              '${day.day}',
              style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
            ),
          );
        },
        dowBuilder: (context, day) {
          final weekday = day.weekday;
          final text =
              ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][weekday % 7];
          Color color = const Color(0xFF4F4F4F);
          if (weekday == DateTime.saturday)
            color = Colors.blueAccent;
          else if (weekday == DateTime.sunday) color = Colors.redAccent;

          return Center(
            child: Text(text,
                style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          );
        },
      ),
    );
  }
}
