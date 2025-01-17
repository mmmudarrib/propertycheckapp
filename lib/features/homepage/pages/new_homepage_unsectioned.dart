import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/models/booking.dart';

class NewHomepageUnSectioned extends StatefulWidget {
  final String bookingStatus;
  final List<Booking> bookingData;
  final String? errorMessage;
  const NewHomepageUnSectioned(
      {super.key,
      required this.bookingStatus,
      required this.errorMessage,
      required this.bookingData});

  @override
  State<NewHomepageUnSectioned> createState() => _NewHomepageUnSectionedState();
}

class _NewHomepageUnSectionedState extends State<NewHomepageUnSectioned> {
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Fetched bookings: ${widget.bookingStatus}");
    if (widget.bookingStatus != 'Planned') {
      setState(() {
        bookings = widget.bookingData
            .where((b) => b.bookingStatus == widget.bookingStatus)
            .toList();
      });
    }
    print("Building NewHomepage UI...");
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "${widget.bookingStatus} (${bookings.length})"
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'GothamBold',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                bookings.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView(
                            children: bookings.map((entry) {
                              return buildVisitCard(entry);
                            }).toList(),
                          ),
                        ),
                      )
                    : buildEmptyMessage(),
              ],
            ),
    );
  }

  String formatDate(DateTime date) {
    var formattedDate = "${date.day}${date.month}${date.year}";
    print("Formatted date: $formattedDate");
    return formattedDate;
  }

  Widget buildVisitCard(Booking visit) {
    print("Building visit card for: $visit");
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
                color: Colors.green, width: 1.0), // Green solid border
          ),
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                          DateFormat("d MMM, EEEE")
                              .format(DateTime.parse(visit.visitDate)),
                          style: const TextStyle(
                            fontFamily: "GothamBook",
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 16,
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
                                        fontWeight: FontWeight.bold,
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
                  visit.area,
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
