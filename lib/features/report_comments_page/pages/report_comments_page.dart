import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:http/http.dart' as http;
import 'package:propertycheckapp/features/dashboard/pages/dashboard.dart';

import '../../homepage/data/models/booking.dart';
import '../../issue_list/bloc/booking_issue_bloc.dart';
import '../../issue_list/bloc/booking_issue_event.dart';
import '../../issue_list/bloc/booking_issue_state.dart';
import '../../issue_list/data/model/booking_issue.dart';
import '../../issue_list/data/repo/booking_issue_repo.dart';
import '../../issue_list/widgets/expandable_issues.dart';

class ReportCommentsPage extends StatefulWidget {
  final Booking booking;
  const ReportCommentsPage({super.key, required this.booking});

  @override
  State<ReportCommentsPage> createState() => _ReportCommentsPageState();
}

class _ReportCommentsPageState extends State<ReportCommentsPage> {
  final TextEditingController textEditingController = TextEditingController();
  bool isLoading = false; // Tracks API call loading state

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IssueListBloc(
        repository: RepositoryProvider.of<BookingIssueRepository>(context),
      )..add(LoadIssues(widget.booking.id)),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF1D1D1B),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: (isLoading)
                ? const Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.green,
                    ),
                  )
                : BlocBuilder<IssueListBloc, IssueListState>(
                    builder: (context, state) {
                      if (state is IssueListLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is IssueListLoaded) {
                        return _buildBody(context, state.issues);
                      } else if (state is IssueListError) {
                        return _buildErrorState();
                      }
                      return const SizedBox.shrink();
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return const Center(
      child: Text(
        "Failed to load issues. Please try again later.",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  SingleChildScrollView _buildBody(
      BuildContext context, List<BookingIssue> issues) {
    List<IssueSummary> bookingIssues = groupIssuesByType(issues);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align title to the left
        children: [
          Container(
            color: const Color(0xFF242424),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100, // Adjust width as needed
                  height: 50, // Adjust height as needed
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const Icon(
                  Icons.power_settings_new,
                  color: Color(0xff686866),
                  size: 20, // Adjust size as needed
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Text(
                  "# ${widget.booking.id.toString()}",
                  style: const TextStyle(
                    fontFamily: 'GothamBlack',
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  overflow: TextOverflow.ellipsis, // Handle overflow
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ExpandableIssuesWidget(
            issues: issues,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff41F690), width: 2),
                color: const Color(0xffDBFFEA), // Light green background
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.40,
                child: ListView.builder(
                  itemCount: bookingIssues.length,
                  itemBuilder: (context, index) {
                    final issue = bookingIssues[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issue.issueTypeName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'GothamBook',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...issue.issueDescriptions.map(
                          (desc) => Text(
                            '- $desc',
                            style: const TextStyle(
                              fontFamily: 'GothamBook',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 64),
          SizedBox(
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SwipeButton.expand(
                  thumb: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                  activeThumbColor: const Color(0xffEF4444),
                  activeTrackColor: const Color(0xffFFD5D5),
                  inactiveThumbColor: Colors.redAccent,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "SWIPE TO COMPLETE CHECK",
                      style: TextStyle(
                        fontFamily: 'GothamBold',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xffEF4444),
                      ),
                    ),
                  ),
                  onSwipe: () async {
                    await updateBookingStatus(widget.booking.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashboardScreen()),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<IssueSummary> groupIssuesByType(List<BookingIssue> issues) {
    // Use a map to group issues by issueTypeId and issueTypeName
    final Map<int, IssueSummary> groupedIssues = {};

    for (var issue in issues) {
      if (groupedIssues.containsKey(issue.issueType.subcategory.category.id)) {
        groupedIssues[issue.issueType.subcategory.category.id]!
            .issueDescriptions
            .add(issue.issueDescription);
      } else {
        groupedIssues[issue.issueTypeId] = IssueSummary(
          issueTypeId: issue.issueType.subcategory.category.id,
          issueTypeName: issue.issueType.subcategory.category.name,
          issueDescriptions: [issue.issueType.name],
        );
      }
    }

    return groupedIssues.values.toList();
  }

  Future<bool> updateBookingStatus(int bookingId) async {
    final url = Uri.parse(
        'https://ilovebackend.propertycheck.me/api/booking/attributes/$bookingId');

    try {
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
        return true;
      } else {
        print('Failed to update booking status. Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to update booking. Error: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      print('Exception during API call: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }
}

class IssueSummary {
  final int issueTypeId;
  final String issueTypeName;
  final List<String> issueDescriptions;

  IssueSummary({
    required this.issueTypeId,
    required this.issueTypeName,
    required this.issueDescriptions,
  });
}
