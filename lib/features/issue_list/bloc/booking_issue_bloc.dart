import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/booking_issue_repo.dart';
import 'booking_issue_event.dart';
import 'booking_issue_state.dart';

class IssueListBloc extends Bloc<IssueListEvent, IssueListState> {
  final BookingIssueRepository repository; // Add the repository as a dependency

  IssueListBloc({required this.repository}) : super(IssueListInitial()) {
    on<LoadIssues>(_onLoadIssues);
  }

  // Method to load issues when the LoadIssues event is triggered
  Future<void> _onLoadIssues(
      LoadIssues event, Emitter<IssueListState> emit) async {
    emit(IssueListLoading());

    try {
      // Call the repository to fetch issues based on bookingId
      final issues = await repository.getBookingIssues(event.bookingId);

      if (issues.isNotEmpty) {
        // Map the fetched issues to Issue model instances

        emit(IssueListLoaded(issues));
      } else {
        emit(IssueListError('No issues added for this booking yet'));
      }
    } catch (e) {
      emit(IssueListError('Failed to load issues: $e'));
    }
  }
}
