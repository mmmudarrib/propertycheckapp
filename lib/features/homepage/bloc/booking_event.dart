import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAllBookings extends BookingEvent {}
