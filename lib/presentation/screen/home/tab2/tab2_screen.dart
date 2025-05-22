import 'package:flutter/material.dart';
import '../memo/repository/memo_repository.dart';
import '../memo/model/memo_model.dart';
import 'tab2_calendar.dart';

class Tab2Screen extends StatefulWidget {
  const Tab2Screen({super.key});

  @override
  State<Tab2Screen> createState() => _Tab2ScreenState();
}

class _Tab2ScreenState extends State<Tab2Screen> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  List<Memo> allMemos = [];

  void _loadAllMemos() async {
    allMemos = await MemoRepository().getAllMemos();
    setState(() {});
  }

  List<Memo> get selectedDayMemos {
    return allMemos.where((memo) {
      if (memo.updatedAt == null) return false;
      final updated = DateTime.parse(memo.updatedAt!);
      return updated.year == _selectedDay!.year &&
          updated.month == _selectedDay!.month &&
          updated.day == _selectedDay!.day;
    }).toList();
  }


  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadAllMemos();
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
              color: Color(0xFFFAFAFA), // 예: 연베이지톤 배경색
              child: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Tab2Calendar(
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
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
                        children: selectedDayMemos.isNotEmpty
                            ? selectedDayMemos.map((memo) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  memo.title,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  memo.content,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Divider(),
                              ],
                            ),
                          );
                        }).toList()
                            : [
                          const Text(
                            '오늘의 메모가 없습니다.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          )
                        ],
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
