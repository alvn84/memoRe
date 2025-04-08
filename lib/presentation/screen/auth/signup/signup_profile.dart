import 'package:flutter/material.dart';

class SignUpProfile extends StatefulWidget {
  final VoidCallback onComplete;

  const SignUpProfile({super.key, required this.onComplete});

  @override
  State<SignUpProfile> createState() => _SignUpProfileState();
}

class _SignUpProfileState extends State<SignUpProfile> {
  final List<String> genderOptions = ['남자', '여자', '답변 안 함'];
  final List<String> jobOptions = ['학생', '개발자', '디자이너', '기타'];

  String? selectedGender;
  String? selectedJob;
  int? selectedYear;
  int? selectedMonth;
  int? selectedDay;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // ✅ 배경 터치 시 키보드 내리기
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Profile Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: genderOptions
                    .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                    .toList(),
                onChanged: (value) => setState(() => selectedGender = value),
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: selectedYear,
                      items: List.generate(100, (index) => 2025 - index)
                          .map((year) => DropdownMenuItem(value: year, child: Text('$year')))
                          .toList(),
                      onChanged: (value) => setState(() => selectedYear = value),
                      decoration: const InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: selectedMonth,
                      items: List.generate(12, (index) => index + 1)
                          .map((month) => DropdownMenuItem(value: month, child: Text('$month')))
                          .toList(),
                      onChanged: (value) => setState(() => selectedMonth = value),
                      decoration: const InputDecoration(
                        labelText: 'Month',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: selectedDay,
                      items: List.generate(31, (index) => index + 1)
                          .map((day) => DropdownMenuItem(value: day, child: Text('$day')))
                          .toList(),
                      onChanged: (value) => setState(() => selectedDay = value),
                      decoration: const InputDecoration(
                        labelText: 'Day',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedJob,
                items: jobOptions
                    .map((job) => DropdownMenuItem(value: job, child: Text(job)))
                    .toList(),
                onChanged: (value) => setState(() => selectedJob = value),
                decoration: const InputDecoration(
                  labelText: 'Job',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedGender == null ||
                        selectedYear == null ||
                        selectedMonth == null ||
                        selectedDay == null ||
                        selectedJob == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please complete all fields')),
                      );
                      return;
                    }

                    FocusScope.of(context).unfocus(); // ✅ 완료 시 키보드 먼저 내리기
                    widget.onComplete(); // ✅ 이후 완료 로직 호출
                  },
                  child: const Text('Complete Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}