import 'package:hive/hive.dart';

import '../models/booking.dart';

class BookingLocalDataSource {
  static const String _boxName = 'bookingBox';

  // Open the Hive box
  Future<Box<Booking>> _openBox() async {
    return await Hive.openBox<Booking>(_boxName);
  }

  // Store a single booking
  Future<void> storeBooking(Booking booking) async {
    var box = await _openBox();
    await box.put('booking_${booking.id}', booking);
    await box.close();
  }

  // Store multiple bookings
  Future<void> storeBookings(List<Booking> bookings) async {
    var box = await _openBox();
    for (var booking in bookings) {
      await box.put('booking_${booking.id}', booking);
    }
    await box.close();
  }

  // Get all bookings
  Future<List<Booking>> getAllBookings() async {
    var box = await _openBox();
    List<Booking> bookings = box.values.toList();
    await box.close();
    return bookings;
  }

  // Get booking by ID
  Future<Booking?> getBookingById(int id) async {
    var box = await _openBox();
    Booking? booking = box.get('booking_$id');
    await box.close();
    return booking;
  }

  // Delete a booking by ID
  Future<void> deleteBookingById(int id) async {
    var box = await _openBox();
    await box.delete('booking_$id');
    await box.close();
  }

  // Delete all bookings
  Future<void> deleteAllBookings() async {
    var box = await _openBox();
    await box.clear();
    await box.close();
  }
}
