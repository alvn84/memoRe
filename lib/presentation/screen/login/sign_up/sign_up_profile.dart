import 'package:flutter/material.dart';

class SignUpProfile extends StatefulWidget {
  final VoidCallback onComplete;

  const SignUpProfile({super.key, required this.onComplete});

  @override
  State<SignUpProfile> createState() => _SignUpProfileState();
}

class _SignUpProfileState extends State<SignUpProfile> {
  String? _selectedGender;
  int? _selectedYear;
  int? _selectedMonth;
  int? _selectedDay;
  String? _selectedJob;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _jobOptions = ['Student', 'Engineer', 'Designer', 'Teacher', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: _genderOptions
                  .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedGender = value),
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
                    value: _selectedYear,
                    items: List.generate(100, (index) => 2025 - index)
                        .map((year) => DropdownMenuItem(value: year, child: Text('$year')))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedYear = value),
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedMonth,
                    items: List.generate(12, (index) => index + 1)
                        .map((month) => DropdownMenuItem(value: month, child: Text('$month')))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedMonth = value),
                    decoration: const InputDecoration(
                      labelText: 'Month',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedDay,
                    items: List.generate(31, (index) => index + 1)
                        .map((day) => DropdownMenuItem(value: day, child: Text('$day')))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedDay = value),
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
              value: _selectedJob,
              items: _jobOptions
                  .map((job) => DropdownMenuItem(value: job, child: Text(job)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedJob = value),
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
                  if (_selectedGender == null ||
                      _selectedYear == null ||
                      _selectedMonth == null ||
                      _selectedDay == null ||
                      _selectedJob == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please complete all fields')),
                    );
                    return;
                  }
                  widget.onComplete(); // 회원가입 완료
                },
                child: const Text('Complete Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}