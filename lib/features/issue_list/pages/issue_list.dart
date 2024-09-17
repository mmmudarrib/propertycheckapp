import 'package:flutter/material.dart';
import 'package:propertycheckapp/features/report_comments_page/pages/report_comments_page.dart';
import 'package:propertycheckapp/features/rooms_list/pages/rooms_list.dart';
import 'package:propertycheckapp/widgets/rounded_button_widget.dart';

import '../../../constants.dart';

class IssueListPage extends StatelessWidget {
  const IssueListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final issues = [
      {
        'roomType': 'Living Room',
        'roomSubtype': 'Ceiling',
        'issueCategory': 'Structural',
        'issueSubCategory': 'Crack',
        'issue': 'Minor Crack on Ceiling',
      },
      {
        'roomType': 'Kitchen',
        'roomSubtype': 'Sink',
        'issueCategory': 'Plumbing',
        'issueSubCategory': 'Leakage',
        'issue': 'Leakage in Sink Pipe',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Issue List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, issues.length),
            const SizedBox(height: 10.0),
            RoundedButton(
                text: "Add Issue",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomListPage(),
                    ),
                  );
                }),
            const SizedBox(height: 20.0),
            Expanded(
              child: issues.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildIssuesTable(context, issues),
                      ),
                    )
                  : _buildEmptyState(),
            ),
            const SizedBox(height: 20.0),
            _buildFooterButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int issueCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Inspection Issues',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8.0),
        _buildOverviewCard()
      ],
    );
  }

  Widget _buildIssuesTable(
      BuildContext context, List<Map<String, String>> issues) {
    return DataTable(
      columns: const [
        DataColumn(
            label: Text('Room Type', style: TextStyle(color: Colors.white))),
        DataColumn(
            label: Text('Room Subtype', style: TextStyle(color: Colors.white))),
        DataColumn(
            label:
                Text('Issue Category', style: TextStyle(color: Colors.white))),
        DataColumn(
            label: Text('Issue Subcategory',
                style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Issue', style: TextStyle(color: Colors.white))),
        DataColumn(
            label: Text('Actions', style: TextStyle(color: Colors.white))),
      ],
      rows: issues.map((issue) {
        return DataRow(cells: [
          DataCell(Text(issue['roomType']!,
              style: const TextStyle(color: Colors.white))),
          DataCell(Text(issue['roomSubtype']!,
              style: const TextStyle(color: Colors.white))),
          DataCell(Text(issue['issueCategory']!,
              style: const TextStyle(color: Colors.white))),
          DataCell(Text(issue['issueSubCategory']!,
              style: const TextStyle(color: Colors.white))),
          DataCell(Text(issue['issue']!,
              style: const TextStyle(color: Colors.white))),
          DataCell(Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  // Navigate to Edit Issue screen
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Handle issue deletion
                },
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_late,
            color: Colors.grey,
            size: 80.0,
          ),
          SizedBox(height: 16.0),
          Text(
            'No issues found',
            style: TextStyle(fontSize: 24.0, color: Colors.grey),
          ),
          SizedBox(height: 8.0),
          Text(
            'Add issues to start inspecting the property.',
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: RoundedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportCommentsPage(),
                ),
              );
            },
            text: "Mark Complete",
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: RoundedButton(
            color: Colors.red,
            onPressed: () {
              // Sync report
            },
            text: "Sync Report",
          ),
        ),
      ],
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
            _buildOverviewItem('Rooms\nChecked', '2', Icons.schedule),
            _buildOverviewItem('Issues\nFound', '2', Icons.check_circle),
            _buildOverviewItem('Rooms\nRemaining', '1', Icons.pending),
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
}
