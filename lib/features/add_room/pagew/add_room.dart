import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:propertycheckapp/features/homepage/data/models/booking.dart';

import '../../../constants.dart';
import '../../../widgets/rounded_button_widget.dart';
import '../../rooms_list/pages/rooms_list.dart';

class AddRoomPage extends StatefulWidget {
  final Booking booking;
  const AddRoomPage({super.key, required this.booking});

  @override
  State<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  String? _selectedRoomCategory;
  String? _selectedRoomSubCategory;
  Map<String, dynamic> roomTypes = {};
  List<dynamic> roomSubtypes = [];

  @override
  void initState() {
    _fetchRoomTypes();
    super.initState();
  }

  Future<void> _fetchRoomTypes() async {
    final response = await http.get(Uri.parse(
        'https://ilovebackend.propertycheck.me/api/roomtype/propertyType/${widget.booking.bookingChildPropertytype}'));

    if (response.statusCode == 200) {
      setState(() {
        roomTypes = json.decode(response.body);
      });
    } else {
      // Handle error
      print('Failed to load room types');
    }
  }

  void _onRoomCategoryChanged(String? value) {
    setState(() {
      _selectedRoomCategory = value;
      _selectedRoomSubCategory = null;
      roomSubtypes = roomTypes[value]?['children'] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final Booking booking = widget.booking;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Add New Room',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDropdown(
              label: 'Room Type',
              value: _selectedRoomCategory,
              items: roomTypes.keys
                  .map((key) => DropdownMenuItem<String>(
                      value: key,
                      child: Text(roomTypes[key]['parentName'],
                          style: const TextStyle(color: Colors.white))))
                  .toList(),
              onChanged: _onRoomCategoryChanged,
            ),
            const SizedBox(height: 16.0),
            _buildDropdown(
              label: 'Room SubType',
              value: _selectedRoomSubCategory,
              items: roomSubtypes
                  .map((key) => DropdownMenuItem<String>(
                        value: key['id'].toString(),
                        child: Text(key['name'] ?? "",
                            style: const TextStyle(color: Colors.white)),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRoomSubCategory = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            RoundedButton(
                text: "Add New Room",
                onPressed: () async {
                  if (_selectedRoomCategory != null &&
                      _selectedRoomSubCategory != null) {
                    final parentId = int.parse(_selectedRoomCategory!);
                    final childId = int.parse(_selectedRoomSubCategory!);
                    final requestBody = {
                      "brtParentId": parentId,
                      "roomtypeId": 2,
                      "brtChildId": childId,
                      "bookingId": booking.id,
                    };

                    final response = await http.post(
                      Uri.parse(
                          'https://ilovebackend.propertycheck.me/api/bookingroomtype'),
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode(requestBody),
                    );

                    if (response.statusCode == 201) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomListPage(booking: booking),
                        ),
                      );
                    } else {
                      // Handle error
                      print('Failed to add room');
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Please select all values correctly',
                            style: TextStyle(color: Colors.white)),
                        duration: Duration(
                            milliseconds:
                                1000), // How long the snackbar will be visible
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
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
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(),
          ),
          items: items,
          onChanged: onChanged,
          hint: Text(
            'Select $label',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
