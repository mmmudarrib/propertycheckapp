import 'package:flutter/material.dart';
import 'package:propertycheckapp/constants.dart';
import 'package:propertycheckapp/features/visit_details/pages/visit_details_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCard(),
          const SizedBox(height: 20.0),
          const Text(
            'Planned Visits',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10.0),
          _buildPlannedVisitsList(context),
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildOverviewItem('Planned', '2', Icons.schedule),
            _buildOverviewItem('Completed', '2', Icons.check_circle),
            _buildOverviewItem('In Progress', '1', Icons.pending),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String title, String count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30.0),
        const SizedBox(height: 8.0),
        Text(
          count,
          style: const TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPlannedVisitsList(BuildContext context) {
    final List<Map<String, String>> visits = [
      {
        'propertyName': '3 Bedroom Appartment',
        'address': '789 Creek Lane, Dubai',
        'time': '2:00 PM',
        'bedrooms': '3',
        'baths': '2',
        'client': 'Ahmed Khan',
        'status': 'In Progress',
        'propertyType': 'Appartment'
      },
      {
        'propertyName': '5 Bedroom Duplex Villa',
        'address': '123 Palm Street, Dubai',
        'time': '10:00 AM',
        'bedrooms': '5',
        'baths': '2',
        'client': 'John Doe',
        'status': 'Planned',
        'propertyType': 'Villa'
      },
      {
        'propertyName': 'Sea Facing Beach Villa',
        'address': '456 Marina Road, Dubai',
        'time': '12:00 PM',
        'bedrooms': '6',
        'baths': '4',
        'client': 'Jane Smith',
        'status': 'Planned',
        'propertyType': 'Villa'
      },
      {
        'propertyName': '5 Bedroom Duplex Appartment',
        'address': '456 Marina Road, Dubai',
        'time': '12:00 PM',
        'bedrooms': '5',
        'baths': '2',
        'client': 'Jane Smith',
        'status': 'Completed',
        'propertyType': 'Appartment'
      },
      {
        'propertyName': '2 Bedroom Appartment',
        'address': '456 Marina Road, Dubai',
        'time': '12:00 PM',
        'bedrooms': '2',
        'baths': '2',
        'client': 'Jane Smith',
        'status': 'Completed',
        'propertyType': 'Appartment'
      },
    ];

    return Column(
      children: visits.map((visit) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VisitDetailPage(
                  propertyName: visit['propertyName'] ?? 'Default Property',
                  scheduledDateTime: visit['time'] ?? 'Unknown Time',
                  address: visit['address'] ?? 'Unknown Address',
                  bedrooms: int.parse(visit['bedrooms'] ?? '0'),
                  washrooms: int.parse(visit['baths'] ?? '0'),
                  propertyType: visit['propertyType'] ?? 'Unknown Type',
                  clientName: visit['client'] ?? 'Unknown',
                  clientPhoneNumber: visit['clientPhone'] ?? 'Unknown',
                ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              title: Text(
                visit['address']!,
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                '${visit['time']} - ${visit['client']}',
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: Text(
                visit['status']!,
                style: TextStyle(
                  color: visit['status'] == 'In Progress'
                      ? Colors.orange
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
