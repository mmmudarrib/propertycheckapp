import 'package:equatable/equatable.dart';

// Abstract class for all events
abstract class IssueListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event to load issues by bookingId
class LoadIssues extends IssueListEvent {
  final int bookingId;

  LoadIssues(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}
