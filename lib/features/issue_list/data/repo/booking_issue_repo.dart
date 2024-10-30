import '../datasource/booking_issue_remote_datasource.dart';
import '../model/booking_issue.dart';

class BookingIssueRepository {
  final BookingIssueRemoteDataSource remoteDataSource;

  BookingIssueRepository({
    required this.remoteDataSource,
  });

  // Method to fetch booking issues by bookingId
  Future<List<BookingIssue>> getBookingIssues(int bookingId) async {
    try {
      // Fetch the booking issues from the remote data source
      var bookingIssues =
          await remoteDataSource.fetchBookingIssues(bookingId);
      return bookingIssues;
    } catch (e) {
      // Handle any errors that may occur during the API call
      print('Error fetching booking issues: $e');
      return [];
    }
  }
}
