import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/rounded_button_widget.dart';
import '../issue_list/pages/issue_list.dart';

class StartInspectionScreen extends StatefulWidget {
  const StartInspectionScreen({super.key});

  @override
  _StartInspectionScreenState createState() => _StartInspectionScreenState();
}

class _StartInspectionScreenState extends State<StartInspectionScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Text(
          'Take Main Door Photo',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display image if selected
            if (_image != null)
              Image.file(
                _image!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
            const Text(
              'Take a picture of the front door to start the inspection.',
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Button to take or retake the photo
            RoundedButton(
              text: _image == null ? "Take Photo" : "Retake Photo",
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      color: Colors.black,
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        children: [
                          ListTile(
                            leading:
                                const Icon(Icons.camera, color: Colors.white),
                            title: const Text('Take a picture',
                                style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context);
                              _takePhoto(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_library,
                                color: Colors.white),
                            title: const Text('Choose from gallery',
                                style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context);
                              _takePhoto(ImageSource.gallery);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),

            // Conditionally show Start Inspection button only if image is selected
            if (_image != null)
              RoundedButton(
                text: "Start Inspection",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IssueListPage(),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
