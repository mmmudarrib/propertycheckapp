import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/add_issue/bloc/booking_issue_bloc.dart';
import 'features/add_issue/bloc/booking_issue_event.dart';
import 'features/add_issue/data/datasources/issue_remote_datasource.dart';
import 'features/add_issue/data/repo/issue_repo.dart';
import 'features/homepage/data/datasources/booking_local_datasource.dart';
import 'features/homepage/data/datasources/booking_remote_datasource.dart';
import 'features/homepage/data/repository/booking_repo.dart';
import 'features/issue_list/data/datasource/booking_issue_remote_datasource.dart';
import 'features/issue_list/data/repo/booking_issue_repo.dart';
import 'features/splash/pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize both repositories
  final bookingRepository = BookingRepository(
    remoteDataSource: BookingRemoteDataSource(),
    localDataSource: BookingLocalDataSource(),
  );

  final bookingIssueRepository = BookingIssueRepository(
    remoteDataSource: BookingIssueRemoteDataSource(),
  );

  final issueRepository = IssueRepository(
    remoteDataSource: IssueRemoteDataSource(),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<IssueFormBloc>(
          create: (context) =>
              IssueFormBloc(repository: issueRepository)..add(LoadCategories()),
        ),
      ],
      child: MultiRepositoryProvider(
        providers: [
          // Provide BookingIssueRepository
          RepositoryProvider<BookingIssueRepository>(
            create: (_) => bookingIssueRepository,
          ),
          // Provide IssueRepository
          RepositoryProvider<IssueRepository>(
            create: (_) => issueRepository,
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
