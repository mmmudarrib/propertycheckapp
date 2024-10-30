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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
