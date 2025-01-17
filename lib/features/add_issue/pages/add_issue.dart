import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:propertycheckapp/widgets/rounded_button_widget.dart';

import '../../homepage/data/models/booking.dart';
import '../../rooms_list/pages/rooms_list.dart';
import '../bloc/booking_issue_bloc.dart';
import '../bloc/booking_issue_event.dart';
import '../bloc/booking_issue_states.dart';
import '../data/models/category_model.dart';
import '../data/models/subcategory_model.dart';
import '../data/repo/issue_repo.dart';

class AddIssuePage extends StatefulWidget {
  final Booking booking;
  final Room bookingRoomType;
  final IssueRepository repository;

  const AddIssuePage(
      {super.key,
      required this.booking,
      required this.bookingRoomType,
      required this.repository});

  @override
  _AddIssuePageState createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  String? _selectedCategory;
  String? _selectedCategoryId;
  String? _selectedSubcategory;
  String? _selectedSubcategoryId;
  String? _selectedIssueType;
  String? _selectedIssueTypeId;
  List<Category> _categories = [];
  List<Subcategory> _subcategories = [];
  bool _loading = false;
  final List<bool> _selections = [
    true,
    false,
    false
  ]; // Initial state: Passed selected
  int _currentIndex = 0;
  final ImagePicker _picker = ImagePicker();
  List<String> imageUrls = [];
  Map<String, String> imageNotes =
      {}; // Use a map to associate each image URL with its note
  String _severity = 'Low'; // Default severity
  String _notes = '';
  String _issueStatus = 'Passed'; // Default issue status
  int? _bookingIssueId;
  @override
  void initState() {
    super.initState();
    print("Init State called, loading categories");
    context.read<IssueFormBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    print("Building AddIssuePage widget");
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Add Issue'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: (_loading)
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                    text: "Add Images",
                    onPressed: _captureImageFromCamera,
                  ),
                  const SizedBox(height: 16.0),
                  _buildImageNotesSection(), // Add image notes section
                  const SizedBox(height: 32.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Room Category:",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        widget.bookingRoomType.roomTypeName ?? "",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  BlocConsumer<IssueFormBloc, IssueFormState>(
                    listener: (context, state) {
                      print("BlocConsumer Listener state: \$state");
                      if (state is CategoriesLoaded ||
                          state is SubcategoriesLoaded ||
                          state is IssueTypesLoaded) {
                        setState(() {
                          if (state is CategoriesLoaded) {
                            print(
                                "Categories loaded: \${state.categories.length}");
                            _categories = state.categories;
                            _subcategories = [];
                            _selectedSubcategory = null;
                            _selectedSubcategoryId = null;
                            _selectedIssueType = null;
                            _selectedIssueTypeId = null;
                          } else if (state is SubcategoriesLoaded) {
                            print(
                                "Subcategories loaded: \${state.subcategories.length}");
                            _subcategories = state.subcategories;
                            _selectedIssueType = null;
                            _selectedIssueTypeId = null;
                          }
                        });
                      }
                    },
                    builder: (context, state) {
                      print("BlocConsumer Builder state: \$state");
                      if (state is IssueFormLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CategoriesLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCategoryDropdown(_categories),
                          ],
                        );
                      } else if (state is SubcategoriesLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCategoryDropdown(_categories),
                            const SizedBox(height: 16.0),
                            _buildSubcategoryDropdown(_subcategories),
                          ],
                        );
                      } else if (state is IssueTypesLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCategoryDropdown(_categories),
                            const SizedBox(height: 16.0),
                            _buildSubcategoryDropdown(_subcategories),
                            const SizedBox(height: 16.0),
                            _buildIssueTypeDropdown(state),
                          ],
                        );
                      } else if (state is IssueFormError) {
                        print("Error loading form: \${state.errorMessage}");
                        return _buildErrorText(state.errorMessage);
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 32.0),
                  const Text(
                    "Severity:",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: _severity,
                    items: ['Low', 'Medium', 'High'].map((severity) {
                      return DropdownMenuItem(
                        value: severity,
                        child: Text(severity,
                            style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        print("Severity selected: \$value");
                        _severity = value ?? 'Low';
                      });
                    },
                    hint: const Text("Select Severity",
                        style: TextStyle(color: Colors.white)),
                    dropdownColor: Colors.black,
                    decoration: const InputDecoration(
                      labelText: 'Severity',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  const Text(
                    "Description:",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    maxLines: 4,
                    onChanged: (value) {
                      setState(() {
                        print("Notes updated: \$value");
                        _notes = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  const Text(
                    "Issue Status:",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: _issueStatus,
                    items: ['Passed', 'At Risk', 'Failed'].map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status,
                            style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        print("Issue Status selected: \$value");
                        _issueStatus = value ?? 'Passed';
                      });
                    },
                    hint: const Text("Select Issue Status",
                        style: TextStyle(color: Colors.white)),
                    dropdownColor: Colors.black,
                    decoration: const InputDecoration(
                      labelText: 'Issue Status',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  RoundedButton(
                    text: "Submit Issue",
                    onPressed: () async {
                      print("Submit Issue button pressed");
                      if (_selectedCategory != null &&
                          _selectedSubcategory != null &&
                          _selectedIssueType != null &&
                          _notes.isNotEmpty) {
                        setState(() {
                          _loading = true;
                        });
                        _bookingIssueId = await _submitIssue(
                            widget.booking.id,
                            "",
                            widget.bookingRoomType.id,
                            widget.bookingRoomType.childid,
                            int.parse(_selectedIssueTypeId ?? "0"),
                            _severity,
                            _issueStatus,
                            _notes,
                            widget.booking.inspectorId);
                        if (_bookingIssueId != null) {
                          await _uploadAllImages();
                        }
                        setState(() {
                          _loading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Issue record added successfully!')),
                        );
                      } else {
                        print("Validation failed: Missing required fields");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Please fill in all required fields.')),
                        );
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _selectImageFromGallery() async {
    print("Selecting image from gallery");
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        print("Image selected: \${image.path}");
        imageUrls.add(image.path);
        imageNotes[image.path] =
            ''; // Initialize an empty note for the new image
      });
    }
  }

  Future<void> _captureImageFromCamera() async {
    print("Capturing image from camera");
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        print("Image captured: \${image.path}");
        imageUrls.add(image.path);
        imageNotes[image.path] =
            ''; // Initialize an empty note for the new image
      });
    }
  }

  Widget _buildImageCarousel() {
    print("Building image carousel");
    return CarouselSlider(
      items: imageUrls.map((url) {
        return Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  File(url),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 200,
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                maxLines: 1,
                onChanged: (value) {
                  setState(() {
                    print("Note for image updated: \$value");
                    imageNotes[url] = value;
                  });
                },
                decoration: InputDecoration(
                  hintTextDirection: TextDirection.ltr,
                  hintText: "Enter Description for this image",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: imageNotes[url] ?? '',
                    selection: TextSelection.collapsed(
                      offset: imageNotes[url]?.length ?? 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 300.0,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          setState(() {
            print("Carousel page changed: index=\$index, reason=\$reason");
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildImageNotesSection() {
    print("Building image notes section");
    return imageUrls.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Image Description:",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              ...List.generate(imageUrls.length, (index) {
                String url = imageUrls[index];
                return Column(
                  children: [
                    TextField(
                      maxLines: 2,
                      onChanged: (value) {
                        setState(() {
                          print("Note for image ${index + 1} updated: \$value");
                          imageNotes[url] = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintTextDirection: TextDirection.ltr,
                        hintText: "Enter Description for image ${index + 1}",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: imageNotes[url] ?? '',
                          selection: TextSelection.collapsed(
                            offset: imageNotes[url]?.length ?? 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                );
              }),
            ],
          )
        : Container();
  }

  Widget _buildCategoryDropdown(List<Category> categories) {
    print("Building category dropdown");
    return DropdownButtonFormField<String>(
      value: _selectedCategoryId,
      items: categories.map((category) {
        return DropdownMenuItem(
          value: category.id.toString(),
          child:
              Text(category.name, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          print("Category selected: \${value}");
          _selectedCategoryId = value;
          _selectedCategory = categories
              .firstWhere((category) => category.id.toString() == value)
              .name;
          _selectedSubcategory = null;
          _selectedSubcategoryId = null;
          _selectedIssueType = null;
          _selectedIssueTypeId = null;
        });
        context.read<IssueFormBloc>().add(LoadSubcategories(
            categoryId: int.tryParse(_selectedCategoryId!) ?? 0));
      },
      hint:
          const Text("Select Category", style: TextStyle(color: Colors.white)),
      dropdownColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Issue Category',
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSubcategoryDropdown(List<Subcategory> subcategories) {
    print("Building subcategory dropdown");
    return DropdownButtonFormField<String>(
      value: _selectedSubcategoryId,
      items: subcategories.map((subcategory) {
        return DropdownMenuItem(
          value: subcategory.id.toString(),
          child: Text(subcategory.name,
              style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          print("Subcategory selected: \${value}");
          _selectedSubcategoryId = value;
          _selectedSubcategory = subcategories
              .firstWhere((subcategory) => subcategory.id.toString() == value)
              .name;
          _selectedIssueType = null;
          _selectedIssueTypeId = null;
        });
        context.read<IssueFormBloc>().add(
            LoadIssueTypes(subcategoryId: int.parse(_selectedSubcategoryId!)));
      },
      hint: const Text("Select Subcategory",
          style: TextStyle(color: Colors.white)),
      dropdownColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Issue Subcategory',
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildIssueTypeDropdown(IssueTypesLoaded state) {
    print("Building issue type dropdown");
    return DropdownButtonFormField<String>(
      value: _selectedIssueTypeId,
      items: state.issueTypes.map((issueType) {
        return DropdownMenuItem(
          value: issueType.id.toString(),
          child:
              Text(issueType.name, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          print("Issue type selected: \${value}");
          _selectedIssueTypeId = value;
          _selectedIssueType = state.issueTypes
              .firstWhere((issueType) => issueType.id.toString() == value)
              .name;
        });
      },
      hint: const Text("Select Issue Type",
          style: TextStyle(color: Colors.white)),
      dropdownColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Issue Type',
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildErrorText(String errorMessage) {
    print("Building error text widget with message: \$errorMessage");
    return Text(
      'Error: $errorMessage',
      style: const TextStyle(color: Colors.red),
    );
  }

  Future<int?> _submitIssue(
      int bookingId,
      String desc,
      int roompt,
      int roomch,
      int issuetype,
      String severity,
      String status,
      String remarks,
      int inspectorid) async {
    const url = 'https://ilovebackend.propertycheck.me/api/bookingissue';
    final body = jsonEncode({
      "bookingId": bookingId,
      "inspectorId": inspectorid,
      "issueTypeId": issuetype,
      "rtParentId": roompt,
      "rtChildId": roomch,
      "issueDescription": desc,
      "severity": severity,
      "status": status,
      "remarks": remarks,
      "issueImage": "https://example.com/images/crack_wall.jpg"
    });

    print("Submitting issue with data: \$body");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print(
            "Issue submitted successfully. Response ID: \${responseData['id']}");
        return responseData['id'];
      } else {
        print(
            "Failed to submit the issue. Status code: \${response.statusCode}");
      }
    } catch (e) {
      print("An error occurred while submitting the issue: $e");
    }
    return null;
  }

  Future<void> _uploadAllImages() async {
    print("Uploading all images to Firebase");
    List<Map<String, String>> uploadedImages = [];
    for (String imagePath in imageUrls) {
      try {
        final random = Random();
        String fileName =
            '${random.nextInt(1000000)}${path.extension(imagePath)}';

        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('uploads/$fileName');

        UploadTask uploadTask = firebaseStorageRef.putFile(File(imagePath));
        TaskSnapshot taskSnapshot = await uploadTask;

        String downloadURL = await taskSnapshot.ref.getDownloadURL();
        print("Image uploaded successfully. URL: \$downloadURL");
        uploadedImages.add({
          "bookingIssueId": _bookingIssueId.toString(),
          "issueImageUrl": downloadURL,
          "notes": imageNotes[imagePath] ?? '',
        });
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to upload one or more images.'),
        ));
      }
    }

    if (uploadedImages.isNotEmpty) {
      await _submitImageUrls(uploadedImages);
    }
  }

  Future<void> _submitImageUrls(
      List<Map<String, String>> uploadedImages) async {
    const url =
        'https://ilovebackend.propertycheck.me/api/bookingissueimage/bulk';
    final body = jsonEncode({"data": uploadedImages});

    print("Submitting uploaded images with data: \$body");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Image URLs submitted successfully.");
      } else {
        print(
            "Failed to submit image URLs. Status code: \${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }

  
}
