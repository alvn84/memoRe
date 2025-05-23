// - - - - - - - - - - - - - - - 새 폴더 만들기 창 - - - - - - - - - - - - - - -
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Map<String, dynamic>?> showAddFolderDialog(BuildContext context) {
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  DateTimeRange? selectedDateRange;
  File? selectedImage;

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text(
          'Make New Memo:Re',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFFAFAFA),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: '메모리 이름 입력'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(hintText: '장소 입력'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDateRange == null
                          ? '기간을 선택하세요'
                          : '${selectedDateRange!.start.year}.${selectedDateRange!.start.month}.${selectedDateRange!.start.day} ~ ${selectedDateRange!.end.year}.${selectedDateRange!.end.month}.${selectedDateRange!.end.day}',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(now.year - 1),
                        lastDate: DateTime(now.year + 5),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDateRange = picked;
                        });
                      }
                    },
                  )
                ],
              ),

              const SizedBox(height: 10),
              // 📌 이미지 선택
              Row(
                children: [
                  selectedImage != null
                      ? Image.file(selectedImage!,
                          width: 50, height: 50, fit: BoxFit.cover)
                      : const Text('이미지 미선택'),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final picked =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (picked != null) {
                        setState(() {
                          selectedImage = File(picked.path);
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty &&
                  locationController.text.trim().isNotEmpty &&
                  selectedDateRange != null) {
                Navigator.of(context).pop({
                  'name': nameController.text.trim(),
                  'location': locationController.text.trim(),
                  'startDate': selectedDateRange!.start,
                  'endDate': selectedDateRange!.end,
                });
              }
            },
            child: const Text(
              'Confirm',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF6495ED)),
            ),
          ),
        ],
      ),
    ),
  );
}
