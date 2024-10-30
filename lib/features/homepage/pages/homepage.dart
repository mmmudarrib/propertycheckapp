import 'package:flutter/material.dart';
import 'package:propertycheckapp/features/homepage/data/datasources/booking_local_datasource.dart';
import 'package:propertycheckapp/features/homepage/data/datasources/booking_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../../visit_details/pages/visit_details_page.dart';
import '../data/models/booking.dart';
import '../data/repository/booking_repo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Booking> bookings = List.empty();
  bool loading = false;
  @override
  void initState() {
    _LoadAllBookings();
    super.initState();
  }

  void _LoadAllBookings() async {
    try {
      setState(() {
        loading = true;
      });
      BookingRepository repository = BookingRepository(
          remoteDataSource: BookingRemoteDataSource(),
          localDataSource: BookingLocalDataSource());
      // Get the user id from shared preferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('userId');

      if (userId != null) {
        var bookingData = await repository.getAllBookings(userId);
        setState(() {
          bookings = bookingData ?? [];
          loading = false;
        });
      } else {
        // If userId is null, emit an error
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildOverviewCard(bookings),
                const SizedBox(height: 20.0),
                const Text(
                  'Planned Visits',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10.0),
                buildPlannedVisitsList(),
              ],
            ),
          );
  }

  Widget buildOverviewCard(List<Booking> bookings) {
    int plannedCount =
        bookings.where((b) => b.bookingStatus == 'Planned').length;
    int completedCount =
        bookings.where((b) => b.bookingStatus == 'Completed').length;
    int inProgressCount =
        bookings.where((b) => b.bookingStatus == 'In Progress').length;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: AppColors.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildOverviewItem(
                'Planned', plannedCount.toString(), Icons.schedule),
            buildOverviewItem(
                'In Progress', inProgressCount.toString(), Icons.pending),
            buildOverviewItem(
                'Completed', completedCount.toString(), Icons.check_circle),
          ],
        ),
      ),
    );
  }

  Widget buildOverviewItem(String title, String count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30.0),
        const SizedBox(height: 8.0),
        Text(
          count,
          style: const TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildPlannedVisitsList() {
    return bookings.isEmpty
        ? const Center(
            child: Text(
              'No bookings found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          )
        : Column(
            children: bookings.map((booking) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisitDetailPage(
                        booking: booking,
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    title: Text(
                      booking.area,
                      style: const TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      '${booking.visitDate} - ${booking.clientName}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Text(
                      booking.bookingStatus,
                      style: TextStyle(
                        color: booking.bookingStatus != "Planned"
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
  }
}
