import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:propertycheckapp/constants.dart';
import 'package:propertycheckapp/features/homepage/data/models/booking.dart';
import 'package:propertycheckapp/widgets/rounded_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../start_inspection/start_inspection_page.dart';

class VisitDetailPage extends StatelessWidget {
  final Booking booking;

  const VisitDetailPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(booking.visitDate));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: const Text(
          'Visit Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.clientName,
                style: const TextStyle(
                  fontSize: 24.0,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Scheduled: $formattedDate (${booking.visitSlot})',
                style: const TextStyle(fontSize: 18.0, color: Colors.grey),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailItem(
                      Icons.bed, '${booking.numberOfBedrooms} Bedrooms'),
                  _buildDetailItem(Icons.home, booking.community),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text('Address:',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${booking.area} ${booking.community}",
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                  const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Notes:',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8.0),
              _buildNotesSection(booking.specialInstruction),
              const SizedBox(height: 20.0),
              _buildClientInfoSection(context),
              if (booking.mainDoorImage != null) ...[
                const SizedBox(height: 20.0),
                const Text(
                  'Main Door Image:',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8.0),
                Image.network(
                  booking.mainDoorImage!,
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
              const SizedBox(height: 20.0),
              (booking.bookingStatus == "In Progress")
                  ? RoundedButton(
                      text: "Continue Inspection",
                      onPressed: () async {},
                      color: AppColors.primaryColor,
                    )
                  : RoundedButton(
                      text: "Take Main Door Photo",
                      onPressed: () async {
                        await updateBookingStatus(booking.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StartInspectionScreen(
                              booking: booking,
                            ),
                          ),
                        );
                      },
                      color: AppColors.primaryColor,
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 30.0),
        const SizedBox(height: 8.0),
        Text(
          text,
          style: const TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildMapPreview() {
    // This is a placeholder for a map preview
    return Container(
      height: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.grey[300],
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/300x150'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: IconButton(
          icon: const Icon(Icons.map, size: 40.0, color: Colors.blue),
          onPressed: () {
            // Handle map preview tap (e.g., open full map)
          },
        ),
      ),
    );
  }

  Widget _buildNotesSection(String notes) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        notes,
        style: const TextStyle(fontSize: 16.0, color: Colors.black),
      ),
    );
  }

  Widget _buildClientInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Client Information:',
          style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10.0),
        Text(
          booking.clientName,
          style: const TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        const SizedBox(height: 5.0),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.green),
              onPressed: () => _makePhoneCall(booking.clientContact, context),
            ),
            IconButton(
              icon: const Icon(Icons.message, color: Colors.green),
              onPressed: () => _openWhatsApp(booking.clientContact),
            ),
          ],
        ),
      ],
    );
  }

  void _makePhoneCall(String phoneNumber, BuildContext context) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not make the call to $phoneNumber'),
        ),
      );
    }
  }

  void _openWhatsApp(String phoneNumber) async {
    final Uri googleMapsUrl = Uri.parse("https://wa.me/$phoneNumber");
    try {
      bool canOpen = await canLaunchUrl(googleMapsUrl);
      if (canOpen) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to opening in browser if unable to launch Google Maps
        await launchUrl(googleMapsUrl,
            mode: LaunchMode.externalNonBrowserApplication);
      }
    } catch (e) {
      print("Error opening map: $e");
    }
  }

  void openMap(String? latitude, String? longitude) async {
    if (latitude == null || longitude == null) {
      throw 'Invalid coordinates provided.';
    }

    final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    try {
      bool canOpen = await canLaunchUrl(googleMapsUrl);
      if (canOpen) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to opening in browser if unable to launch Google Maps
        await launchUrl(googleMapsUrl, mode: LaunchMode.inAppWebView);
      }
    } catch (e) {
      print("Error opening map: $e");
    }
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
        'bookingStatus': 'In Progress',
      }),
    );

    if (response.statusCode == 200) {
      print('Booking status updated successfully.');
    } else {
      print('Failed to update booking status. Error: ${response.statusCode}');
    }
  }
}
