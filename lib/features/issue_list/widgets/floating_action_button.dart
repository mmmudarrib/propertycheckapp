import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../../add_issue/pages/add_issue_new.dart';
import '../../homepage/data/models/booking.dart';
import '../../report_comments_page/pages/report_comments_page.dart';
import '../../rooms_list/pages/rooms_list.dart';

class ExpandableFabMenu extends StatelessWidget {
  final Booking booking;
  const ExpandableFabMenu({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      duration: const Duration(milliseconds: 100),
      distance: 70.0,
      type: ExpandableFabType.up,
      pos: ExpandableFabPos.right,
      childrenAnimation: ExpandableFabAnimation.none,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        angle: 3.14 * 2,
      ),
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.close),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        angle: 3.14 * 2,
      ),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 8,
                offset: Offset(2, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              const Text(
                'Add Issue',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'GothamBold',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 20),
              FloatingActionButton.small(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                heroTag: null,
                child: Image.asset(
                  "assets/images/issue-black.png",
                  width: 25,
                  height: 25,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddIssueScreenNew(
                        booking: booking,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 8,
                offset: Offset(2, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              const Text(
                'Add/Edit Room',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'GothamBold',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 20),
              FloatingActionButton.small(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                heroTag: null,
                child: Image.asset(
                  "assets/images/add-room.png",
                  width: 25,
                  height: 25,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomListPage(
                        booking: booking,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 8,
                offset: Offset(2, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              const Text(
                'Complete Property Check',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'GothamBold',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 20),
              FloatingActionButton.small(
                shape: const CircleBorder(),
                backgroundColor: const Color.fromARGB(255, 235, 202, 213),
                heroTag: null,
                child: Image.asset(
                  "assets/images/complete-black.png",
                  width: 25,
                  height: 25,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportCommentsPage(
                        booking: booking,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
