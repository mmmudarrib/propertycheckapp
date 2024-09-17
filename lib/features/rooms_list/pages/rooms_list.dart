import 'package:flutter/material.dart';
import 'package:propertycheckapp/features/add_issue/pages/add_issue.dart';

import '../../../widgets/rounded_button_widget.dart';
import '../../add_room/pagew/add_room.dart';

class RoomListPage extends StatelessWidget {
  final List<Map<String, dynamic>> rooms = [
    {
      "roomId": 1,
      "roomTypeId": "101",
      "roomType": "Hall",
      "roomSubtypeId": "201",
      "roomSubtype": "Living Room"
    },
    {
      "roomId": 2,
      "roomTypeId": "102",
      "roomType": "Kitchen",
      "roomSubtypeId": "202",
      "roomSubtype": "Master Kitchen"
    },
    {
      "roomId": 3,
      "roomTypeId": "103",
      "roomType": "Bedroom",
      "roomSubtypeId": "203",
      "roomSubtype": "Bedroom 1"
    },
    {
      "roomId": 4,
      "roomTypeId": "103",
      "roomType": "Bedroom",
      "roomSubtypeId": "203",
      "roomSubtype": "Bedroom 2"
    },
  ];

  RoomListPage({super.key});

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
              child: ListView.builder(
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
                        room['roomType'],
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        room['roomSubtype'],
                        style:
                            const TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                      trailing:
                          Icon(Icons.arrow_forward, color: Colors.grey[600]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddIssuePage(
                              selectedRoomType: room['roomType'],
                              selectedRoomSubtype: room['roomSubtype'],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            RoundedButton(
                text: "Add New Room",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddRoomPage(),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
