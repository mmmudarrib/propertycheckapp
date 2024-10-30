import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repository/booking_repo.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository repository;

  BookingBloc(this.repository) : super(BookingInitial()) {
    on<LoadAllBookings>(_onLoadAllBookings);
  }
  void _onLoadAllBookings(
      LoadAllBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());

    try {
      // Get the user id from shared preferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('userId');

      if (userId != null) {
        // Use the retrieved id instead of hardcoded value
        final bookings = await repository.getAllBookings(userId);
        emit(BookingLoaded(bookings));
      } else {
        // If userId is null, emit an error
        emit(BookingError('User ID not found in shared preferences.'));
      }
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
