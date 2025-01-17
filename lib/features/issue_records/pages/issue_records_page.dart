import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:propertycheckapp/widgets/rounded_button_widget.dart';

class IssueRecordPage extends StatefulWidget {
  const IssueRecordPage({
    super.key,
  });

  @override
  _IssueRecordPageState createState() => _IssueRecordPageState();
}

class _IssueRecordPageState extends State<IssueRecordPage> {
  List<String> imageUrls = [];
  int _currentIndex = 0;
  String _severity = 'Low'; // Default severity
  String _notes = '';
  bool isPassed = true;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Text(
          'Issue Record',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              imageUrls.isNotEmpty ? _buildImageCarousel() : Container(),
              const SizedBox(height: 16.0),
              RoundedButton(
                text: imageUrls.isEmpty
                    ? "Add from Library"
                    : "Add More from Library",
                onPressed: _selectImageFromGallery,
              ),
              const SizedBox(height: 16.0),
              RoundedButton(
                text: "Capture Image",
                onPressed: _captureImageFromCamera,
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildToggleButton('Passed', Colors.green, !isPassed),
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
              const SizedBox(height: 16.0),
              RoundedButton(text: "Save Record", onPressed: () {})
            ],
          ),
        ),
      ),
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

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text(
            'This permission is required to access the camera or gallery.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
