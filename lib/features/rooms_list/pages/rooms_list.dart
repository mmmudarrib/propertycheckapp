import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:propertycheckapp/features/add_room/pagew/add_room.dart';
import 'package:propertycheckapp/features/homepage/data/models/booking.dart';
import 'package:propertycheckapp/features/issue_list/pages/issue_list_new.dart';
import 'package:propertycheckapp/features/login/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomListPage extends StatefulWidget {
  final Booking booking;

  const RoomListPage({super.key, required this.booking});

  @override
  _RoomListPageState createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  late Future<List<Room>> _rooms;

  @override
  void initState() {
    super.initState();
    _rooms = fetchRooms();
  }

  Future<List<Room>> fetchRooms() async {
    try {
      // Fetch rooms
      final roomResponse = await http.get(
        Uri.parse(
            'https://ilovebackend.propertycheck.me/api/bookingroomtype/roomlist/${widget.booking.id}'),
      );

      if (roomResponse.statusCode != 200) {
        throw Exception('Failed to load rooms');
      }

      List<dynamic> roomListJson = jsonDecode(roomResponse.body);
      List<Room> rooms =
          roomListJson.map((json) => Room.fromJson(json)).toList();

      // Fetch issues for the booking
      final issueResponse = await http.get(
        Uri.parse(
            'https://ilovebackend.propertycheck.me/api/bookingissue/bookingId/${widget.booking.id}'),
      );

      if (issueResponse.statusCode == 200) {
        List<dynamic> issueListJson = jsonDecode(issueResponse.body);
        List<RoomIssue> issues =
            issueListJson.map((json) => RoomIssue.fromJson(json)).toList();

        // Map the issues to each room based on rtParentId and rtChildId
        for (var room in rooms) {
          room.issueCount = issues
              .where((issue) =>
                  issue.rtParentId == room.id &&
                  issue.rtChildId == room.childid)
              .length;
          room.highPriorityCount = issues
              .where((issue) =>
                  issue.rtParentId == room.id &&
                  issue.rtChildId == room.childid &&
                  issue.severity == 'high')
              .length;
        }
      }

      return rooms;
    } catch (e) {
      // Log the error and rethrow for the FutureBuilder to catch
      print(e);
      throw Exception('Error fetching rooms or issues: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF1D1D1B),
        body: Column(
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
                  GestureDetector(
                    onTap: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                      size: 20, // Adjust size as needed
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            IssueListNew(booking: widget.booking),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    "# ${widget.booking.id.toString()} ROOMS",
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
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Room>>(
                future: _rooms,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Failed to load rooms',
                        style: TextStyle(fontSize: 18.0, color: Colors.grey),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No rooms available',
                        style: TextStyle(fontSize: 18.0, color: Colors.grey),
                      ),
                    );
                  } else {
                    final rooms = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        return Card(
                          color: Colors.black,
                          margin: const EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(
                              room.childRoomTypeName,
                              style: const TextStyle(
                                fontFamily: "GothamBlack",
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              room.roomTypeName,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontFamily: "GothamBook",
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/images/priority-active.png",
                                        width: 25,
                                        height: 25,
                                      ),
                                      const SizedBox(
                                        width: 2.0,
                                      ),
                                      Text(
                                        room.issueCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/images/priority-red.png",
                                        width: 25,
                                        height: 25,
                                      ),
                                      const SizedBox(
                                        height: 2.0,
                                      ),
                                      Text(
                                        room.highPriorityCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {},
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add your delete action here
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xffEF4444),
                    backgroundColor:
                        const Color(0xffFFD5D5), // Text color (red)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      // Border color
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontFamily: "GothamBold",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 5), // Space between buttons
                // Add Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddRoomPage(booking: widget.booking),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        const Color(0xff008138), // Text color (red)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      // Border color
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      fontFamily: "GothamBold",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Room {
  final int id;
  final int childid;
  final String roomTypeName;
  final String childRoomTypeName;
  int issueCount;
  int highPriorityCount;

  Room({
    required this.id,
    required this.childid,
    required this.roomTypeName,
    required this.childRoomTypeName,
    this.issueCount = 0,
    this.highPriorityCount = 0,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['bookingroomtypeRoomtype.id'] ?? 0,
      childid: json['bookingroomtypeChildRoomtype.id'] ?? 0,
      roomTypeName: json['bookingroomtypeRoomtype.name'] ?? 'Unknown',
      childRoomTypeName: json['bookingroomtypeChildRoomtype.name'] ?? 'Unknown',
    );
  }
}

class RoomIssue {
  final int rtParentId;
  final int rtChildId;
  final String severity;
  RoomIssue(
      {required this.rtParentId,
      required this.rtChildId,
      required this.severity});

  factory RoomIssue.fromJson(Map<String, dynamic> json) {
    return RoomIssue(
      rtParentId: json['rtParentId'] ?? 0,
      rtChildId: json['rtChildId'] ?? 0,
      severity: json['severity'] ?? '',
    );
  }
}
