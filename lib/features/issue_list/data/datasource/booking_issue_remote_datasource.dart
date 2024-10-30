import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/booking_issue.dart';

class BookingIssueRemoteDataSource {
  final String baseUrl =
      'https://ilovebackend.propertycheck.me/api/bookingissue/bookingId';

  Future<List<BookingIssue>> fetchBookingIssues(int bookingId) async {
    final String apiUrl =
        '$baseUrl/$bookingId'; // Dynamically interpolate bookingId

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decode the JSON response body
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        // Convert the list of maps (JSON) to a list of BookingIssue objects
        List<BookingIssue> bookingIssues =
            jsonResponse.map<BookingIssue>((data) {
          return BookingIssue.fromJson(data as Map<String, dynamic>);
        }).toList();

        return bookingIssues;
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error occurred: $e');
      return [];
    }
  }
}
