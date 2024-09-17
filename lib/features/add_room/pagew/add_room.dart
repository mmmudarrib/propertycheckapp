import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../widgets/rounded_button_widget.dart';
import '../../rooms_list/pages/rooms_list.dart';

class AddRoomPage extends StatefulWidget {
  const AddRoomPage({super.key});

  @override
  State<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  String? _selectedRoomCategory;
  String? _selectedRoomSubCategory;
  final List<String> roomTypes = [
    'Living Room',
    'Kitchen',
    'Bedroom',
    'Bathroom'
  ];
  final List<String> roomSubtypes = ['Ceiling', 'Wall', 'Floor', 'Sink'];
  @override
  Widget build(BuildContext context) {
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
              items: roomTypes,
              onChanged: (value) {
                setState(() {
                  _selectedRoomCategory = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            _buildDropdown(
              label: 'Room SubType',
              value: _selectedRoomSubCategory,
              items: roomSubtypes,
              onChanged: (value) {
                setState(() {
                  _selectedRoomSubCategory = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            RoundedButton(
                text: "Add New Room",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomListPage(),
                    ),
                  );
                })
          ],
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
}
