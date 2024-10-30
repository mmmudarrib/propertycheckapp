import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/booking.dart';

class BookingRemoteDataSource {
  Future<List<Booking>?> fetchBookingData(int inspectorId) async {
    String apiUrl =
        'https://ilovebackend.propertycheck.me/api/bookinginspector/inspector/$inspectorId';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<Booking> bookings = jsonResponse.map<Booking>((data) {
          return Booking.fromJson(data as Map<String, dynamic>);
        }).toList();

        return bookings;
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }
}
