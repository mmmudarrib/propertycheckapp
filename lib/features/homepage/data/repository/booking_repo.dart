import 'package:connectivity_plus/connectivity_plus.dart';

import '../datasources/booking_local_datasource.dart';
import '../datasources/booking_remote_datasource.dart';
import '../models/booking.dart';

class BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final BookingLocalDataSource localDataSource;

  BookingRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // Method to check the internet connection
  Future<bool> _isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return true;
  }

  Future<List<Booking>?> getAllBookings(int inspectorId) async {
    List<Booking>? bookings =
        await remoteDataSource.fetchBookingData(inspectorId);
    return bookings;
  }

  /*Future<Booking?> getBookingById(int inspectorId) async {
    bool connected = await _isConnected();
    if (connected) {
      Booking? booking = await remoteDataSource.fetchBookingData(inspectorId);
      if (booking != null) {
        await localDataSource.storeBooking(booking);
        return booking;
      } else {
        print("Failed to fetch remote data. Retrieving from local...");
      }
    } else {
      print("No internet connection. Retrieving from local...");
    }

    return await localDataSource.getBookingById(id);
  }*/
}
