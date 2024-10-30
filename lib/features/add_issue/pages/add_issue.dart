import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:propertycheckapp/widgets/rounded_button_widget.dart';

import '../../homepage/data/models/booking.dart';
import '../../issue_list/pages/issue_list.dart';
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
  String _severity = 'Low'; // Default severity
  String _notes = '';
  String _issueStatus = 'Passed'; // Default issue status
  @override
  void initState() {
    super.initState();
    context.read<IssueFormBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
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
                      if (state is CategoriesLoaded ||
                          state is SubcategoriesLoaded ||
                          state is IssueTypesLoaded) {
                        setState(() {
                          if (state is CategoriesLoaded) {
                            _categories = state.categories;
                            _subcategories = [];
                            _selectedSubcategory = null;
                            _selectedSubcategoryId = null;
                            _selectedIssueType = null;
                            _selectedIssueTypeId = null;
                          } else if (state is SubcategoriesLoaded) {
                            _subcategories = state.subcategories;
                            _selectedIssueType = null;
                            _selectedIssueTypeId = null;
                          }
                        });
                      }
                    },
                    builder: (context, state) {
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
                    "Notes:",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    maxLines: 4,
                    onChanged: (value) {
                      setState(() {
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
                    items: ['Passed', 'On Risk', 'Failed'].map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status,
                            style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
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
                      if (_selectedCategory != null &&
                          _selectedSubcategory != null &&
                          _selectedIssueType != null &&
                          _notes.isNotEmpty) {
                        setState(() {
                          _loading = true;
                        });
                        await _submitIssue(
                            widget.booking.id,
                            "",
                            widget.bookingRoomType.id,
                            widget.bookingRoomType.childid,
                            int.parse(_selectedIssueTypeId ?? "0"),
                            _severity,
                            _issueStatus,
                            _notes,
                            widget.booking.inspectorId);
                        setState(() {
                          _loading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Issue record added successfully!')),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IssueListPage(
                              booking: widget.booking,
                            ),
                          ),
                        );
                      } else {
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

  Widget _buildCategoryDropdown(List<Category> categories) {
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
    return Text(
      'Error: $errorMessage',
      style: const TextStyle(color: Colors.red),
    );
  }

  Future<void> _submitIssue(
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

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        print("Issue submitted successfully.");
      } else {
        // Error handling
        print(
            "Failed to submit the issue. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("An error occurred while submitting the issue: $e");
    }
  }
}
