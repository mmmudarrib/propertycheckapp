import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:propertycheckapp/features/issue_list/pages/issue_list_new.dart';
import 'package:propertycheckapp/features/login/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../homepage/data/models/booking.dart';
import '../../issue_list/data/model/booking_issue.dart';
import '../../rooms_list/pages/rooms_list.dart';

class AddIssueScreenNew extends StatefulWidget {
  final Booking booking;
  const AddIssueScreenNew({super.key, required this.booking});

  @override
  _AddIssueScreenNewState createState() => _AddIssueScreenNewState();
}

class _AddIssueScreenNewState extends State<AddIssueScreenNew> {
  final List<Map<String, dynamic>> _imagesWithNotes = [];
  final ImagePicker _picker = ImagePicker();

  final String baseUrl = 'https://ilovebackend.propertycheck.me/api/';

  // Dropdown values
  int? _bookingIssueId;
  Category? selectedCategory;
  Room? selectedrooms;
  Subcategory? selectedSubCategory;
  IssueType? selectedIssueType;
  String status = "Failed";
  List<Room> rooms = [];
  List<Category> categories = [];
  List<Subcategory> subcategories = [];
  List<IssueType> issueTypes = [];
  bool _loading = false;
  bool _isHighPriority = false;
  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    // Fetch rooms
    final roomResponse = await http.get(
      Uri.parse('$baseUrl/bookingroomtype/roomlist/${widget.booking.id}'),
    );

    if (roomResponse.statusCode != 200) {
      throw Exception('Failed to load rooms');
    }

    List<dynamic> roomListJson = jsonDecode(roomResponse.body);
    List<Room> roomList =
        roomListJson.map((json) => Room.fromJson(json)).toList();

    setState(() {
      rooms = roomList;
    });
    return;
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/category'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          categories =
              jsonResponse.map((json) => Category.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> fetchSubcategories(int categoryId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/subcategory'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          subcategories = jsonResponse
              .map((json) => Subcategory.fromJson(json))
              .where((sub) => sub.category.id == categoryId)
              .toList();
          selectedSubCategory = null;
          selectedIssueType = null;
        });
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> fetchIssueTypes(int subcategoryId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/issuetype'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          issueTypes = jsonResponse
              .map((json) => IssueType.fromJson(json))
              .where((issue) => issue.subcategory.id == subcategoryId)
              .toList();
          selectedIssueType = null;
        });
      } else {
        throw Exception('Failed to load issue types');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _pickImage(bool fromCamera) async {
    final XFile? pickedImage = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _imagesWithNotes.add({
          'image': pickedImage.path,
          'note': '',
        });
      });
    }
  }

  Widget _buildImageCard(int index, BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width) - 50,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        color: Colors.grey.shade900,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.file(
                File(_imagesWithNotes[index]['image']),
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.black,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'NOTES',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (value) {
                        setState(() => _imagesWithNotes[index]['note'] = value);
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Add Note...',
                        hintStyle: const TextStyle(color: Colors.black38),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: (_loading)
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100, // Adjust width as needed

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
                                      builder: (context) =>
                                          const LoginScreen()),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => IssueListNew(
                                                booking: widget.booking,
                                              )),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  // Use Flexible here instead of Expanded
                                  child: Text(
                                    "# ${widget.booking.id.toString()}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'GothamBlack',
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Handle overflow
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _imagesWithNotes.length + 1,
                          itemBuilder: (context, index) {
                            return index == _imagesWithNotes.length
                                ? GestureDetector(
                                    onTap: () =>
                                        _showImageSourceActionSheet(context),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        color: Colors.grey.shade800,
                                        child: const Icon(Icons.add_a_photo,
                                            color: Colors.white, size: 50),
                                      ),
                                    ),
                                  )
                                : _buildImageCard(index, context);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown<Room>(
                        title: 'Room',
                        value: selectedrooms,
                        items: rooms,
                        itemLabel: (item) => item.childRoomTypeName,
                        onChanged: (r) {
                          setState(() {
                            selectedrooms = r;
                            subcategories.clear();
                            issueTypes.clear();
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildDropdown<Category>(
                        title: 'Issue Category',
                        value: selectedCategory,
                        items: categories,
                        itemLabel: (item) => item.name,
                        onChanged: (category) {
                          setState(() {
                            selectedCategory = category;
                            subcategories.clear();
                            issueTypes.clear();
                          });
                          if (category != null) fetchSubcategories(category.id);
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildDropdown<Subcategory>(
                        title: 'Issue Subcategory',
                        value: selectedSubCategory,
                        items: subcategories,
                        itemLabel: (item) => item.name,
                        onChanged: (subcategory) {
                          setState(() {
                            selectedSubCategory = subcategory;
                            issueTypes.clear();
                          });
                          if (subcategory != null)
                            fetchIssueTypes(subcategory.id);
                        },
                      ),
                      const SizedBox(height: 8),
                      _buildDropdown<IssueType>(
                        title: 'Issue Type',
                        value: selectedIssueType,
                        items: issueTypes,
                        itemLabel: (item) => item.name,
                        onChanged: (issueType) {
                          setState(() => selectedIssueType = issueType);
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                status = "Failed";
                              });
                            },
                            child: Chip(
                              side: const BorderSide(color: Colors.red),
                              label: Row(
                                children: [
                                  Image.asset(
                                    status != "Failed"
                                        ? "assets/images/cancel-inactive.png"
                                        : "assets/images/cancel-active.png",
                                    width: 25,
                                    height: 25,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Failed',
                                    style: TextStyle(
                                      color: status == "Failed"
                                          ? Colors.red
                                          : const Color(0xffB7B7B7),
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: status != "Failed"
                                  ? Colors.black
                                  : Colors.red.withOpacity(0.1),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                status = "At Risk";
                              });
                            },
                            child: Chip(
                              side: const BorderSide(color: Colors.orange),
                              label: Row(
                                children: [
                                  Image.asset(
                                    status != "At Risk"
                                        ? "assets/images/risk-inactive.png"
                                        : "assets/images/risk-active.png",
                                    width: 25,
                                    height: 25,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'At Risk',
                                    style: TextStyle(
                                      color: status == "At Risk"
                                          ? Colors.orange
                                          : const Color(0xffB7B7B7),
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: status != "At Risk"
                                  ? Colors.black
                                  : Colors.orange.withOpacity(0.1),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                status = "Passed";
                              });
                            },
                            child: Chip(
                              side: const BorderSide(color: Colors.green),
                              label: Row(
                                children: [
                                  Image.asset(
                                    status != "Passed"
                                        ? "assets/images/pass-inactive.png"
                                        : "assets/images/passed-active.png",
                                    width: 25,
                                    height: 25,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Passed',
                                    style: TextStyle(
                                      color: status == "Passed"
                                          ? Colors.green
                                          : const Color(0xffB7B7B7),
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: status != "Passed"
                                  ? Colors.black
                                  : Colors.green.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isHighPriority = !_isHighPriority;
                          });
                        },
                        child: Chip(
                            side: BorderSide(
                                color: !_isHighPriority
                                    ? Colors.red
                                    : const Color.fromARGB(255, 201, 137, 137)),
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  !_isHighPriority
                                      ? "assets/images/priority-inactive.png"
                                      : "assets/images/priority-active.png",
                                  width: 25,
                                  height: 25,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'High Priority',
                                  style: TextStyle(
                                    color: _isHighPriority
                                        ? Colors.white
                                        : const Color(0xffB7B7B7),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: !_isHighPriority
                                ? Colors.black
                                : const Color(0xffEF4444)),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              {
                                final bool? result = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Reset Form'),
                                    content: const Text(
                                        'Are you sure you want to reset the form?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );

                                if (result == true) {
                                  setState(() {
                                    _imagesWithNotes.clear();
                                    selectedCategory = null;
                                    selectedSubCategory = null;
                                    selectedIssueType = null;
                                    subcategories.clear();
                                    issueTypes.clear();
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(40, 40),
                                backgroundColor: const Color(0xffFFD5D5)),
                            child: Image.asset(
                              "assets/images/delete.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _pickImage(true);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                backgroundColor: Colors.green),
                            child: Image.asset(
                              "assets/images/add-image.png",
                              width: 25,
                              height: 25,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _pickImage(false);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                backgroundColor: Colors.green),
                            child: Image.asset(
                              "assets/images/camera.png",
                              width: 25,
                              height: 25,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              print("Submit Issue button pressed");
                              setState(() {
                                _loading = true;
                              });
                              if (selectedCategory != null &&
                                  selectedSubCategory != null &&
                                  selectedIssueType != null &&
                                  _imagesWithNotes.isNotEmpty) {
                                _bookingIssueId = await _submitAnotherIssue();
                                if (_bookingIssueId != null) {
                                  await uploadImagesToFirebase();
                                }
                                setState(() {
                                  _loading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Issue record added successfully!')),
                                );

                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => IssueListNew(
                                            booking: widget.booking,
                                          )),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                backgroundColor: Colors.green),
                            child: Image.asset(
                              "assets/images/add-issue.png",
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String title,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            dropdownColor: Colors.grey.shade800,
            underline: const SizedBox(),
            hint: Text(title, style: const TextStyle(color: Colors.white70)),
            style: const TextStyle(color: Colors.white),
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(itemLabel(item)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Future<void> uploadImagesToFirebase() async {
    try {
      List<Map<String, String>> uploadedImages = [];
      for (int i = 0; i < _imagesWithNotes.length; i++) {
        File imageFile = File(_imagesWithNotes[i]['image']);
        String fileName =
            'uploads/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

        // Upload the file
        await FirebaseStorage.instance.ref(fileName).putFile(imageFile);

        // Get download URL
        String downloadUrl =
            await FirebaseStorage.instance.ref(fileName).getDownloadURL();
        uploadedImages.add({
          "bookingIssueId": _bookingIssueId.toString(),
          "issueImageUrl": downloadUrl,
          "notes": _imagesWithNotes[i]['note'] ?? '',
        });
        // Update notes or print download URL
        debugPrint('Uploaded Image URL: $downloadUrl');
      }
      await _submitImageUrlsWithNotes(uploadedImages);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Images uploaded successfully!')),
      );
    } catch (e) {
      debugPrint('Error uploading images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload images!')),
      );
    }
  }

  Future<int?> _submitAnotherIssue() async {
    const url = 'https://ilovebackend.propertycheck.me/api/bookingissue';
    final body = jsonEncode({
      "bookingId": widget.booking.id,
      "inspectorId": widget.booking.inspectorId,
      "issueTypeId": selectedIssueType?.id,
      "rtParentId": selectedrooms?.id.toString(),
      "rtChildId": selectedrooms?.childid.toString(),
      "issueDescription": "Issue Description",
      "severity": _isHighPriority ? 'high' : 'low',
      "status": status,
      "remarks": "remarks",
      "issueImage": "https://example.com/images/crack_wall.jpg"
    });

    print("Submitting another issue with data: $body");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print(
            "Another issue submitted successfully. Response ID: ${responseData['id']}");
        return responseData['id'];
      } else {
        print(
            "Failed to submit another issue. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("An error occurred while submitting another issue: $e");
    }
    return null;
  }

  Future<void> _submitImageUrlsWithNotes(
      List<Map<String, String>> uploadedImages) async {
    const url =
        'https://ilovebackend.propertycheck.me/api/bookingissueimage/bulk';
    final body = jsonEncode({"data": uploadedImages});
    debugPrint("Submitting uploaded images with data: $body");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Image URLs and notes submitted successfully.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Images and notes submitted successfully!')),
        );
      } else {
        debugPrint(
            "Failed to submit data. Status code: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit images and notes!')),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred!')),
      );
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
