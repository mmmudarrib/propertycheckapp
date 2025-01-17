import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../../homepage/data/models/booking.dart';
import '../../visit_details/pages/visit_details_page_new.dart';
import '../bloc/booking_issue_bloc.dart';
import '../bloc/booking_issue_event.dart';
import '../bloc/booking_issue_state.dart';
import '../data/model/booking_issue.dart';
import '../data/repo/booking_issue_repo.dart';
import '../widgets/expandable_issues.dart';
import '../widgets/floating_action_button.dart';

class IssueListNew extends StatefulWidget {
  final Booking booking;

  const IssueListNew({super.key, required this.booking});

  @override
  State<IssueListNew> createState() => _IssueListNewState();
}

class _IssueListNewState extends State<IssueListNew> {
  int? selectedRoomId; // To track the selected ID
  int? selectedPriorityId; // To track the selected ID
  int? selectedCategoryId;
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
            child: BlocBuilder<IssueListBloc, IssueListState>(
              builder: (context, state) {
                if (state is IssueListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is IssueListLoaded) {
                  var filteredList = filterIssues(
                      state.issues, selectedRoomId, selectedCategoryId);

                  return _buildBody(context, filteredList);
                } else if (state is IssueListError) {
                  return _buildErrorState();
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: ExpandableFabMenu(booking: widget.booking),
        ),
      ),
    );
  }

  List<BookingIssue> filterIssues(
      List<BookingIssue> issues, int? selectedRoomId, int? selectedCategoryId) {
    return issues.where((issue) {
      final roomMatches =
          selectedRoomId == null || issue.childRoomType.id == selectedRoomId;
      final categoryMatches = selectedCategoryId == null ||
          issue.issueType.subcategory.category.id == selectedCategoryId;
      final priorityMatches = selectedPriorityId == null ||
          (selectedPriorityId == 1
              ? issue.severity.toLowerCase() == "high"
              : issue.severity.toLowerCase() != "high");
      return roomMatches && categoryMatches && priorityMatches;
    }).toList();
  }

  Widget _buildBody(BuildContext context, List<BookingIssue> issues) {
    final uniqueIssues = <int, Map<String, dynamic>>{};
    for (var issue in issues) {
      final id = issue.issueType.subcategory.category.id;
      final name = issue.issueType.subcategory.category.name;

      // Add to map if the ID is not already present
      if (!uniqueIssues.containsKey(id)) {
        uniqueIssues[id] = {"id": id, "name": name};
      }
    }

// Convert the Map values back to a List
    final uniqueIssuesList = uniqueIssues.values.toList();
    final uniqueRooms = <int, Map<String, dynamic>>{};
    for (var issue in issues) {
      final id = issue.childRoomType.id;
      final name = issue.childRoomType.name;

      // Add to map if the ID is not already present
      if (!uniqueRooms.containsKey(id)) {
        uniqueRooms[id] = {"id": id, "name": name};
      }
    }

// Convert the Map values back to a List
    final uniqueRoomsList = uniqueRooms.values.toList();

    List<Map<String, dynamic>> priority = [
      {"id": 1, "name": "High"},
      {"id": 2, "name": "Normal"}
    ];

    // Determine priority
    bool hasHigh = false;
    bool hasNormal = false;

    for (var issue in issues) {
      String severity = issue.severity.toLowerCase();
      if (severity == "high") {
        hasHigh = true;
      } else {
        hasNormal = true;
      }

      // If both High and Normal exist, break early
      if (hasHigh && hasNormal) {
        break;
      }
    }

    // Populate the priority list based on conditions
    List<Map<String, dynamic>> filteredPriority = [];
    if (hasHigh && hasNormal) {
      filteredPriority = [
        {"id": 2, "name": "Normal"},
        {"id": 1, "name": "High"}
      ];
    } else if (hasHigh) {
      filteredPriority = [
        {"id": 1, "name": "High"}
      ];
    } else if (hasNormal) {
      filteredPriority = [
        {"id": 2, "name": "Normal"}
      ];
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFF242424),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: Row(
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
                        // Use Flexible here instead of Expanded
                        child: Text(
                          "# ${widget.booking.id.toString()}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'GothamBlack',
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis, // Handle overflow
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => PropertyDetailPage(
                                  booking: widget.booking,
                                )),
                      );
                    },
                    child: Row(
                      children: [
                        const Text(
                          'Check Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Image.asset(
                          "assets/images/info.png",
                          width: 25,
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ExpandableIssuesWidget(
              issues: issues,
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "RECENT ISSUES CAPTURED",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'GothamBlack',
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Dropdown for "All"
                    buildDropdownButton(
                      label: "All",
                      items: uniqueIssuesList,
                      selectedId: selectedCategoryId,
                      onSelect: (id) {
                        setState(() {
                          selectedCategoryId = id; // Update the selected ID
                        });
                      },
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    buildDropdownButton(
                      label: "Priority",
                      items: filteredPriority,
                      selectedId: selectedPriorityId,
                      onSelect: (id) {
                        setState(() {
                          selectedPriorityId = id; // Update the selected ID
                        });
                      },
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    buildDropdownButton(
                      label: "Room",
                      items: uniqueRoomsList,
                      selectedId: selectedRoomId,
                      onSelect: (id) {
                        setState(() {
                          selectedRoomId = id; // Update the selected ID
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.70,
              child: ListView.builder(
                itemCount: issues.length,
                itemBuilder: (context, index) {
                  final issue = issues[index];
                  return _buildIssueCard(
                    issue.issueType.subcategory.category.name,
                    issue.issueType.subcategory.name,
                    issue.childRoomType.name,
                    issue.issueType.name,
                    issue.bookingIssueImages,
                    issue.status,
                    issue.severity,
                  );
                },
              ),
            ),
          ],
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

  Widget _buildIssueCard(
    String category,
    String subcategory,
    String roomType,
    String issue,
    List<IssueImage> bookingIssueImages,
    String status,
    String severity,
  ) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(12),
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: bookingIssueImages.isNotEmpty
                        ? bookingIssueImages.first.issueImageUrl
                        : "https://picsum.photos/200/300",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Row(
                    children: [
                      _buildTag(category),
                      const SizedBox(width: 8),
                      _buildTag(subcategory),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: _buildTag(roomType, darkBackground: true),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                (status == "Passed" || status.isEmpty)
                    ? const CustomChip(
                        icon: "assets/images/passed-active.png",
                        label: 'Passed',
                        backgroundColor: Color(0xFFE8F5E9),
                        textColor: Color(0xFF2E7D32),
                      )
                    : const CustomChip(
                        icon: "assets/images/cancel-active.png",
                        label: 'Failed',
                        backgroundColor: Color(0xFFFDE8E8),
                        textColor: Color(0xff9B1C1C),
                      ),
                const SizedBox(width: 8),
                if (severity.toLowerCase() == "high")
                  const CustomChip(
                    icon: "assets/images/priority-active.png",
                    label: 'High Priority',
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              issue,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'GothamBook',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, {bool darkBackground = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xff2E2E2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'GothamBold',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget buildDropdownButton({
    required String label,
    required List<Map<String, dynamic>> items,
    required int? selectedId,
    required void Function(int?) onSelect,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xff383838), // Background color of the dropdown
            borderRadius: BorderRadius.circular(100), // Rounded corners
            border: Border.all(color: const Color(0xff4F4F4F)), // Border color
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedId,
              items: [
                // Add the label as the first item
                DropdownMenuItem<int>(
                  value: null,
                  child: Text(
                    label,
                    style: const TextStyle(
                        color:
                            Color(0xffB7B7B7)), // Style the label differently
                  ),
                ),
                // Add the actual items from the list
                ...items.map((item) {
                  return DropdownMenuItem<int>(
                    value: item['id'],
                    child: Text(
                      item['name'],
                      style: const TextStyle(color: Color(0xffB7B7B7)),
                    ),
                  );
                }),
              ],
              onChanged: (value) {
                onSelect(
                    value); // Pass the selected value back through the callback
              },
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: Colors.grey[900], // Dropdown menu color
            ),
          ),
        );
      },
    );
  }
}

class CustomChip extends StatelessWidget {
  final String icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const CustomChip({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: 25,
            height: 25,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontFamily: 'GothamBold',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
