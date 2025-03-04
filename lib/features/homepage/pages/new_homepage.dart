import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../issue_list/pages/issue_list_new.dart';
import '../../visit_details/pages/visit_details_page_new.dart';
import '../data/models/booking.dart';

class NewHomepage extends StatefulWidget {
  final String bookingStatus;
  List<Booking> bookingData = [];
  String? errorMessage;
  NewHomepage(
      {super.key,
      required this.bookingStatus,
      required this.bookingData,
      required this.errorMessage});

  @override
  State<NewHomepage> createState() => _NewHomepageState();
}

class _NewHomepageState extends State<NewHomepage> {
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    print("NewHomepage initialized.");
  }

  @override
  Widget build(BuildContext context) {
    print("Fetched bookings: ${widget.bookingStatus}");
    setState(() {
      bookings = widget.bookingData
          .where((b) => b.bookingStatus == widget.bookingStatus)
          .toList();
    });
    final dateFormatter = DateFormat('dd/MM/yyyy');
    print("Building NewHomepage UI...");
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<String, List<Booking>> plannedVisits = {
      "TODAY'S CHECKS (${dateFormatter.format(today)})": bookings
          .where((b) => isSameDate(DateTime.parse(b.visitDate), today))
          .toList(),
      "TOMORROW'S CHECKS (${dateFormatter.format(tomorrow)})": bookings
          .where((b) => isSameDate(DateTime.parse(b.visitDate), tomorrow))
          .toList(),
      "UPCOMING CHECKS": bookings
          .where((b) => DateTime.parse(b.visitDate).isAfter(tomorrow))
          .toList(),
    };

    print("Planned visits grouped: $plannedVisits");

    return Scaffold(
      backgroundColor: const Color(0xFF1D1D1B),
      body: widget.errorMessage != null
          ? Center(
              child: Text(
                widget.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "${widget.bookingStatus} Checks (${bookings.where((b) => DateTime.parse(b.visitDate).isAfter(yesterday)).toList().length})"
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'GothamBold',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: plannedVisits.entries.map((entry) {
                      print(
                          "Building section: \${entry.key} with visits: \${entry.value}");
                      return buildSection(entry.key, entry.value);
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }

  bool isSameDate(DateTime a, DateTime b) {
    final result = a.year == b.year && a.month == b.month && a.day == b.day;
    print("Comparing dates: \$a and \$b -> \$result");
    return result;
  }

  String formatDate(DateTime date) {
    const formattedDate = "\${date.day}/\${date.month}/\${date.year}";
    print("Formatted date: \$formattedDate");
    return formattedDate;
  }

  Widget buildSection(String title, List<Booking> visits) {
    print("Building section UI: \$title");
    return ExpansionTile(
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide.none, // Removes the border when collapsed
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide.none, // Removes the border when expanded
      ),
      iconColor: Colors.grey,
      backgroundColor: const Color(0xFF1D1D1B),
      collapsedBackgroundColor: const Color(0xFF1D1D1B),
      initiallyExpanded: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'GothamBlack',
          fontWeight: FontWeight.w500,
          color: Color(0xff888888),
        ),
      ),
      children: visits.isNotEmpty
          ? visits.map((visit) {
              print("Building visit card for: \${visit.title}");
              return buildVisitCard(visit);
            }).toList()
          : [
              buildEmptyMessage(),
            ],
    );
  }

  Widget buildVisitCard(Booking visit) {
    print("Building visit card for: $visit");
    return InkWell(
      onTap: () {
        if (widget.bookingStatus == 'In Progress') {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => IssueListNew(
                      booking: visit,
                    )),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => PropertyDetailPage(
                      booking: visit,
                    )),
          );
        }
      },
      child: Container(
        decoration: DottedDecoration(
            shape: Shape.box,
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff008138)),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        width: double.infinity,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "# ${visit.id}",
                      style: const TextStyle(
                        fontFamily: "GothamBook",
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          visit.visitSlot,
                          style: const TextStyle(
                            fontFamily: "GothamBook",
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat("d MMM, EEEE")
                              .format(DateTime.parse(visit.visitDate)),
                          style: const TextStyle(
                            fontFamily: "GothamBook",
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                (visit.mainDoorImage != null &&
                        widget.bookingStatus == 'In Progress')
                    ? Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.80, // Set the desired width
                            height: MediaQuery.of(context).size.width * 0.80,

                            /// Set the same height as width to make it square
                            child: CachedNetworkImage(
                              imageUrl: visit.mainDoorImage ?? "",
                              fit: BoxFit
                                  .cover, // Adjust this to control how the image fits in the square
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          if (widget.bookingStatus == 'In Progress')
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xff242424),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: Color(0xffFF8800),
                                      size: 10,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'In Progress',
                                      style: TextStyle(
                                        color: Color(0xff888888),
                                        fontSize: 14,
                                        fontFamily: "GothamBook",
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 8),
                Text(
                  "${visit.unit}, ${visit.community} ${visit.area} ",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: "GothamBook",
                    fontWeight: FontWeight.w400,
                  ),

                  maxLines: 2, // Set a maximum of two lines
                  overflow: TextOverflow
                      .ellipsis, // Add ellipsis (...) if the text exceeds two lines
                ),
                const SizedBox(height: 8),
                Text(
                  "Check Type: ${visit.checkType}".toUpperCase(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontFamily: "GothamBlack",
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmptyMessage() {
    print("Building empty message UI.");
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "No visits scheduled",
        style: TextStyle(
          color: Colors.grey,
          fontFamily: "GothamBook",
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
