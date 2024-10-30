import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../widgets/rounded_button_widget.dart';
import '../../dashboard/pages/dashboard.dart';
import '../../homepage/data/models/booking.dart';

class ReportCommentsPage extends StatefulWidget {
  final Booking booking;
  const ReportCommentsPage({super.key, required this.booking});

  @override
  State<ReportCommentsPage> createState() => _ReportCommentsPageState();
}

class _ReportCommentsPageState extends State<ReportCommentsPage> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Report Comments',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black, // Black background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align title to the left
            children: [
              // Title text
              const Text(
                'Report Comments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),

              Expanded(
                child: TextField(
                  controller: textEditingController,
                  textAlign: TextAlign.start,
                  maxLines: null, // Allows multi-line input
                  expands: true, // Expands to take available space
                  decoration: InputDecoration(
                    hintText: 'Enter your text here.',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style:
                      const TextStyle(color: Colors.white), // White text color
                  keyboardType: TextInputType.multiline,
                ),
              ),
              const SizedBox(height: 10.0),
              RoundedButton(
                  text: "Complete Report",
                  onPressed: () async {
                    await updateBookingStatus(widget.booking.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateBookingStatus(int bookingId) async {
    final url = Uri.parse(
        'https://ilovebackend.propertycheck.me/api/booking/attributes/$bookingId');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'bookingStatus': 'Completed',
        'finalRemarks': textEditingController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Booking status updated successfully.');
    } else {
      print('Failed to update booking status. Error: ${response.statusCode}');
    }
  }
}
