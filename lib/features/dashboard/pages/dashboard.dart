import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../homepage/data/datasources/booking_local_datasource.dart';
import '../../homepage/data/datasources/booking_remote_datasource.dart';
import '../../homepage/data/models/booking.dart';
import '../../homepage/data/repository/booking_repo.dart';
import '../../homepage/pages/new_homepage.dart';
import '../../homepage/pages/new_homepage_unsectioned.dart';
import '../../login/pages/login_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  List<Booking> bookingData = [];
  bool loading = false;
  String? errorMessage;
  @override
  void initState() {
    _loadAllBookings();
    super.initState();
  }

  void _loadAllBookings() async {
    try {
      print("Loading all bookings...");
      setState(() {
        loading = true;
        errorMessage = null;
      });

      BookingRepository repository = BookingRepository(
        remoteDataSource: BookingRemoteDataSource(),
        localDataSource: BookingLocalDataSource(),
      );

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('userId');
      print("Retrieved userId: $userId");

      if (userId != null) {
        var bookingD = await repository.getAllBookings(userId);

        if (bookingD != null) {
          setState(() {
            bookingData = bookingD;
          });
        }
        setState(() {
          loading = false;
        });
      } else {
        print("User ID not found.");
        setState(() {
          loading = false;
          errorMessage = "User ID not found. Please log in again.";
        });
      }
    } catch (e) {
      print("Error loading bookings: \$e");
      setState(() {
        loading = false;
        errorMessage = "Failed to load bookings: \${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    int plannedCount = bookingData
        .where((b) =>
            b.bookingStatus == "Planned" &&
            DateTime.parse(b.visitDate).isAfter(yesterday))
        .toList()
        .length;
    int progressCount = bookingData
        .where((b) =>
            b.bookingStatus == "In Progress" &&
            DateTime.parse(b.visitDate).isAfter(yesterday))
        .toList()
        .length;
    int completedCount = bookingData
        .where((b) => b.bookingStatus == "Completed")
        .toList()
        .length;
    final statuses = [
      NewHomepage(
        bookingStatus: "Planned",
        bookingData: bookingData,
        errorMessage: errorMessage,
      ),
      NewHomepage(
        bookingStatus: "In Progress",
        bookingData: bookingData,
        errorMessage: errorMessage,
      ),
      NewHomepageUnSectioned(
        bookingStatus: "Completed",
        bookingData: bookingData,
        errorMessage: errorMessage,
      ),
    ];

    return SafeArea(
      child: (loading)
          ? const Scaffold(
              backgroundColor: Color(0xFF1D1D1B),
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ))
          : Scaffold(
              backgroundColor: const Color(0xFF1D1D1B),
              body: Column(
                children: [
                  Container(
                    color: const Color(0xFF242424),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100, // Adjust width as needed
                          height: 50, // Adjust height as needed
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.clear();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Icon(
                            Icons.power_settings_new,
                            color: Colors.white,
                            size: 20, // Adjust size as needed
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: statuses[_currentIndex],
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                selectedLabelStyle: const TextStyle(
                  fontFamily: 'GothamBook',
                  fontWeight: FontWeight.w400,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'GothamBook',
                  fontWeight: FontWeight.w400,
                ),
                items: [
                  _buildBottomNavItem(
                      "Planned ($plannedCount)",
                      "assets/images/calendar_grey.png",
                      "assets/images/calendar_white.png",
                      0),
                  _buildBottomNavItem(
                      "In Progress ($progressCount)",
                      "assets/images/in_progress_grey.png",
                      "assets/images/in_progress_white.png",
                      1),
                  _buildBottomNavItem(
                      "Completed ($completedCount)",
                      "assets/images/check_grey.png",
                      "assets/images/in_progress_white.png",
                      2),
                ],
                currentIndex: _currentIndex,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey,
                backgroundColor: const Color(0xFF1D1D1B),
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
      String label, String iconInactive, String iconActive, int index) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          if (_currentIndex == index)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 80,
              color: Colors.white, // Selected indicator
            ),
          const SizedBox(
            height: 5,
          ),
          (_currentIndex == index)
              ? Image.asset(
                  iconActive,
                  width: 20,
                )
              : Image.asset(
                  iconInactive,
                  width: 20,
                ),
        ],
      ),
      label: label,
    );
  }
}
