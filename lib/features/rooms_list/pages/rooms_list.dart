import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:propertycheckapp/features/add_issue/pages/add_issue.dart';
import 'package:propertycheckapp/features/homepage/data/models/booking.dart';

import '../../../widgets/rounded_button_widget.dart';
import '../../add_issue/data/repo/issue_repo.dart';
import '../../add_room/pagew/add_room.dart';

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
    // Fetch rooms
    final roomResponse = await http.get(
      Uri.parse(
          'https://ilovebackend.propertycheck.me/api/bookingroomtype/roomlist/${widget.booking.id}'),
    );

    if (roomResponse.statusCode != 200) {
      throw Exception('Failed to load rooms');
    }

    List<dynamic> roomListJson = jsonDecode(roomResponse.body);
    List<Room> rooms = roomListJson.map((json) => Room.fromJson(json)).toList();

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
                issue.rtParentId == room.id && issue.rtChildId == room.childid)
            .length;
      }
    }

    return rooms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Room List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(
                              room.childRoomTypeName,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              room.roomTypeName,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                color: room.issueCount == 0
                                    ? Colors.red
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                '${room.issueCount} Issues',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddIssuePage(
                                    booking: widget.booking,
                                    bookingRoomType: room,
                                    repository:
                                        RepositoryProvider.of<IssueRepository>(
                                            context),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            RoundedButton(
              text: "Add New Room",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRoomPage(
                      booking: widget.booking,
                    ),
                  ),
                );
              },
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
  int issueCount; // Add this field to store the issue count

  Room({
    required this.id,
    required this.childid,
    required this.roomTypeName,
    required this.childRoomTypeName,
    this.issueCount = 0,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['bookingroomtypeRoomtype.id'],
      childid: json['bookingroomtypeChildRoomtype.id'],
      roomTypeName: json['bookingroomtypeRoomtype.name'],
      childRoomTypeName: json['bookingroomtypeChildRoomtype.name'],
    );
  }
}

class RoomIssue {
  final int rtParentId;
  final int rtChildId;

  RoomIssue({required this.rtParentId, required this.rtChildId});

  factory RoomIssue.fromJson(Map<String, dynamic> json) {
    return RoomIssue(
      rtParentId: json['rtParentId'],
      rtChildId: json['rtChildId'],
    );
  }
}
