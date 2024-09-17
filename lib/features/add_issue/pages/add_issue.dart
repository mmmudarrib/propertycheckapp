import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:propertycheckapp/constants.dart';
import 'package:propertycheckapp/features/issue_records/pages/issue_records_page.dart';
import 'package:propertycheckapp/widgets/rounded_button_widget.dart';

class AddIssuePage extends StatefulWidget {
  final String selectedRoomType;
  final String selectedRoomSubtype;
  const AddIssuePage(
      {super.key,
      required this.selectedRoomType,
      required this.selectedRoomSubtype});

  @override
  _AddIssuePageState createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  String? _selectedRoomType;
  String? _selectedRoomSubtype;
  String? _selectedIssueCategory;
  String? _selectedIssueSubCategory;
  String? _selectedIssue;
  List<String> imageUrls = [];
  int _currentIndex = 0;
  String _severity = 'Low'; // Default severity
  String _notes = '';
  bool isPassed = true;

  final ImagePicker _picker = ImagePicker();

  final List<String> roomTypes = [
    'Living Room',
    'Kitchen',
    'Bedroom',
    'Bathroom'
  ];
  final List<String> roomSubtypes = ['Ceiling', 'Wall', 'Floor', 'Sink'];
  final List<String> issueCategories = [
    'Structural',
    'Plumbing',
    'Electrical',
    'Cosmetic'
  ];
  final List<String> issueSubCategories = [
    'Crack',
    'Leakage',
    'Short Circuit',
    'Peeling'
  ];
  final List<String> issues = [
    'Minor Crack',
    'Major Leak',
    'Electrical Fault',
    'Paint Peeling'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Add New Issue',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageUrls.isNotEmpty ? _buildImageCarousel() : Container(),
              const SizedBox(height: 16.0),
              RoundedButton(
                text: imageUrls.isEmpty ? "Add Image" : "Add More Images",
                onPressed: _selectImageFromGallery,
              ),
              const SizedBox(height: 16.0),
              RoundedButton(
                text: "Capture Image",
                onPressed: _captureImageFromCamera,
              ),
              const SizedBox(height: 16.0),
              const Text("Room Type"),
              const SizedBox(height: 16.0),
              const Text("Room SubType"),
              const SizedBox(height: 16.0),
              _buildDropdown(
                label: 'Issue Category',
                value: _selectedIssueCategory,
                items: issueCategories,
                onChanged: (value) {
                  setState(() {
                    _selectedIssueCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              _buildDropdown(
                label: 'Issue Subcategory',
                value: _selectedIssueSubCategory,
                items: issueSubCategories,
                onChanged: (value) {
                  setState(() {
                    _selectedIssueSubCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              _buildDropdown(
                label: 'Issue',
                value: _selectedIssue,
                items: issues,
                onChanged: (value) {
                  setState(() {
                    _selectedIssue = value;
                  });
                },
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildToggleButton('Passed', Colors.green, !isPassed),
                  const SizedBox(width: 16.0),
                  _buildToggleButton('At Risk', Colors.orange, !isPassed),
                  const SizedBox(width: 16.0),
                  _buildToggleButton('Failed', Colors.red, isPassed),
                ],
              ),
              const SizedBox(height: 16.0),
              _buildSeverityDropdown(),
              const SizedBox(height: 16.0),
              _buildTextField('Notes', maxLines: 4, onChanged: (value) {
                setState(() {
                  _notes = value;
                });
              }),
              const SizedBox(height: 32.0),
              Center(
                child: RoundedButton(
                  onPressed: () {
                    // Handle save issue action
                    if (_selectedRoomType != null &&
                        _selectedRoomSubtype != null &&
                        _selectedIssueCategory != null &&
                        _selectedIssueSubCategory != null &&
                        _selectedIssue != null) {
                      // Save the issue or perform the necessary action

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IssueRecordPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill in all fields.')),
                      );
                    }
                  },
                  text: 'Add Issue Record',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          dropdownColor: AppColors.primaryColor,
          value: value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
          hint: Text(
            'Select $label',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildImageCarousel() {
    return CarouselSlider(
      items: imageUrls.map((url) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            File(url),
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width * 0.8,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 250.0,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Future<void> _selectImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageUrls.add(image.path);
      });
    }
  }

  Future<void> _captureImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imageUrls.add(image.path);
      });
    }
  }

  Widget _buildToggleButton(String label, Color color, bool selected) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isPassed = label == 'Passed';
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? color : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildSeverityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Severity',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8.0),
        DropdownButtonFormField<String>(
          value: _severity,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
          items: ['Low', 'Medium', 'High'].map((severity) {
            return DropdownMenuItem(
              value: severity,
              child: Text(severity),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _severity = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTextField(String label,
      {int maxLines = 1, required ValueChanged<String> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8.0),
        TextField(
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}
