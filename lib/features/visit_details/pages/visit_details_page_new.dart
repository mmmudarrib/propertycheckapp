import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:propertycheckapp/features/issue_list/pages/issue_list_new.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../homepage/data/models/booking.dart';
import '../../login/pages/login_page.dart';

class PropertyDetailPage extends StatefulWidget {
  final Booking booking;
  const PropertyDetailPage({super.key, required this.booking});

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  File? _image;
  final ImagePicker picker = ImagePicker();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    // Obtain screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1D1D1B),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row with Logo and Power Icon
              Container(
                color: const Color(0xff242424),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100, // Adjust width as needed
                      height: 60, // Adjust height as needed
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                        size: 20, // Adjust size as needed
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: (loading)
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.green,
                        ),
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "# ${widget.booking.id.toString()}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'GothamBlack',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow:
                                      TextOverflow.ellipsis, // Handle overflow
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          // Property Details Header
                          const Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'PROPERTY DETAILS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'GothamBold',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Property Details Row
                          LayoutBuilder(
                            builder: (context, constraints) {
                              double itemWidth =
                                  (constraints.maxWidth - 16) / 3;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _propertyDetail(
                                      widget.booking.checkType ?? "",
                                      Icons.build,
                                      itemWidth),
                                  _propertyDetail(
                                      widget.booking
                                              .bookingChildPropertytypeName ??
                                          "",
                                      Icons.location_city,
                                      itemWidth),
                                  _propertyDetail(
                                      "${widget.booking.numberOfBedrooms} Bedrooms",
                                      Icons.king_bed,
                                      itemWidth),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          // Property Address Header
                          const Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'PROPERTY ADDRESS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'GothamBold',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Property Address
                          Text(
                            "${widget.booking.unit}, ${widget.booking.community} ${widget.booking.area} ",
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'GothamBook',
                                fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                          const SizedBox(height: 32),
                          // Notes Section
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform.flip(
                                flipY: true,
                                child: const Icon(
                                  Icons.turn_right,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'NOTES',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: 'GothamBold',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        widget.booking.specialInstruction
                                                .isEmpty
                                            ? "No Notes"
                                            : widget.booking.specialInstruction,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'GothamBook',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Checking For Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'CHECKING FOR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'GothamBold',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.booking.clientName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'GothamBook',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Handle overflow
                                  ),
                                  const SizedBox(width: 16),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.green,
                                        child: IconButton(
                                          icon: const Icon(Icons.phone,
                                              color: Colors.white),
                                          onPressed: () {
                                            // Add phone action here
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      CircleAvatar(
                                        backgroundColor: Colors.green,
                                        child: IconButton(
                                          icon: const Icon(Icons.chat,
                                              color: Colors.white),
                                          onPressed: () {
                                            // Add chat action here
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 110),
                          // Action Slider
                          SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SwipeButton.expand(
                                  thumb: const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  ),
                                  activeThumbColor: const Color(0xff009540),
                                  activeTrackColor: const Color(0xffDBFFEA),
                                  inactiveThumbColor: Colors.greenAccent,
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 50),
                                    child: Text(
                                      "SWIPE TO START CHECK",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xff009540),
                                        fontFamily: 'GothamBold',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  onSwipe: () async {
                                    await _pickImage();
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _propertyDetail(String label, IconData icon, double width) {
    return SizedBox(
      width: width, // Dynamic width
      child: Row(
        children: [
          Icon(icon,
              color: Colors.white, size: 24), // Reduced size for better fit
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'GothamBook',
                  fontSize: 10,
                  fontWeight: FontWeight.w400),
              overflow: TextOverflow.fade, // Handle overflow
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;
    try {
      setState(() {
        loading = true;
      });
      final random = Random();
      String fileName =
          '${random.nextInt(1000000)}${path.extension(_image!.path)}';
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      await updateImage(widget.booking.id, downloadURL);
      await updateBookingStatus(widget.booking.id);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IssueListNew(
            booking: widget.booking,
          ),
        ),
      );
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to upload image.'),
      ));
    }
  }

  Future<void> updateBookingStatus(int bookingId) async {
    final url = Uri.parse(
        'https://ilovebackend.propertycheck.me/api/booking/attributes/$bookingId');
    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'bookingStatus': 'In Progress'}),
    );
    if (response.statusCode == 200) {
      print('Booking status updated successfully.');
    } else {
      print('Failed to update booking status. Error: ${response.statusCode}');
    }
  }

  Future<void> updateImage(int bookingId, String url) async {
    final uri = Uri.parse(
        'https://ilovebackend.propertycheck.me/api/booking/attributes/$bookingId');
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'doorImage': url,
        'doorImageTimestamp': DateTime.now().toIso8601String()
      }),
    );
    if (response.statusCode == 200) {
      print('Booking image updated successfully.');
    } else {
      print('Failed to update booking image. Error: ${response.statusCode}');
    }
  }
}

class CircularButton extends StatelessWidget {
  const CircularButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer green circle
        Container(
          width: 200, // Adjust size as needed
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        // Inner white circle
        Container(
          width: 140, // Adjust size as needed
          height: 140,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        // Arrow icon
        const Icon(
          Icons.chevron_right,
          size: 70, // Adjust size as needed
          color: Colors.green,
        ),
      ],
    );
  }
}
