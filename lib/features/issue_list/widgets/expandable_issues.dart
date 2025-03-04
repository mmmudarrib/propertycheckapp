import 'package:flutter/material.dart';

import '../data/model/booking_issue.dart';

class ExpandableIssuesWidget extends StatefulWidget {
  final List<BookingIssue> issues;
  const ExpandableIssuesWidget({super.key, required this.issues});

  @override
  State<ExpandableIssuesWidget> createState() => _ExpandableIssuesWidgetState();
}

class _ExpandableIssuesWidgetState extends State<ExpandableIssuesWidget> {
  bool _isExpanded = false;
  List<IssueByCategory> issueCountByCat = [];

  int totalIssues = 0;
  int highPriorityIssues = 0;
  @override
  void initState() {
    getCountByCategory();
    super.initState();
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Issues Container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Image.asset(
                "assets/images/priority-active.png",
                width: 20,
                height: 20,
              ), // Icon
              const SizedBox(width: 8),
              Text(
                'Issues - $totalIssues',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontFamily: 'GothamBook',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xffFFD5D5), // Light red background
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Image.asset(
                "assets/images/priority-red.png",
                width: 20,
                height: 20,
              ), // Icon
              const SizedBox(width: 8),
              Text(
                'High Priority - $highPriorityIssues',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.red[900],
                  fontFamily: 'GothamBook',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem(IssueByCategory category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                category.category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'GothamBook',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Fixed width for the total count
              SizedBox(
                width: 24, // Adjust width based on expected number size
                child: Text(
                  category.total.toString(),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'GothamBold',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_rounded,
                      color: Colors.red, size: 18),
                  const SizedBox(width: 4),
                  // Fixed width for the high priority count
                  SizedBox(
                    width: 12, // Adjust width based on expected number size
                    child: Text(
                      category.high.toString(),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontFamily: 'GothamBold',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xff2E2E2E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade900, blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(
            height: 16,
          ),
          _isExpanded
              ? Column(
                  children: issueCountByCat
                      .map((category) => _buildItem(category))
                      .toList(),
                )
              : const SizedBox.shrink(),
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? "COLLAPSE" : "EXPAND",
              style: const TextStyle(
                fontFamily: 'GothamBold',
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getCountByCategory() {
    for (var issue in widget.issues) {
      totalIssues = totalIssues + 1;
      if (issue.severity == 'high') {
        highPriorityIssues = highPriorityIssues + 1;
      }
      // Find if the category already exists in the issueList
      var existingIssue = issueCountByCat.firstWhere(
        (item) => item.category.id == issue.issueType.subcategory.category.id,
        orElse: () => IssueByCategory(
          category: issue.issueType.subcategory.category,
          total: 0,
          high: 0,
        ),
      );

      if (existingIssue.total == 0) {
        issueCountByCat.add(existingIssue..total = 1);
        if (issue.severity == 'high') {
          existingIssue.high += 1;
        }
      } else {
        if (issue.severity == 'high') {
          existingIssue.high += 1;
        }
        existingIssue.total += 1;
      }
    }
  }
}

class IssueByCategory {
  Category category;
  int total;
  int high;

  IssueByCategory(
      {required this.category, required this.total, required this.high});
}
