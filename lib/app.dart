import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:time_progress_tracker/models/app_state.dart';
import 'package:time_progress_tracker/screens/progress_creation_screen.dart';
import 'package:time_progress_tracker/screens/progress_dashboard_screen.dart';
import 'package:time_progress_tracker/screens/progress_detail_screen.dart';

class TimeProgressTrackerApp extends StatelessWidget {
  static const String name = "Time Progress Tracker";

  final Store<AppState> store;

  TimeProgressTrackerApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: "Time Progress Tracker",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: ProgressDashboardScreen.routeName,
        routes: {
          ProgressDashboardScreen.routeName: (BuildContext context) =>
              ProgressDashboardScreen(),
          ProgressDetailScreen.routeName: (BuildContext context) =>
              ProgressDetailScreen(),
          ProgressCreationScreen.routeName: (BuildContext context) =>
              ProgressCreationScreen(),
        },
      ),
    );
  }
}
