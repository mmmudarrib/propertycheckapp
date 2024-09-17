import 'package:flutter/material.dart';
import 'package:propertycheckapp/constants.dart';
import 'package:propertycheckapp/widgets/rounded_button_widget.dart';

import '../../start_inspection/start_inspection_page.dart';

class VisitDetailPage extends StatelessWidget {
  final String propertyName;
  final String scheduledDateTime;
  final String address;
  final int bedrooms;
  final int washrooms;
  final String propertyType;
  final String clientName;
  final String clientPhoneNumber;

  const VisitDetailPage({
    super.key,
    required this.propertyName,
    required this.scheduledDateTime,
    required this.address,
    required this.bedrooms,
    required this.washrooms,
    required this.propertyType,
    required this.clientName,
    required this.clientPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              propertyName,
              style: const TextStyle(
                fontSize: 24.0,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Scheduled: $scheduledDateTime',
              style: const TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(Icons.bed, '$bedrooms Bedrooms'),
                _buildDetailItem(Icons.home, propertyType),
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
                    address,
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.navigation),
                  color: AppColors.primaryColor,
                  onPressed: () {
                    // Handle navigation button press (e.g., open maps)
                  },
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            _buildMapPreview(),
            const SizedBox(height: 20.0),
            const Text(
              'Notes:',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8.0),
            _buildNotesSection(),
            const SizedBox(height: 20.0),
            _buildClientInfoSection(),
            const Spacer(),
            RoundedButton(
              text: "Take Main Door Photo",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StartInspectionScreen(),
                  ),
                );
              },
              color: AppColors.primaryColor,
            )
          ],
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

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: const Text(
        'No additional notes available.',
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
    );
  }

  Widget _buildClientInfoSection() {
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
          clientName,
          style: const TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        const SizedBox(height: 5.0),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.green),
              onPressed: () => _makePhoneCall(clientPhoneNumber),
            ),
            IconButton(
              icon: const Icon(Icons.message, color: Colors.green),
              onPressed: () => _openWhatsApp(clientPhoneNumber),
            ),
          ],
        ),
      ],
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
  }

  void _openWhatsApp(String phoneNumber) async {
    final Uri url = Uri.parse("https://wa.me/$phoneNumber");
  }
}
