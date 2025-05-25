import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../folder/folder_model.dart';
import 'package:nova_places_api/nova_places_api.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewFolderScreen extends StatefulWidget {
  const NewFolderScreen({super.key});


  @override
  State<NewFolderScreen> createState() => _NewFolderScreenState();
}

class _NewFolderScreenState extends State<NewFolderScreen>
    with TickerProviderStateMixin {
  int _step = 0;
  String? _destination;
  DateTimeRange? _dateRange;
  String? _title;
  String? _imagePath;
  bool _isOnline = true;

  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  final PageController _pageController = PageController();

  // 클래스 내 변수 선언
  late PlacesApi placesApi;
  List<PlaceAutocompletePrediction> predictions = [];

  @override
  void initState() {
    super.initState();
    placesApi = PlacesApi(apiKey: 'AIzaSyBmSwL2iuoNT0IR3UupWveT9Z5A608-LN4')..setLanguage('en');
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = connectivityResult != ConnectivityResult.none;
    });
  }

  void _nextStep() {
    if ((_step == 0 && (_destination == null || _destination!.isEmpty)) ||
        (_step == 1 && _dateRange == null) ||
        (_step == 2 && (_title == null || _title!.isEmpty))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an option.', style: TextStyle(color: Color(0xFF6495ED), fontWeight: FontWeight.bold)),
          backgroundColor: Color(0xFFF1F4F8),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_step < 3) {
      setState(() {
        _step++;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      _submit();
    }
  }

  void _prevStep() {
    if (_step > 0) {
      setState(() {
        _step--;
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _submit() {
    if (_destination != null && _dateRange != null && _title != null) {
      final folder = Folder(
        name: _title!,
        color: const Color(0xFF6495ED),
        icon: Icons.folder,
        createdAt: DateTime.now(),
        imagePath: _imagePath,
        destination: _destination,          // ✅ 추가
        dateRange: _dateRange,
      );
      Navigator.pop(context, folder);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imagePath = pickedFile.path);
    }
  }

  List<Widget> _buildSteps() {
    return [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Where are you going?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _destinationController,
            decoration: InputDecoration(
              hintText: "Enter your destination",
              filled: true,
              fillColor: const Color(0xFFF1F4F8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            onChanged: (val) async {
              setState(() {
                _destination = val;
              });

              if (_isOnline && val.isNotEmpty) {
                final response = await placesApi.placeAutocomplete(input: val);
                if (response.isSuccess && response.predictions != null) {
                  setState(() {
                    predictions = response.predictions!;
                  });
                }
              } else {
                setState(() {
                  predictions = [];
                });
              }
            },
          ),
          const SizedBox(height: 8),
          if (predictions.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(maxHeight: 180),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: predictions.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final prediction = predictions[index];
                  return ListTile(
                    title: Text(
                      prediction.description ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                    onTap: () {
                      _destinationController.text = prediction.description ?? '';
                      _destination = prediction.description;
                      setState(() => predictions = []);
                    },
                  );
                },
              ),
            ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("When is your trip?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () async {
              final now = DateTime.now();
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(now.year - 1),
                lastDate: DateTime(now.year + 2),
              );
              if (picked != null) {
                setState(() => _dateRange = picked);
              }
            },
            child: Text(
              _dateRange == null
                  ? "Select travel period"
                  : "${DateFormat('yMMMd').format(_dateRange!.start)} - ${DateFormat('yMMMd').format(_dateRange!.end)}",
              style: const TextStyle(fontSize: 20, color: Color(0xFF6495ED), fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("What would you like to name this trip?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "Enter a title",
              filled: true,
              fillColor: Color(0xFFF1F4F8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
            ),
            onChanged: (val) => _title = val,
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Choose a background image", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image, color: Colors.white),
            label: const Text("Select Image", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6495ED),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          if (_imagePath != null) ...[
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_imagePath!),
                width: 200,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ]
        ],
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text("New Trip Setup", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _buildSteps().map((step) => Center(child: Padding(padding: const EdgeInsets.all(24.0), child: step))).toList(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Row(
          children: [
            if (_step > 0)
              Expanded(
                child: ElevatedButton(
                  onPressed: _prevStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Back', style: TextStyle(color: Colors.black)),
                ),
              ),
            if (_step > 0) const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6495ED),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _nextStep,
                child: Text(_step < 3 ? "Next" : "Create Folder",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
