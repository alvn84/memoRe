import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
            automaticallyImplyLeading: false, // ← 뒤로가기 버튼 제거
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
                                return SizedBox(
                                  width: double.infinity, // 👉 가로 최대 너비로 확장
                                  child: Card(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    color: const Color(0xFFF9FAFB),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            memo.title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF333333),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            memo.content,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            maxLines: 3,
                                          ),
                                          const SizedBox(height: 12),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              DateFormat('MMM d').format(
                                                  DateTime.parse(
                                                      memo.updatedAt!)),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()
                            : [
                                const Text(
                                  '오늘의 메모가 없습니다.',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
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
