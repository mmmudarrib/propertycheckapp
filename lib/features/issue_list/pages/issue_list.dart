import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:propertycheckapp/features/homepage/data/models/booking.dart';
import 'package:propertycheckapp/features/report_comments_page/pages/report_comments_page.dart';
import 'package:propertycheckapp/widgets/rounded_button_widget.dart';

import '../../../constants.dart';
import '../../rooms_list/pages/rooms_list.dart';
import '../bloc/booking_issue_bloc.dart';
import '../bloc/booking_issue_event.dart';
import '../bloc/booking_issue_state.dart';
import '../data/model/issue_list.dart';
import '../data/repo/booking_issue_repo.dart';

class IssueListPage extends StatefulWidget {
  final Booking booking;

  const IssueListPage({super.key, required this.booking});

  @override
  _IssueListPageState createState() => _IssueListPageState();
}

class _IssueListPageState extends State<IssueListPage> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IssueListBloc(
        repository: RepositoryProvider.of<BookingIssueRepository>(context),
      )..add(LoadIssues(widget.booking.id)),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          title: const Text('Issue List'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<IssueListBloc, IssueListState>(
            builder: (context, state) {
              if (state is IssueListLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is IssueListLoaded) {
                return _buildIssuesTable(context, state.issues);
              } else if (state is IssueListError) {
                return _buildIssuesTable(context, []);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIssuesTable(BuildContext context, List<Issue> issues) {
    List<Issue> filteredIssues = selectedCategory == null
        ? issues
        : issues
            .where((issue) => issue.issueCategory == selectedCategory)
            .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, issues),
          const SizedBox(height: 10.0),
          RoundedButton(
            text: "Add Issue",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomListPage(
                    booking: widget.booking,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20.0),
          (filteredIssues.isEmpty)
              ? const Center(
                  child: Text(
                    "No Issue Found",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(
                              label: Text(
                            'Room Type',
                            style: TextStyle(color: Colors.white),
                          )),
                          DataColumn(
                              label: Text(
                            'Issue Category',
                            style: TextStyle(color: Colors.white),
                          )),
                          DataColumn(
                              label: Text(
                            'Issue Subcategory',
                            style: TextStyle(color: Colors.white),
                          )),
                          DataColumn(
                              label: Text(
                            'Issue',
                            style: TextStyle(color: Colors.white),
                          )),
                        ],
                        rows: filteredIssues.map((issue) {
                          return DataRow(cells: [
                            DataCell(Text(
                              issue.roomType,
                              style: const TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              issue.issueCategory,
                              style: const TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              issue.issueSubCategory,
                              style: const TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              issue.issue,
                              style: const TextStyle(color: Colors.white),
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
          RoundedButton(
              color: Colors.red,
              text: "Complete Report",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportCommentsPage(
                      booking: widget.booking,
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<Issue> issues) {
    int issueCount = issues.length;
    Map<String, int> issueCountByCategory = {};
    for (var issue in issues) {
      issueCountByCategory[issue.issueCategory] =
          (issueCountByCategory[issue.issueCategory] ?? 0) + 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Inspection Issues',
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8.0),
        _buildOverviewCard(issueCount, issueCountByCategory)
      ],
    );
  }

  Widget _buildOverviewCard(
      int issueCount, Map<String, int> issueCountByCategory) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 200.0,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = null;
                  });
                },
                child: _buildOverviewItem('Total Issues\nFound',
                    issueCount.toString(), Icons.check_circle),
              ),
              ...issueCountByCategory.entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = entry.key;
                    });
                  },
                  child: _buildOverviewItem(
                    '${entry.key}\nIssues',
                    entry.value.toString(),
                    Icons.error,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String title, String count, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 30.0),
        const SizedBox(height: 8.0),
        Text(
          count,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
