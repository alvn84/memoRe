import 'package:flutter/material.dart';
import 'signup_screen.dart';

class SignUpProfile extends StatefulWidget {
  final VoidCallback onComplete;
  final SignUpData signUpData; // ✅ 추가

  const SignUpProfile(
      {super.key, required this.onComplete, required this.signUpData}); // ✅ 수정

  @override
  State<SignUpProfile> createState() => _SignUpProfileState();
}

class _SignUpProfileState extends State<SignUpProfile> {
  final List<String> genderOptions = ['Male', 'Female', 'Prefer not to say'];
  final List<String> jobOptions = ['Student', 'Developer', 'Designer', 'Other'];

  String? selectedGender;
  String? selectedJob;
  int? selectedYear;
  int? selectedMonth;
  int? selectedDay;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // 서버로 최종 넘겨주는 버튼
  void _handleComplete() {
    if (selectedGender == null) {
      _showSnackBar('Please select your gender.');
      return;
    }
    if (selectedYear == null || selectedMonth == null || selectedDay == null) {
      _showSnackBar('Please select your full birth date.');
      return;
    }
    if (selectedJob == null) {
      _showSnackBar('Please select your job.');
      return;
    }

    // ✅ 다 통과하면 데이터 저장
    widget.signUpData.gender = selectedGender!;
    widget.signUpData.birthDate =
        '${selectedYear!}-${selectedMonth!.toString().padLeft(2, '0')}-${selectedDay!.toString().padLeft(2, '0')}';
    widget.signUpData.job = selectedJob!;

    FocusScope.of(context).unfocus();
    widget.onComplete();
  }

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
              Center(
                child: SizedBox(
                  width: 290,
                  child: DropdownButtonFormField<String>(
                    value: selectedGender,
                    items: genderOptions
                        .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(
                              gender,
                              style: const TextStyle(
                                fontSize: 14, // ✅ 폰트 크기
                                fontWeight: FontWeight.w600, // ✅ 텍스트 굵게
                              ),
                            )))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedGender = value),
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle: const TextStyle(
                        fontSize: 14, // ✨ 라벨 글자 크기 줄이기
                        fontWeight: FontWeight.w500, // (선택) 살짝 굵게
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 92,
                    child: DropdownButtonFormField<int>(
                      value: selectedYear,
                      items: List.generate(100, (index) => 2025 - index)
                          .map((year) => DropdownMenuItem(
                              value: year,
                              child: Text(
                                '$year',
                                style: const TextStyle(
                                  fontSize: 14, // ✨ 여기서 글자 크기 줄이기
                                  fontWeight: FontWeight.w600, // (선택) 글자 약간 두껍게
                                ),
                              )))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedYear = value),
                      decoration: InputDecoration(
                        labelText: 'Year',
                        labelStyle: const TextStyle(
                          fontSize: 12, // ✨ 라벨 글자 크기 줄이기
                          fontWeight: FontWeight.w500, // (선택) 살짝 굵게
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 92,
                    child: DropdownButtonFormField<int>(
                      value: selectedMonth,
                      items: List.generate(12, (index) => index + 1)
                          .map((month) => DropdownMenuItem(
                              value: month,
                              child: Text(
                                '$month',
                                style: const TextStyle(
                                  fontSize: 14, // ✅ 폰트 크기
                                  fontWeight: FontWeight.w600, // ✅ 텍스트 굵게
                                ),
                              )))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedMonth = value),
                      decoration: InputDecoration(
                        labelText: 'Month',
                        labelStyle: const TextStyle(
                          fontSize: 12, // ✨ 라벨 글자 크기 줄이기
                          fontWeight: FontWeight.w500, // (선택) 살짝 굵게
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 92,
                    child: DropdownButtonFormField<int>(
                      value: selectedDay,
                      items: List.generate(31, (index) => index + 1)
                          .map((day) => DropdownMenuItem(
                              value: day,
                              child: Text(
                                '$day',
                                style: const TextStyle(
                                  fontSize: 14, // ✅ 폰트 크기
                                  fontWeight: FontWeight.w600, // ✅ 텍스트 굵게
                                ),
                              )))
                          .toList(),
                      onChanged: (value) => setState(() => selectedDay = value),
                      decoration: InputDecoration(
                        labelText: 'Day',
                        labelStyle: const TextStyle(
                          fontSize: 12, // ✨ 라벨 글자 크기 줄이기
                          fontWeight: FontWeight.w500, // (선택) 살짝 굵게
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 290,
                  child: DropdownButtonFormField<String>(
                    value: selectedJob,
                    items: jobOptions
                        .map((job) => DropdownMenuItem(
                            value: job,
                            child: Text(
                              job,
                              style: const TextStyle(
                                fontSize: 14, // ✅ 폰트 크기
                                fontWeight: FontWeight.w600, // ✅ 텍스트 굵게
                              ),
                            )))
                        .toList(),
                    onChanged: (value) => setState(() => selectedJob = value),
                    decoration: InputDecoration(
                      labelText: 'Job',
                      labelStyle: const TextStyle(
                        fontSize: 14, // ✅ labelText(라벨) 폰트 크기 줄이기
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Center(
                child: SizedBox(
                  width: 230,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _handleComplete,
                    child: const Text(
                      'Complete Sign Up',
                      style: TextStyle(
                        fontSize: 14, // ✅ 적당한 폰트 크기
                        fontWeight: FontWeight.w600, // ✅ 버튼 텍스트 굵게
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
