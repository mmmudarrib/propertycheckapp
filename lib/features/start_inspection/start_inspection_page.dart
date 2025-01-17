import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:propertycheckapp/features/homepage/data/models/booking.dart';

import '../../widgets/rounded_button_widget.dart';

class StartInspectionScreen extends StatefulWidget {
  final Booking booking;
  const StartInspectionScreen({super.key, required this.booking});

  @override
  _StartInspectionScreenState createState() => _StartInspectionScreenState();
}

class _StartInspectionScreenState extends State<StartInspectionScreen> {
  bool loading = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024, // Set maximum width
        maxHeight: 1024, // Set maximum height
        imageQuality: 85 // Set quality (0-100));
        );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Booking booking = widget.booking;
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
        child: (loading)
            ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (booking.mainDoorImage != null)
                      ? CachedNetworkImage(
                          imageUrl: booking.mainDoorImage!,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : (_image != null)
                          ? Image.file(
                              _image!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  (booking.mainDoorImage == null)
                      ? const Text(
                          'Take a picture of the front door to start the inspection.',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 20),

                  // Button to take or retake the photo

                  RoundedButton(
                    text: (_image == null) ? "Take Photo" : "Retake Photo",
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
                                  leading: const Icon(Icons.camera,
                                      color: Colors.white),
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
                  if (_image != null || booking.mainDoorImage != null)
                    RoundedButton(
                      text: "Continue Inspection",
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        await _uploadImage();

                        setState(() {
                          loading = false;
                        });
                      },
                    ),
                ],
              ),
      ),
    );
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      final random = Random();
      String fileName =
          '${random.nextInt(1000000)}${path.extension(_image!.path)}';

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName+');

      UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      await updateBookingStatus(widget.booking.id, downloadURL);
      print('File available at: $downloadURL');
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to upload image.'),
      ));
    }
  }

  Future<void> updateBookingStatus(int bookingId, String url) async {
    final uri = Uri.parse(
        'https://ilovebackend.propertycheck.me/api/booking/attributes/$bookingId');

    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'doorImage': url,
        'doorImageTimestamp': DateTime.now().toIso8601String()
      }),
    );

    if (response.statusCode == 200) {
      print('Booking status updated successfully.');
    } else {
      print('Failed to update booking status. Error: ${response.statusCode}');
    }
  }
}
